import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'user_controller.dart';

class AuthController extends GetxController {
  final AuthService _authService;
  final _isLoading = false.obs;
  final _user = Rxn<User>();
  late final UserController _userController;

  AuthController(this._authService) {
    _userController = Get.find<UserController>();
    _user.bindStream(_authService.authStateChanges);
  }

  bool get isLoading => _isLoading.value;
  User? get currentUser => _user.value;

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading.value = true;
      await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      _isLoading.value = true;
      await _authService.signInWithGoogle();
    } catch (e) {
      if (e.toString().contains('The OAuth client was not found')) {
        Get.snackbar(
          'Error',
          'Google Sign-in is not properly configured. Please check Firebase Console settings.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
        );
      } else {
        Get.snackbar(
          'Error',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading.value = true;
      await _authService.signOut();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      _isLoading.value = true;
      await _authService.resetPassword(email);
      Get.snackbar(
        'Success',
        'Password reset email sent. Please check your inbox.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> createAccount({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      _isLoading.value = true;
      await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
    String? phoneNumber,
  }) async {
    try {
      _isLoading.value = true;
      await _userController.updateProfile(
        displayName: displayName,
        photoURL: photoURL,
        phoneNumber: phoneNumber,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> deleteAccount() async {
    try {
      _isLoading.value = true;
      await _userController.deleteAccount();
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }
}
