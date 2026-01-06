import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseBootstrap {
  static Future<void> init() async {
    if (kIsWeb) {
      // For Flutter Web, FirebaseOptions must be provided.
      // Supply these via --dart-define when running/building:
      // FIREBASE_API_KEY, FIREBASE_APP_ID, FIREBASE_MESSAGING_SENDER_ID,
      // FIREBASE_PROJECT_ID, FIREBASE_AUTH_DOMAIN (optional),
      // FIREBASE_STORAGE_BUCKET (optional), FIREBASE_MEASUREMENT_ID (optional)
      const apiKey = String.fromEnvironment('FIREBASE_API_KEY');
      const appId = String.fromEnvironment('FIREBASE_APP_ID');
      const messagingSenderId = String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID');
      const projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');

      if (apiKey.isEmpty || appId.isEmpty || messagingSenderId.isEmpty || projectId.isEmpty) {
        throw StateError(
          'Firebase web config missing. Run with --dart-define values for '
          'FIREBASE_API_KEY, FIREBASE_APP_ID, FIREBASE_MESSAGING_SENDER_ID, FIREBASE_PROJECT_ID.',
        );
      }

      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: apiKey,
          appId: appId,
          messagingSenderId: messagingSenderId,
          projectId: projectId,
          authDomain: const String.fromEnvironment('FIREBASE_AUTH_DOMAIN'),
          storageBucket: const String.fromEnvironment('FIREBASE_STORAGE_BUCKET'),
          measurementId: const String.fromEnvironment('FIREBASE_MEASUREMENT_ID'),
        ),
      );
      return;
    }

    // Android/iOS/macOS use native config files (google-services.json / GoogleService-Info.plist)
    await Firebase.initializeApp();
  }
}
