// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_watch/models/user/userModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final supabase = Supabase.instance.client;

  // AuthRepository({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  Stream<AuthState> get authStateChanges => supabase.auth.onAuthStateChange;
  User? get currentUser => supabase.auth.currentUser;

  Future<void> _ensureUserProfile() async {
    final user = currentUser;
    if (user == null) {
      return;
    }
    final existingProfile = await supabase
        .from('userModel')
        .select()
        .eq('uid', currentUser!.id)
        .maybeSingle();
    if (existingProfile == null) {
      final userModel = Usermodel(
        uid: currentUser!.id,
        favourite: null,
        seenList: null,
        watchList: null,
      );
      await supabase.from('userModel').insert(userModel.toMap());
    }
  }

  Future signUpWithEmail(String email, String password) async {
    await supabase.auth.signUp(email: email, password: password);
    await _ensureUserProfile();

    return;
  }

  Future signInWithEmail(String email, String password) async {
    await supabase.auth.signInWithPassword(email: email, password: password);
    await _ensureUserProfile();
    return;
  }

  Future googleSignIn() async {
    final scopes = ['email', 'profile'];
    final clientId = dotenv.env['CLIENT_ID']!;
    final googleSignIn = GoogleSignIn.instance;

    await googleSignIn.initialize(clientId: clientId);
    final googleUser = await googleSignIn.attemptLightweightAuthentication();
    if (googleUser == null) {
      throw Exception("Google sign-in aborted");
    }
    final authorization =
        await googleUser.authorizationClient.authorizationForScopes(scopes) ??
        await googleUser.authorizationClient.authorizeScopes(scopes);
    final token = googleUser.authentication.idToken;
    if (token == null) {
      throw Exception('Id Token is null');
    }
    await supabase.auth.signInWithIdToken(
      idToken: token,
      provider: OAuthProvider.google,
      accessToken: authorization.accessToken,
    );
    await _ensureUserProfile();
    return;
  }
  // Future<void> googleSignIn() async {
  //   try {
  //     // Use your WEB client ID here (from Google Cloud → OAuth 2.0 Client IDs → Web application)
  //     // This is REQUIRED for Android in google_sign_in 7.x+
  //     const serverClientId =
  //         'your-web-client-id.apps.googleusercontent.com'; // ← from .env or hardcode for test

  //     // For iOS (if you support it later): add clientId
  //     // const iosClientId = 'your-ios-client-id.apps.googleusercontent.com';

  //     final GoogleSignIn googleSignIn = GoogleSignIn(
  //       // serverClientId is mandatory for Android
  //       serverClientId: serverClientId,
  //       // clientId: iosClientId, // only if iOS, otherwise omit or null
  //       scopes: ['email', 'profile'],
  //     );

  //     // Standard signIn() call — no initialize(), no attemptLightweight, no manual scopes
  //     final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

  //     if (googleUser == null) {
  //       throw Exception('Google sign-in canceled by user');
  //     }

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     final String? idToken = googleAuth.idToken;
  //     final String? accessToken = googleAuth.accessToken;

  //     if (idToken == null) {
  //       throw Exception('No ID Token received from Google');
  //     }

  //     // Send to Supabase
  //     await supabase.auth.signInWithIdToken(
  //       provider: OAuthProvider.google,
  //       idToken: idToken,
  //       accessToken: accessToken,
  //     );

  //     await _ensureUserProfile();
  //   } catch (e) {
  //     print('Google sign-in error: $e'); // for debugging
  //     rethrow; // let the caller handle (show snackbar etc.)
  //   }
  // }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);
