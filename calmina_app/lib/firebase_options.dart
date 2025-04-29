import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // Web configuration
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: "AIzaSyCttaAOleONlhE-KugqfLXVMhBL4mzb00w",
        authDomain: "calmina-dc2ac.firebaseapp.com",
        projectId: "calmina-dc2ac",
        storageBucket: "calmina-dc2ac.firebasestorage.app",
        messagingSenderId: "567948546173",
        appId: "1:567948546173:web:860b79fdd3a5d0f957a114",
      );
    }

    // Desktop/Mobile configuration
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const FirebaseOptions(
          apiKey: "AIzaSyCttaAOleONlhE-KugqfLXVMhBL4mzb00w",
          appId: "1:567948546173:android:860b79fdd3a5d0f957a114",
          messagingSenderId: "567948546173",
          projectId: "calmina-dc2ac",
          storageBucket: "calmina-dc2ac.firebasestorage.app",
        );
      case TargetPlatform.iOS:
        return const FirebaseOptions(
          apiKey: "AIzaSyCttaAOleONlhE-KugqfLXVMhBL4mzb00w",
          appId: "1:567948546173:ios:860b79fdd3a5d0f957a114",
          messagingSenderId: "567948546173",
          projectId: "calmina-dc2ac",
          storageBucket: "calmina-dc2ac.firebasestorage.app",
        );
      case TargetPlatform.windows:
        return const FirebaseOptions(
          apiKey: "AIzaSyCttaAOleONlhE-KugqfLXVMhBL4mzb00w",
          appId: "1:567948546173:windows:860b79fdd3a5d0f957a114",
          messagingSenderId: "567948546173",
          projectId: "calmina-dc2ac",
          storageBucket: "calmina-dc2ac.firebasestorage.app",
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
}
