import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../controllers/auth_controller.dart';
import '../controllers/user_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Core services
    Get.lazyPut<AuthService>(() => AuthService(Get.find()));

    // Controllers
    Get.lazyPut<UserController>(() => UserController());
    Get.lazyPut<AuthController>(() => AuthController(Get.find()));
  }
}
