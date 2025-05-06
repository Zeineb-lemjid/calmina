import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter/foundation.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'core/bindings/app_bindings.dart';
import 'firebase_options.dart';
import 'core/services/auth_service.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> initializeFirebase({int retryCount = 0}) async {
  try {
    if (retryCount > 3) {
      print('Maximum retry attempts reached');
      return false;
    }

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');

    // Clear any existing persistence
    await FirebaseFirestore.instance.clearPersistence();
    
    // Configure Firestore settings
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    // Test connection
    await FirebaseFirestore.instance.collection('users').doc('test').set(
      {'timestamp': FieldValue.serverTimestamp()},
      SetOptions(merge: true),
    );
    print('Firestore connection verified');
    
    return true;
  } catch (e) {
    print('Firebase initialization error: $e');
    if (e.toString().contains('network') || e.toString().contains('timeout')) {
      print('Retrying initialization... Attempt ${retryCount + 1}');
      await Future.delayed(const Duration(seconds: 2));
      return initializeFirebase(retryCount: retryCount + 1);
    }
    return false;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure web platform
  usePathUrlStrategy();
  
  try {
    final initialized = await initializeFirebase();
    if (!initialized) {
      throw Exception('Failed to initialize Firebase after multiple attempts');
    }

    // Initialize SharedPreferences
    final sharedPreferences = await SharedPreferences.getInstance();
    
    // Initialize dependencies
    Get.put<AuthService>(AuthService(Future.value(sharedPreferences)), permanent: true);
    Get.put<AuthController>(AuthController(Get.find<AuthService>()), permanent: true);

    runApp(const MyApp());
  } catch (e, stackTrace) {
    print('Error in main: $e');
    print('Stack trace: $stackTrace');
    runApp(const ErrorApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Calmina',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: AppRouter.routes,
      initialBinding: AppBindings(),
      defaultTransition: Transition.fade,
    );
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                'Error initializing app',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please check your internet connection and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  // Try to reinitialize Firebase
                  final initialized = await initializeFirebase();
                  if (initialized) {
                    main();
                  }
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
