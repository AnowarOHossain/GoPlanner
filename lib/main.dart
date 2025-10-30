// Import Flutter material design widgets
import 'package:flutter/material.dart';
// Import services for system configuration
import 'package:flutter/services.dart';
// Import Riverpod for state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Firebase import (currently disabled)
// import 'package:firebase_core/firebase_core.dart'; // Temporarily disabled

// Import app constants like app name
import 'core/constants/app_constants.dart';
// Import routing configuration
import 'presentation/routes/app_router.dart';
// Import app theme (colors, fonts, etc.)
import 'presentation/theme/app_theme.dart';

// Main entry point of the application
void main() async {
  // Initialize Flutter engine before running the app
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (currently disabled for development)
  // await Firebase.initializeApp(); // Temporarily disabled
  
  // Lock app to portrait mode only (no landscape)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set status bar to transparent with dark icons
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Run the app with Riverpod state management
  runApp(
    const ProviderScope(
      child: GoPlanner(),
    ),
  );
}

// Main app widget using Riverpod for state management
class GoPlanner extends ConsumerWidget {
  const GoPlanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get router configuration from provider
    final router = ref.watch(appRouterProvider);

    // Build MaterialApp with routing
    return MaterialApp.router(
      title: AppConstants.appName, // App title
      debugShowCheckedModeBanner: false, // Hide debug banner
      theme: AppTheme.lightTheme, // Light theme
      darkTheme: AppTheme.darkTheme, // Dark theme
      themeMode: ThemeMode.system, // Follow system theme
      routerConfig: router, // App routing configuration
    );
  }
}