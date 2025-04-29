import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/storage_service.dart';

class ProfileController extends GetxController {
  final AuthService _authService;
  final StorageService _storageService;
  final _imagePicker = ImagePicker();

  final isLoading = false.obs;
  final user = Rxn();

  ProfileController({
    required AuthService authService,
    required StorageService storageService,
  })  : _authService = authService,
        _storageService = storageService {
    // Listen to auth state changes
    _authService.authStateChanges.listen((currentUser) {
      user.value = currentUser;
    });
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

  void signOut() {
    _authService.signOut();
  }
}
