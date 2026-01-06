// This file provides authentication state management using Firebase Auth and Riverpod
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/auth_service.dart';

// Provider for the AuthService instance
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Streams auth state changes (login/logout events)
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authServiceProvider).authStateChanges();
});

// Provides current user (null if not logged in)
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.asData?.value;
});
