import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final RxString currentMood = ''.obs;
  final RxString userName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final user = _authService.currentUser;
    if (user != null) {
      userName.value = user.displayName ?? 'User';
    }
  }

  void setMood(String mood) {
    currentMood.value = mood;
    // TODO: Save mood to database
  }

  Future<void> signOut() async {
    await _authService.signOut();
    Get.offAllNamed('/');
  }
} 