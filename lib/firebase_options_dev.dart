// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options_dev.dart';
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
    apiKey: 'AIzaSyDzvnx7_Sc6kwWnUOvUhITDPRTmd6MU8xo',
    appId: '1:488143787018:web:3d130cb0691b990b00fbf3',
    messagingSenderId: '488143787018',
    projectId: 'devproductlist',
    authDomain: 'devproductlist.firebaseapp.com',
    storageBucket: 'devproductlist.firebasestorage.app',
    measurementId: 'G-S2V6NC0RDS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCfXch1HWwKQzBscHpomJ4K_Iqf7Zx5nhc',
    appId: '1:488143787018:android:3b743058a88a4c8100fbf3',
    messagingSenderId: '488143787018',
    projectId: 'devproductlist',
    storageBucket: 'devproductlist.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBeHgR08oXvZsgZLHR5PZtdvYmZf9k1yE8',
    appId: '1:488143787018:ios:8c3494df36c9b26600fbf3',
    messagingSenderId: '488143787018',
    projectId: 'devproductlist',
    storageBucket: 'devproductlist.firebasestorage.app',
    iosBundleId: 'com.example.productListingApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBeHgR08oXvZsgZLHR5PZtdvYmZf9k1yE8',
    appId: '1:488143787018:ios:8c3494df36c9b26600fbf3',
    messagingSenderId: '488143787018',
    projectId: 'devproductlist',
    storageBucket: 'devproductlist.firebasestorage.app',
    iosBundleId: 'com.example.productListingApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDzvnx7_Sc6kwWnUOvUhITDPRTmd6MU8xo',
    appId: '1:488143787018:web:a17463bdfd97749900fbf3',
    messagingSenderId: '488143787018',
    projectId: 'devproductlist',
    authDomain: 'devproductlist.firebaseapp.com',
    storageBucket: 'devproductlist.firebasestorage.app',
    measurementId: 'G-FPCV0TB5ZQ',
  );
}
