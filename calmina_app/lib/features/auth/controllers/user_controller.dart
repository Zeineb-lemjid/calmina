import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/models/user_model.dart';

class UserController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Rxn<UserModel> _user = Rxn<UserModel>();
  final _isLoading = false.obs;

  UserModel? get user => _user.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen(_handleAuthStateChanges);
  }

  Future<void> _handleAuthStateChanges(User? firebaseUser) async {
    if (firebaseUser == null) {
      _user.value = null;
      return;
    }

    try {
      _isLoading.value = true;
      final docSnapshot =
          await _firestore.collection('users').doc(firebaseUser.uid).get();

      if (docSnapshot.exists) {
        _user.value = UserModel.fromFirestore(docSnapshot);
      } else {
        // Create new user document if it doesn't exist
        final newUser = UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email!,
          displayName: firebaseUser.displayName,
          photoURL: firebaseUser.photoURL,
          isEmailVerified: firebaseUser.emailVerified,
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .set(newUser.toFirestore());

        _user.value = newUser;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load user data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
    String? phoneNumber,
    Map<String, dynamic>? preferences,
  }) async {
    try {
      _isLoading.value = true;

      if (_user.value == null) return;

      final updates = _user.value!.copyWith(
        displayName: displayName,
        photoURL: photoURL,
        phoneNumber: phoneNumber,
        preferences: preferences,
        lastLoginAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(_user.value!.id)
          .update(updates.toFirestore());

      if (displayName != null) {
        await _auth.currentUser?.updateDisplayName(displayName);
      }
      if (photoURL != null) {
        await _auth.currentUser?.updatePhotoURL(photoURL);
      }

      _user.value = updates;

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> deleteAccount() async {
    try {
      _isLoading.value = true;

      if (_user.value == null) return;

      await _firestore.collection('users').doc(_user.value!.id).delete();

      await _auth.currentUser?.delete();

      _user.value = null;
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete account: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }
}
