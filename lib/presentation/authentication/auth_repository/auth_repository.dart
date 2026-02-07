// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_watch/models/user/userModel.dart';

class AuthRepository {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<void> _ensureUserProfile() async {
    final user = currentUser;
    if (user == null) {
      return;
    }
    final existingProfile = await _firestore
        .collection('userModel')
        .where('uid', isEqualTo: user.uid)
        .get();
    if (existingProfile.docs.isEmpty) {
      final userModel = Usermodel(
        uid: user.uid,
        favourite: null,
        seenList: null,
        watchList: null,
      );
      await _firestore.collection('userModel').add(userModel.toMap());
    }
  }

  Future signUpWithEmail(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _ensureUserProfile();

    return;
  }

  Future signInWithEmail(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    await _ensureUserProfile();
    return;
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 1. Initialize GoogleSignIn with desired scopes
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      // 2. Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // 3. Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 4. Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 5. Sign in to Firebase with the credential
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // 6. Ensure user profile exists in your database
      await _ensureUserProfile();

      return userCredential;
    } catch (e) {
      // print("Google Sign-In Error: $e");
      rethrow;
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);
