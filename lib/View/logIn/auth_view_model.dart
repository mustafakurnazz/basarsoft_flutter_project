import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:basarsoft/core/service/firebase_auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();

  Future<User?> signUp(String email, String password, String username, BuildContext context) async {
    return await _authService.createUser(email, password, username, context);
  }

  Future<User?> signIn(String email, String password) async {
    return await _authService.signIn(email, password);
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    await _authService.signInWithGoogleFirebase(context);
  }

  Future<void> signOut(BuildContext context) async {
    await _authService.signOut(context);
  }
}
