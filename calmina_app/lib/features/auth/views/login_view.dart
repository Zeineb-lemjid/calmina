import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(32.0),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Calmina',
                  style: Get.textTheme.headlineMedium,
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                              if (emailController.text.isNotEmpty &&
                                  passwordController.text.isNotEmpty) {
                                controller.signIn(
                                  emailController.text,
                                  passwordController.text,
                                );
                              } else {
                                Get.snackbar(
                                  'Error',
                                  'Please fill in all fields',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
                            },
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator()
                          : const Text('Sign In'),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 