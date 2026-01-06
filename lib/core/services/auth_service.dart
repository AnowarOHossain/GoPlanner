import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
      : _auth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = kIsWeb ? null : (googleSignIn ?? GoogleSignIn());

  final FirebaseAuth _auth;
  final GoogleSignIn? _googleSignIn;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmailPassword({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signUpWithEmailPassword({
    required String email,
    required String password,
  }) {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb) {
      final provider = GoogleAuthProvider();
      return _auth.signInWithPopup(provider);
    }

    final googleSignIn = _googleSignIn;
    if (googleSignIn == null) {
      throw const AuthServiceException('Google sign-in is not available on this platform');
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

  Future<void> signOut() async {
    await _auth.signOut();

    final googleSignIn = _googleSignIn;
    if (!kIsWeb && googleSignIn != null) {
      await googleSignIn.signOut();
    }
  }
}

class AuthServiceException implements Exception {
  const AuthServiceException(this.message);
  final String message;

  @override
  String toString() => 'AuthServiceException: $message';
}
