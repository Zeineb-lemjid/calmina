import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  final Rx<User?> user = Rx<User?>(null);
  final RxString userRole = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
    ever(user, _handleAuthChanged);
  }

  void _handleAuthChanged(User? user) async {
    if (user != null) {
      isLoading.value = true;
      try {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          userRole.value = userDoc.data()?['role'] ?? '';
          _navigateBasedOnRole();
        }
      } catch (e) {
        print('Error fetching user role: $e');
      } finally {
        isLoading.value = false;
      }
    } else {
      userRole.value = '';
      Get.offAllNamed('/login');
    }
  }

  void _navigateBasedOnRole() {
    switch (userRole.value) {
      case 'patient':
        Get.offAllNamed('/patient/dashboard');
        break;
      case 'docteur':
        Get.offAllNamed('/docteur/dashboard');
        break;
      default:
        Get.offAllNamed('/login');
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign in: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign out: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
} 