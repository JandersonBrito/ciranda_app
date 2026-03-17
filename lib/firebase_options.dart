// Este arquivo é gerado automaticamente pelo FlutterFire CLI.
// Execute: flutterfire configure
// para gerar este arquivo com as configurações reais do seu projeto Firebase.
//
// ignore_for_file: type=lint
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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions não configurado para esta plataforma. '
          'Execute flutterfire configure para gerar as opções corretas.',
        );
    }
  }

  // ⚠️ IMPORTANTE: Substitua os valores abaixo com os do seu projeto Firebase.
  // Execute: flutterfire configure --project=SEU_PROJETO_FIREBASE

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'SUA_ANDROID_API_KEY',
    appId: '1:000000000000:android:0000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'seu-projeto-firebase',
    storageBucket: 'seu-projeto-firebase.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'SUA_IOS_API_KEY',
    appId: '1:000000000000:ios:0000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'seu-projeto-firebase',
    storageBucket: 'seu-projeto-firebase.appspot.com',
    iosBundleId: 'com.cirandamidia.cirandaApp',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'SUA_WEB_API_KEY',
    appId: '1:000000000000:web:0000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'seu-projeto-firebase',
    storageBucket: 'seu-projeto-firebase.appspot.com',
    authDomain: 'seu-projeto-firebase.firebaseapp.com',
  );
}
