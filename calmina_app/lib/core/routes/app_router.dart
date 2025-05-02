import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/auth/screens/signin_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/auth/screens/doctor_signup_screen.dart';
import '../../features/auth/screens/reset_password_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/home/screens/mood_tracker_screen.dart';
import '../../features/chat/screens/chat_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../services/auth_service.dart';

class AppRouter {
  static final routes = [
    GetPage(
      name: '/',
      page: () => const OnboardingScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: '/signin',
      page: () => const SignInScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: '/signup',
      page: () => const SignUpScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: '/doctor-signup',
      page: () => const DoctorSignUpScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: '/reset-password',
      page: () => const ResetPasswordScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: '/home',
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/mood-tracker',
      page: () => const MoodTrackerScreen(),
      transition: Transition.rightToLeft,
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/chat',
      page: () => const ChatScreen(),
      transition: Transition.rightToLeft,
      middlewares: [AuthMiddleware()],
    ),
  ];

  static void configureRoutes() {
    Get.config(
      enableLog: true,
      defaultTransition: Transition.fade,
      defaultDurationTransition: const Duration(milliseconds: 250),
    );
  }
}

class AuthMiddleware extends GetMiddleware {
  final AuthService _authService = Get.find<AuthService>();

  @override
  RouteSettings? redirect(String? route) {
    return _authService.currentUser == null ? const RouteSettings(name: '/signin') : null;
  }
} 