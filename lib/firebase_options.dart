
// File generated by FlutLab.
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'it not supported by FlutLab yet, but you can add it manually',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'it not supported by FlutLab yet, but you can add it manually',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'it not supported by FlutLab yet, but you can add it manually',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCnA8hX1d53fVseLZtQEVZZ0UjcuM__ZJ8',
    authDomain: 'hostelbooking-9bdbd.firebaseapp.com',
    projectId: 'hostelbooking-9bdbd',
    storageBucket: 'hostelbooking-9bdbd.appspot.com',
    messagingSenderId: '275534874189',
    appId: '1:275534874189:web:c4db693ec70dad6431be04'
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBqW8CbQ4en0HzYSdwvVc5QjHNSDLXg50c',
    iosBundleId: 'groupsix.com',
    appId: '1:275534874189:ios:7e8db9c8f2c291d831be04',
    storageBucket: 'hostelbooking-9bdbd.appspot.com',
    messagingSenderId: '275534874189',
    iosClientId: '275534874189-h298vq07c5o3uusvpmis365mavfebf90.apps.googleusercontent.com',
    projectId: 'hostelbooking-9bdbd'
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBcXq5bXEuyfq6yjzsYv7blN43uewYHn6c',
    appId: '1:275534874189:android:006e8dbd9079da5431be04',
    messagingSenderId: '275534874189',
    projectId: 'hostelbooking-9bdbd',
    storageBucket: 'hostelbooking-9bdbd.appspot.com'
  );
}
