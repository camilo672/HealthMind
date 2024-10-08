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
    apiKey: 'AIzaSyCt2Lw_weZgcUq9tGMlGtgugwUvcBx9t4k',
    appId: '1:258435967655:web:3acd8916b5628d7dcc0982',
    messagingSenderId: '258435967655',
    projectId: 'gend-5088f',
    authDomain: 'gend-5088f.firebaseapp.com',
    storageBucket: 'gend-5088f.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyARsqBfI1QN-Jv6sRzLX9J2A5W9N2GSjH0',
    appId: '1:258435967655:android:e498d803afb9a13dcc0982',
    messagingSenderId: '258435967655',
    projectId: 'gend-5088f',
    storageBucket: 'gend-5088f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCiqXvaT9zahRyC92Shn_n5qMSKX_afJro',
    appId: '1:258435967655:ios:b628985c258fad14cc0982',
    messagingSenderId: '258435967655',
    projectId: 'gend-5088f',
    storageBucket: 'gend-5088f.appspot.com',
    iosClientId: '258435967655-b9fd0cneco8ejqtm55lk6ia84tgv1j5o.apps.googleusercontent.com',
    iosBundleId: 'com.example.phsycho',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCiqXvaT9zahRyC92Shn_n5qMSKX_afJro',
    appId: '1:258435967655:ios:b628985c258fad14cc0982',
    messagingSenderId: '258435967655',
    projectId: 'gend-5088f',
    storageBucket: 'gend-5088f.appspot.com',
    iosClientId: '258435967655-b9fd0cneco8ejqtm55lk6ia84tgv1j5o.apps.googleusercontent.com',
    iosBundleId: 'com.example.phsycho',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCt2Lw_weZgcUq9tGMlGtgugwUvcBx9t4k',
    appId: '1:258435967655:web:236fd5e732981f28cc0982',
    messagingSenderId: '258435967655',
    projectId: 'gend-5088f',
    authDomain: 'gend-5088f.firebaseapp.com',
    storageBucket: 'gend-5088f.appspot.com',
  );

}