import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Future<SharedPreferences> _prefs;

  AuthService(this._prefs);

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Stream<UserModel?> get userStream {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      return await _getUserData(user.uid);
    });
  }

  Future<UserModel?> _getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return null;
      return UserModel.fromJson(doc.data()!);
    } catch (e) {
      return null;
    }
  }

  Future<UserCredential> signUp(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _saveUserSession(userCredential.user!);
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> signIn(String email, String password) async {
    try {
      print('Attempting to sign in user with email: $email');
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      print('Sign in successful for user: ${userCredential.user?.uid}');
      
      // Update last login timestamp in Firestore
      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).update({
          'lastLoginAt': FieldValue.serverTimestamp(),
        });
      }
      
      await _saveUserSession(userCredential.user!);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error during sign in: ${e.code} - ${e.message}');
      throw FirebaseAuthException(
        code: e.code,
        message: _handleAuthException(e),
      );
    } catch (e) {
      print('Unexpected error during sign in: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _clearUserSession();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
    String? phoneNumber,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user signed in');

    if (displayName != null) {
      await user.updateDisplayName(displayName);
    }
    if (photoURL != null) {
      await user.updatePhotoURL(photoURL);
    }
    if (phoneNumber != null) {
      await user.updatePhoneNumber(PhoneAuthProvider.credential(
        verificationId: '',
        smsCode: '',
      ));
    }

    await _updateUserData(user);
  }

  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<bool> isEmailVerified() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      return user.emailVerified;
    }
    return false;
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      final userCredential = await _auth.signInWithCredential(credential);

      // Create or update user document in Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'email': userCredential.user?.email,
        'displayName': userCredential.user?.displayName,
        'photoURL': userCredential.user?.photoURL,
        'lastLoginAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await _saveUserSession(userCredential.user!);
      return userCredential;
    } catch (e) {
      print('Google Sign In Error: $e');
      rethrow;
    }
  }

  Future<void> _updateUserData(User user) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    final userData = {
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      'lastLoginAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    final doc = await userDoc.get();
    if (doc.exists) {
      await userDoc.update(userData);
    } else {
      await userDoc.set({
        ...userData,
        'createdAt': FieldValue.serverTimestamp(),
        'emailVerified': user.emailVerified,
      });
    }
  }

  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user signed in');
    await user.delete();
  }

  Future<void> changePassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await user.updatePassword(newPassword);
  }

  Future<void> reauthenticate(String password) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );
    await user.reauthenticateWithCredential(credential);
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'The email address is already in use.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password is too weak.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  // User preferences management
  Future<void> saveUserPreferences(Map<String, dynamic> preferences) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _firestore.collection('users').doc(user.uid).update({
      'preferences': preferences,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>> getUserPreferences() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final doc = await _firestore.collection('users').doc(user.uid).get();
    return doc.data()?['preferences'] ?? {};
  }

  // Activity tracking
  Future<void> updateLastActive() async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).update({
      'lastActiveAt': FieldValue.serverTimestamp(),
    });
  }

  // Biometric authentication
  Future<void> enableBiometricAuth() async {
    final prefs = await _prefs;
    await prefs.setBool('biometric_auth_enabled', true);
  }

  Future<void> disableBiometricAuth() async {
    final prefs = await _prefs;
    await prefs.setBool('biometric_auth_enabled', false);
  }

  Future<bool> isBiometricAuthEnabled() async {
    final prefs = await _prefs;
    return prefs.getBool('biometric_auth_enabled') ?? false;
  }

  // Language preferences
  Future<void> setLanguagePreference(String languageCode) async {
    final prefs = await _prefs;
    await prefs.setString('language_code', languageCode);
  }

  Future<String> getLanguagePreference() async {
    final prefs = await _prefs;
    return prefs.getString('language_code') ?? 'en';
  }

  // Theme preferences
  Future<void> setThemePreference(bool isDarkMode) async {
    final prefs = await _prefs;
    await prefs.setBool('dark_mode', isDarkMode);
  }

  Future<bool> getThemePreference() async {
    final prefs = await _prefs;
    return prefs.getBool('dark_mode') ?? false;
  }

  // Notification preferences
  Future<void> setNotificationPreference(bool enabled) async {
    final prefs = await _prefs;
    await prefs.setBool('notifications_enabled', enabled);
  }

  Future<bool> getNotificationPreference() async {
    final prefs = await _prefs;
    return prefs.getBool('notifications_enabled') ?? true;
  }

  // Session management
  Future<void> updateUserActivity() async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).update({
      'lastActiveAt': FieldValue.serverTimestamp(),
      'activeSessions': FieldValue.increment(1),
    });
  }

  Future<void> clearUserActivity() async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).update({
      'activeSessions': 0,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // User session management
  Future<void> _saveUserSession(User user) async {
    final prefs = await _prefs;
    await prefs.setString('userId', user.uid);
    await prefs.setString('userEmail', user.email ?? '');
  }

  Future<void> _clearUserSession() async {
    final prefs = await _prefs;
    await prefs.remove('userId');
    await prefs.remove('userEmail');
  }
}
