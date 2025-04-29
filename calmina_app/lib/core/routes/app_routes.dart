import 'package:get/get.dart';
import '../../features/auth/bindings/auth_binding.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/profile/bindings/profile_binding.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../middleware/auth_middleware.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';

  static final routes = [
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: register,
      page: () => const RegisterScreen(),
      binding: AuthBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      binding: AuthBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: profile,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
