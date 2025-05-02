import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/auth_controller.dart';

class DoctorSignUpScreen extends StatelessWidget {
  const DoctorSignUpScreen({super.key});

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
              'Doctor Sign Up',
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
              controller: controller.specialtyController,
              decoration: const InputDecoration(
                labelText: 'Specialty',
                prefixIcon: Icon(Icons.medical_services_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.licenseController,
              decoration: const InputDecoration(
                labelText: 'License Number',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
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
            TextFormField(
              controller: controller.passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await controller.signUpDoctor();
                    Get.offAllNamed('/home');
                  } catch (e) {
                    Get.snackbar(
                      'Error',
                      e.toString(),
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red.withOpacity(0.1),
                      colorText: Colors.red,
                    );
                  }
                },
                child: const Text('Sign Up as Doctor'),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => Get.toNamed('/signin'),
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