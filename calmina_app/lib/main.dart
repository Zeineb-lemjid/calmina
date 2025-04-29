import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'core/routes/app_routes.dart';
import 'core/services/auth_service.dart';
import 'core/services/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/controllers/user_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Add error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint(details.toString());
  };

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  final authService = AuthService(prefs);
  final storageService = StorageService();

  runApp(MyApp(
    authService: authService,
    storageService: storageService,
  ));
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  final StorageService storageService;

  const MyApp({
    super.key,
    required this.authService,
    required this.storageService,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize core services
    Get.put(authService);
    Get.put(storageService);

    // Initialize controllers
    Get.put(UserController());
    Get.put(AuthController(authService));

    return GetMaterialApp(
      title: 'Calmina App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: '/login',
      getPages: AppRoutes.routes,
    );
  }
}
