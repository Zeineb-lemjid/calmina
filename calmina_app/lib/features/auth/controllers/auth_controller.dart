import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final RxBool isPasswordVisible = false.obs;
  final _authService = FirebaseAuth.instance;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      debugPrint('Attempting to sign in with email: $email');
      // Input validation
      if (email.isEmpty || password.isEmpty) {
        throw 'Please fill in all fields';
      }
      debugPrint('Sign in successful. Getting user role...');
      if (!GetUtils.isEmail(email)) {
        throw 'Please enter a valid email address';
      }

      debugPrint('Attempting to sign in with email: $email');

      // Sign in user
      final userCredential = await _authService.signInWithEmailAndPassword(
          email: email.trim(), password: password);

      debugPrint('Sign in successful. Getting user role...');

      // Get user role from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();

      if (!userDoc.exists) {
        throw 'User data not found';
      }

      final userData = userDoc.data()!;
      final role = userData['role'] as String?;
      debugPrint('User role: $role');
      // Navigate based on role
      if (role == 'doctor') {
        Get.offAllNamed('/doctor-home');
      } else {
        Get.offAllNamed('/home');
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Error: ${e.code} - ${e.message}');
      switch (e.code) {
        case 'user-not-found':
          errorMessage.value = 'No user found for this email.';
          break;
        case 'wrong-password':
          errorMessage.value = 'Incorrect password.';
          break;
        case 'invalid-email':
          errorMessage.value = 'Please enter a valid email address';
          break;
        case 'user-disabled':
          errorMessage.value = 'This account has been disabled';
          break;
        case 'network-request-failed':
          errorMessage.value =
              'Network error. Please check your internet connection';
          break;
        default:
          errorMessage.value = e.message ?? 'An error occurred during sign in.';
      }
      // Show error snackbar
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 3),
      );
      rethrow;
    } catch (e) {
      debugPrint('General Error during sign in: $e');
      errorMessage.value = e.toString();
      // Show error snackbar
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 3),
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
