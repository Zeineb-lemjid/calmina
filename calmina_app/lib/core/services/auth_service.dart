import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final SharedPreferences _prefs;

  AuthService(this._prefs);

  Stream<User?> get authStateChanges => _auth.authStateChanges();

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

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user profile
      if (displayName != null) {
        await userCredential.user?.updateDisplayName(displayName);
      }

      // Send verification email
      await userCredential.user?.sendEmailVerification();

      // Create user document in Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'email': email,
        'displayName': displayName,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
        'emailVerified': false,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
    String? phoneNumber,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await user.updateDisplayName(displayName);
    await user.updatePhotoURL(photoURL);
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
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Google sign in aborted');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      // Create or update user document
      if (userCredential.user != null) {
        await _updateUserData(userCredential.user!);
      }

      return userCredential;
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
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
    if (user == null) throw Exception('User not logged in');

    // Delete user data from Firestore
    await _firestore.collection('users').doc(user.uid).delete();

    // Delete user account
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
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _prefs.setBool('biometric_auth_enabled', true);
    await _firestore.collection('users').doc(user.uid).update({
      'biometricAuthEnabled': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> disableBiometricAuth() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _prefs.setBool('biometric_auth_enabled', false);
    await _firestore.collection('users').doc(user.uid).update({
      'biometricAuthEnabled': false,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<bool> isBiometricAuthEnabled() async {
    return _prefs.getBool('biometric_auth_enabled') ?? false;
  }

  // Language preferences
  Future<void> setLanguagePreference(String languageCode) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _prefs.setString('language_code', languageCode);
    await _firestore.collection('users').doc(user.uid).update({
      'languageCode': languageCode,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<String> getLanguagePreference() async {
    return _prefs.getString('language_code') ?? 'en';
  }

  // Theme preferences
  Future<void> setThemePreference(bool isDarkMode) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _prefs.setBool('dark_mode', isDarkMode);
    await _firestore.collection('users').doc(user.uid).update({
      'darkMode': isDarkMode,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<bool> getThemePreference() async {
    return _prefs.getBool('dark_mode') ?? false;
  }

  // Notification preferences
  Future<void> setNotificationPreference(bool enabled) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _prefs.setBool('notifications_enabled', enabled);
    await _firestore.collection('users').doc(user.uid).update({
      'notificationsEnabled': enabled,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<bool> getNotificationPreference() async {
    return _prefs.getBool('notifications_enabled') ?? true;
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
}
