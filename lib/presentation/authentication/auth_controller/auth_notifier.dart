import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_watch/presentation/authentication/auth_repository/auth_repository.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthRepository _authRepository;
  AuthNotifier(this._authRepository) : super(const AsyncValue.loading()) {
    _authRepository.authStateChanges.listen(
      (user) => state = AsyncValue.data(user),
    );
  }

  Future signInWithEmail(String email, String password) async {
    try {
      state = const AsyncValue.loading();
      await _authRepository.signInWithEmail(email, password);
    } catch (e, str) {
      state = AsyncValue.error(e, str);
    }
  }

  Future signUpWithEmail(String email, String password) async {
    try {
      state = AsyncValue.loading();
      await _authRepository.signUpWithEmail(email, password);
    } catch (e, str) {
      state = AsyncValue.error(e, str);
    }
  }

  Future googleSignIn() async {
    try {
      state = AsyncValue.loading();
      await _authRepository.googleSignIn();
    } catch (e, str) {
      state = AsyncValue.error(e, str);
    }
  }

  Future facebookSignIn() async {
    try {
      state = AsyncValue.loading();
      await _authRepository.signInWIthFacebook();
    } catch (e, str) {
      state = AsyncValue.error(e, str);
    }
  }
}
