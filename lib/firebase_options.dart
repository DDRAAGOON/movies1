import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
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
    apiKey: 'AIzaSyB47JdgV4nMwYjSMWFNwlm2pZCKIR0Hs7w',
    appId: '1:772687573356:web:dd1bedaddeec1c88fc7914',
    messagingSenderId: '772687573356',
    projectId: 'movie-b3a92',
    authDomain: 'movie-b3a92.firebaseapp.com',
    storageBucket: 'movie-b3a92.firebasestorage.app',
    measurementId: 'G-7LX2WL00HH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBD6ZtGyRyn1t3KV4UtLiSaU6c_QLRAjQ0',
    appId: '1:772687573356:android:eaa60a56e6eb55566f8349',
    messagingSenderId: '772687573356',
    projectId: 'movie-b3a92',
    storageBucket: 'movie-b3a92.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB47JdgV4nMwYjSMWFNwlm2pZCKIR0Hs7w',
    appId: '1:772687573356:ios:6dadf71d46fa8802fc7914',
    messagingSenderId: '772687573356',
    projectId: 'movie-b3a92',
    storageBucket: 'movie-b3a92.firebasestorage.app',
    iosBundleId: 'com.example.untitled1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB47JdgV4nMwYjSMWFNwlm2pZCKIR0Hs7w',
    appId: '1:772687573356:macos:6dadf71d46fa8802fc7914',
    messagingSenderId: '772687573356',
    projectId: 'movie-b3a92',
    storageBucket: 'movie-b3a92.firebasestorage.app',
    iosBundleId: 'com.example.untitled1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB47JdgV4nMwYjSMWFNwlm2pZCKIR0Hs7w',
    appId: '1:772687573356:web:203092d9f879964cfc7914',
    messagingSenderId: '772687573356',
    projectId: 'movie-b3a92',
    authDomain: 'movie-b3a92.firebaseapp.com',
    storageBucket: 'movie-b3a92.firebasestorage.app',
    measurementId: 'G-KC399ZPWE7',
  );
}
