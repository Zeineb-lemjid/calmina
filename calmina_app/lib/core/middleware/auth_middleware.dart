import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/auth/controllers/auth_controller.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    // If the user is not logged in and trying to access a protected route
    if (authController.currentUser == null &&
        route != '/login' &&
        route != '/register') {
      return const RouteSettings(name: '/login');
    }

    // If the user is logged in and trying to access auth routes
    if (authController.currentUser != null &&
        (route == '/login' || route == '/register')) {
      return const RouteSettings(name: '/home');
    }

    return null;
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    return page;
  }
}
