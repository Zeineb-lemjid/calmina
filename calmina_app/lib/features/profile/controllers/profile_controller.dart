import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/storage_service.dart';
import '../../auth/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  final AuthService _authService;
  final StorageService _storageService;
  final AuthController _authController;
  final _imagePicker = ImagePicker();

  final Rx<User?> user = Rx<User?>(null);
  final RxInt streakDays = 0.obs;
  final RxInt totalMoods = 0.obs;
  final RxInt totalMeditations = 0.obs;

  final isLoading = false.obs;

  ProfileController({
    required AuthService authService,
    required StorageService storageService,
    required AuthController authController,
  })  : _authService = authService,
        _storageService = storageService,
        _authController = authController;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    _loadStats();
  }

  void _loadUserData() {
    final currentUser = _authService.currentUser;
    user.value = currentUser;
  }

  Future<void> _loadStats() async {
    if (user.value != null) {
      // Load streak days
      final streak = await _storageService.getStreakDays(user.value!.uid);
      streakDays.value = streak;

      // Load total moods
      final moods = await _storageService.getTotalMoods(user.value!.uid);
      totalMoods.value = moods;

      // Load total meditations
      final meditations = await _storageService.getTotalMeditations(user.value!.uid);
      totalMeditations.value = meditations;
    }
  }

  Future<void> updateProfile({
    String? displayName,
    String? phoneNumber,
    String? photoURL,
  }) async {
    try {
      isLoading.value = true;
      await _authService.updateUserProfile(
        displayName: displayName,
        phoneNumber: phoneNumber,
        photoURL: photoURL,
      );
      Get.snackbar('Success', 'Profile updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickAndUploadImage() async {
    try {
      final pickedFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null && user.value != null) {
        isLoading.value = true;
        final downloadUrl = await _storageService.uploadFile(
          File(pickedFile.path),
          user.value!.uid,
          folder: 'profile_pictures',
        );
        await updateProfile(photoURL: downloadUrl);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload image: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      isLoading.value = true;
      await _authService.reauthenticate(oldPassword);
      await _authService.changePassword(newPassword);
      Get.snackbar('Success', 'Password changed successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to change password: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;
      await _authService.deleteAccount();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete account: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editProfile() async {
    // TODO: Implement profile editing
  }

  Future<void> signOut() async {
    await _authController.signOut();
  }
}
