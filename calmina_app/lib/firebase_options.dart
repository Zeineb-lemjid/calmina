import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCttaAOleONlhE-KugqfLXVMhBL4mzb00w',
    authDomain: 'calmina-dc2ac.firebaseapp.com',
    projectId: 'calmina-dc2ac',
    storageBucket: 'calmina-dc2ac.firebasestorage.app',
    messagingSenderId: '567948546173',
    appId: '1:567948546173:web:860b79fdd3a5d0f957a114',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'REPLACE-WITH-YOUR-ANDROID-API-KEY',
    appId: 'REPLACE-WITH-YOUR-ANDROID-APP-ID',
    messagingSenderId: '567948546173',
    projectId: 'calmina-dc2ac',
    storageBucket: 'calmina-dc2ac.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE-WITH-YOUR-IOS-API-KEY',
    appId: 'REPLACE-WITH-YOUR-IOS-APP-ID',
    messagingSenderId: '567948546173',
    projectId: 'calmina-dc2ac',
    storageBucket: 'calmina-dc2ac.firebasestorage.app',
    iosClientId: 'REPLACE-WITH-YOUR-IOS-CLIENT-ID',
    iosBundleId: 'REPLACE-WITH-YOUR-IOS-BUNDLE-ID',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'REPLACE-WITH-YOUR-MACOS-API-KEY',
    appId: 'REPLACE-WITH-YOUR-MACOS-APP-ID',
    messagingSenderId: '567948546173',
    projectId: 'calmina-dc2ac',
    storageBucket: 'calmina-dc2ac.firebasestorage.app',
    iosClientId: 'REPLACE-WITH-YOUR-MACOS-CLIENT-ID',
    iosBundleId: 'REPLACE-WITH-YOUR-MACOS-BUNDLE-ID',
  );
}
