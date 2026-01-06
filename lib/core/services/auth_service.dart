// This service handles all authentication (login/logout) with Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Handles login, signup, and logout operations
class AuthService {
  AuthService({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
      : _auth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = kIsWeb ? null : (googleSignIn ?? GoogleSignIn());

  final FirebaseAuth _auth; // Firebase Auth connection
  final GoogleSignIn? _googleSignIn; // Google Sign In (null on web)

  // Stream that emits when user logs in or out
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  // Get current logged in user
  User? get currentUser => _auth.currentUser;

  // Sign in with email and password
  Future<UserCredential> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    await credential.user?.reload();
    return credential;
  }

  // Create new account with email and password
  Future<UserCredential> signUpWithEmailPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final user = credential.user;
    if (user != null) {
      final name = (displayName ?? '').trim();
      if (name.isNotEmpty) {
        await user.updateDisplayName(name);
      }
      await user.reload();
    }
    return credential;
  }

  // Sign in with Google account
  Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb) {
      final provider = GoogleAuthProvider();
      return _auth.signInWithPopup(provider);
    }

    final googleSignIn = _googleSignIn;
    if (googleSignIn == null) {
      throw const AuthServiceException(
        'Google sign-in is not available on this platform'
      );
    }

    final account = await googleSignIn.signIn();
    if (account == null) {
      throw const AuthServiceException('Google sign-in cancelled');
    }

    final auth = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );

    return _auth.signInWithCredential(credential);
  }

  // Sign out from Firebase and Google
  Future<void> signOut() async {
    await _auth.signOut();
    final googleSignIn = _googleSignIn;
    if (!kIsWeb && googleSignIn != null) {
      await googleSignIn.signOut();
    }
  }
}

// Custom exception for auth errors
class AuthServiceException implements Exception {
  const AuthServiceException(this.message);
  final String message;

  @override
  String toString() => 'AuthServiceException: $message';
}
