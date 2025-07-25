// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        return windows;
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
    apiKey: 'AIzaSyAVqwhlclq-ZQBrOmt1ZrmogLEwYIDi0N4',
    appId: '1:435697920829:web:ddc0f714fa8b92c6803354',
    messagingSenderId: '435697920829',
    projectId: 'healthboosters-dff5b',
    authDomain: 'healthboosters-dff5b.firebaseapp.com',
    storageBucket: 'healthboosters-dff5b.appspot.com',
    measurementId: 'G-PP4MJTGJHJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDZ6HCHgz7DgF6uO3t6QVIIM0mF7-Hdzyk',
    appId: '1:435697920829:android:124eabdc75d24480803354',
    messagingSenderId: '435697920829',
    projectId: 'healthboosters-dff5b',
    storageBucket: 'healthboosters-dff5b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBX0VBQXr5Ru6eVupc9tW_DlM361RKlRCA',
    appId: '1:435697920829:ios:1c5c3d6f3d5a302b803354',
    messagingSenderId: '435697920829',
    projectId: 'healthboosters-dff5b',
    storageBucket: 'healthboosters-dff5b.appspot.com',
    iosBundleId: 'com.example.yourhealth',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBX0VBQXr5Ru6eVupc9tW_DlM361RKlRCA',
    appId: '1:435697920829:ios:1c5c3d6f3d5a302b803354',
    messagingSenderId: '435697920829',
    projectId: 'healthboosters-dff5b',
    storageBucket: 'healthboosters-dff5b.appspot.com',
    iosBundleId: 'com.example.yourhealth',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAVqwhlclq-ZQBrOmt1ZrmogLEwYIDi0N4',
    appId: '1:435697920829:web:c527313923609c07803354',
    messagingSenderId: '435697920829',
    projectId: 'healthboosters-dff5b',
    authDomain: 'healthboosters-dff5b.firebaseapp.com',
    storageBucket: 'healthboosters-dff5b.appspot.com',
    measurementId: 'G-XWZCTE2DSP',
  );
}
