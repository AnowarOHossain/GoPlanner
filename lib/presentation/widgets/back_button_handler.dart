// Import Flutter widgets
import 'package:flutter/material.dart';
// Import system services for closing app
import 'package:flutter/services.dart';
// Import GoRouter for navigation
import 'package:go_router/go_router.dart';

// Widget that handles Android back button properly with GoRouter
// Shows exit confirmation when on home page
class BackButtonHandler extends StatelessWidget {
  final Widget child; // The screen to wrap
  final GoRouter router; // Router instance for navigation

  const BackButtonHandler({
    super.key,
    required this.child,
    required this.router,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Don't auto-pop, we handle it manually
      // Called when user presses back button
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        // Try to go back to previous screen
        if (router.canPop()) {
          router.pop();
        } else {
          // On home page - show exit confirmation dialog
          final shouldExit = await _showExitDialog(context);
          if (shouldExit == true) {
            SystemNavigator.pop(); // Close the app
          }
        }
      },
      child: child,
    );
  }

  // Show dialog asking user if they want to exit the app
  Future<bool?> _showExitDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}