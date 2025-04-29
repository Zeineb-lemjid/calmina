import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/controllers/auth_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Get.toNamed('/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authController.signOut(),
          ),
        ],
      ),
      body: Obx(() {
        final user = authController.currentUser;

        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome, ${user.displayName ?? user.email ?? 'User'}!'),
              const SizedBox(height: 20),
              // Add your home screen content here
            ],
          ),
        );
      }),
    );
  }
}
