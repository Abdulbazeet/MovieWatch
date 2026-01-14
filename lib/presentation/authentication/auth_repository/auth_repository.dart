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
    try {
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
    } catch (e, str) {
      throw Exception(" $e - $str");
    }
  }

  Future signUpWithEmail(String email, String password) async {
    try {
      await supabase.auth.signUp(email: email, password: password);
      await _ensureUserProfile();

      return;
    } catch (e, str) {
      throw Exception(" $e - $str");
    }
  }

  Future signInWithEmail(String email, String password) async {
    try {
      await supabase.auth.signInWithPassword(email: email, password: password);
      await _ensureUserProfile();
      return;
    } catch (e, str) {
      throw Exception(" $e - $str");
    }
  }

  Future googleSignIn() async {
    try {
      // Trigger the authentication flow
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
    } catch (e, str) {
      throw Exception("$e - $str");
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);
