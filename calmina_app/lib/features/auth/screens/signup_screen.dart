import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppTheme.peachLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: controller.fullNameController,
              decoration: const InputDecoration(
                labelText: 'Full name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.ageController,
              decoration: const InputDecoration(
                labelText: 'Age',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            Obx(() => TextFormField(
              controller: controller.passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
              ),
              obscureText: !controller.isPasswordVisible.value,
            )),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () async {
                        try {
                          await controller.signUp();
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'email-already-in-use') {
                            // Show dialog instead of error message
                            Get.dialog(
                              AlertDialog(
                                title: const Text('Account Exists'),
                                content: const Text(
                                  'An account with this email already exists. Would you like to sign in instead?'
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Get.back(); // Close dialog
                                      Get.offNamed('/signin'); // Go to sign in
                                    },
                                    child: const Text('Yes, Sign In'),
                                  ),
                                  TextButton(
                                    onPressed: () => Get.back(), // Just close dialog
                                    child: const Text('No, Stay Here'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            Get.snackbar(
                              'Error',
                              controller.errorMessage.value,
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red.withOpacity(0.1),
                              colorText: Colors.red,
                            );
                          }
                        } catch (e) {
                          Get.snackbar(
                            'Error',
                            controller.errorMessage.value,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red.withOpacity(0.1),
                            colorText: Colors.red,
                          );
                        }
                      },
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Sign Up'),
              )),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => Get.offNamed('/signin'),
                child: const Text(
                  'Already have an account?',
                  style: TextStyle(color: AppTheme.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 