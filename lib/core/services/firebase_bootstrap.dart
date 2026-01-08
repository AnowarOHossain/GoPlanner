import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirebaseBootstrap {
  static Future<void> init() async {
    if (kIsWeb) {
      // For Flutter Web, FirebaseOptions must be provided from .env file
      final apiKey = dotenv.env['FIREBASE_API_KEY'] ?? '';
      final appId = dotenv.env['FIREBASE_APP_ID'] ?? '';
      final messagingSenderId = dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '';
      final projectId = dotenv.env['FIREBASE_PROJECT_ID'] ?? '';

      if (apiKey.isEmpty || appId.isEmpty || messagingSenderId.isEmpty || projectId.isEmpty) {
        throw StateError(
          'Firebase web config missing. Add FIREBASE_API_KEY, FIREBASE_APP_ID, '
          'FIREBASE_MESSAGING_SENDER_ID, FIREBASE_PROJECT_ID to your .env file.',
        );
      }

      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: apiKey,
          appId: appId,
          messagingSenderId: messagingSenderId,
          projectId: projectId,
          authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? '',
          storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '',
          measurementId: dotenv.env['FIREBASE_MEASUREMENT_ID'] ?? '',
        ),
      );
      return;
    }

    // Android/iOS/macOS use native config files (google-services.json / GoogleService-Info.plist)
    await Firebase.initializeApp();
  }
}
