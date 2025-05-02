import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/auth_controller.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
              'Sign In',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 30),
            Obx(() => TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
              enabled: !controller.isLoading.value,
            )),
            const SizedBox(height: 16),
            Obx(() => TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordVisible.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                    ),
                    onPressed: () => controller.togglePasswordVisibility(),
                  ),
                  ),
                  obscureText: !controller.isPasswordVisible.value,
              enabled: !controller.isLoading.value,
            )),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Get.toNamed('/reset-password'),
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(color: AppTheme.primary),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () async {
                        try {
                          await controller.signIn(
                            emailController.text,
                            passwordController.text,
                          );
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
                    ? const CircularProgressIndicator()
                    : const Text('Sign In'),
              ),
            )),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => Get.toNamed('/signup'),
                child: const Text(
                  'Don\'t have an account? Sign Up',
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