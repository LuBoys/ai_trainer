// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyB6T2JrG_w6xTvHrXEr3vPFoH8tkbORiAA',
    appId: '1:13043838299:web:3c9fa567be9df754b57e7e',
    messagingSenderId: '13043838299',
    projectId: 'projet-flutter-6319f',
    authDomain: 'projet-flutter-6319f.firebaseapp.com',
    storageBucket: 'projet-flutter-6319f.appspot.com',
    measurementId: 'G-R0LGQ0NYJD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCm9X4oeAOKLhyRBREQYM3lYOgqoy2q72U',
    appId: '1:13043838299:android:0e12c8528b37f8b1b57e7e',
    messagingSenderId: '13043838299',
    projectId: 'projet-flutter-6319f',
    storageBucket: 'projet-flutter-6319f.appspot.com',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBKx1qxCZ2eoSFaXYfPTVpe8RSBEkAL6z4',
    appId: '1:13043838299:ios:c7de79245a048d72b57e7e',
    messagingSenderId: '13043838299',
    projectId: 'projet-flutter-6319f',
    storageBucket: 'projet-flutter-6319f.appspot.com',
    iosClientId: '13043838299-r74f3bbk6ufe6gnbrt5hkdcg4aq2sa89.apps.googleusercontent.com',
    iosBundleId: 'com.example.test',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB6T2JrG_w6xTvHrXEr3vPFoH8tkbORiAA',
    appId: '1:13043838299:web:fe010199d87effa0b57e7e',
    messagingSenderId: '13043838299',
    projectId: 'projet-flutter-6319f',
    authDomain: 'projet-flutter-6319f.firebaseapp.com',
    storageBucket: 'projet-flutter-6319f.appspot.com',
    measurementId: 'G-C0B4PQQZ7M',
  );

}