import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../../features/auth/controllers/auth_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Initialize SharedPreferences lazily
    Get.lazyPut<Future<SharedPreferences>>(() => SharedPreferences.getInstance());
    
    // Initialize AuthService with lazy SharedPreferences
    Get.lazyPut<AuthService>(
      () => AuthService(Get.find<Future<SharedPreferences>>()),
      fenix: true
    );
    
    // Initialize AuthController
    Get.lazyPut<AuthController>(
      () => AuthController(Get.find<AuthService>()),
      fenix: true
    );
  }
} 