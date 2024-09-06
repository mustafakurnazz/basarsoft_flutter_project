import 'package:basarsoft/View/home/home_view.dart';
import 'package:basarsoft/View/logIn/login_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';


class FirebaseAuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<User?> createUser(String email, String password, String username,BuildContext context) async {
  try {
    UserCredential credential = await auth.createUserWithEmailAndPassword(
      email: email, 
      password: password,
    );
    User? user = credential.user;

    if (user != null) {
      await firestore.collection('users').doc(user.uid).set({
        'email': email,
        'username': username,
      });
    }
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
        (route) => false
    );
    return user;
  } catch (e) {
    print("error: $e");
    return null;
  }
}

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      print("error: $e");
    }
    return null;
  }

  Future<void> signInWithGoogleFirebase(BuildContext context) async {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  try {
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      UserCredential userCredential = await auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        await firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'username': user.displayName,
        });

        if (!context.mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
          (route) => false
        );
      }
    }
  } catch (e) {
    print("error: $e");
  }
 }
 Future<void> signOut(BuildContext context) async {
  auth.signOut();
  Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
          (route) => false
        );
 }
}