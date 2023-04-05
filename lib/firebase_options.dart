// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart';
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
    apiKey: 'AIzaSyBKZUPuxa6178G4cMpvSsZCAkBilIKZrTU',
    appId: '1:894118685230:web:e3229aa5a26383a1da8dbf',
    messagingSenderId: '894118685230',
    projectId: 'ecommerce-a2130',
    authDomain: 'ecommerce-a2130.firebaseapp.com',
    databaseURL: 'https://ecommerce-a2130-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'ecommerce-a2130.appspot.com',
    measurementId: 'G-5RXF1MR5KS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBiX4o7tDzWWCEBXfxZ9WeH62SklFNqbFo',
    appId: '1:894118685230:android:f8d779382c62dd59da8dbf',
    messagingSenderId: '894118685230',
    projectId: 'ecommerce-a2130',
    databaseURL: 'https://ecommerce-a2130-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'ecommerce-a2130.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAzSoT9qUJGwwc0q3Q4-KEAa9yZvDmFT4k',
    appId: '1:894118685230:ios:b3289af0695583a1da8dbf',
    messagingSenderId: '894118685230',
    projectId: 'ecommerce-a2130',
    databaseURL: 'https://ecommerce-a2130-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'ecommerce-a2130.appspot.com',
    iosClientId: '894118685230-8plb2brtkv6bec17halatdhp5af1gc4p.apps.googleusercontent.com',
    iosBundleId: 'com.example.ecommerce',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAzSoT9qUJGwwc0q3Q4-KEAa9yZvDmFT4k',
    appId: '1:894118685230:ios:b3289af0695583a1da8dbf',
    messagingSenderId: '894118685230',
    projectId: 'ecommerce-a2130',
    databaseURL: 'https://ecommerce-a2130-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'ecommerce-a2130.appspot.com',
    iosClientId: '894118685230-8plb2brtkv6bec17halatdhp5af1gc4p.apps.googleusercontent.com',
    iosBundleId: 'com.example.ecommerce',
  );
}
