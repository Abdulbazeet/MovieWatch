import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_watch/presentation/authentication/auth_repository/auth_repository.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthRepository _authRepository;
  AuthNotifier(this._authRepository) : super(const AsyncData(null)) {
    _authRepository.authStateChanges.listen((user) => state = AsyncData(user));
  }

  Future signInWithEmail(String email, String password) async {
    state = const AsyncLoading();

    // try {

    // } catch (e, str) {
    //   state = AsyncError(e, str);
    // }
    state = await AsyncValue.guard(() async {
      await _authRepository.signInWithEmail(email, password);
      return _authRepository.currentUser;
    });
  }

  Future signUpWithEmail(String email, String password) async {
    state = const AsyncLoading();
    // try {
    // } catch (e, str) {
    //   state = AsyncError(e, str);
    // }
    state = await AsyncValue.guard(() async {
      await _authRepository.signUpWithEmail(email, password);
      return _authRepository.currentUser;
    });
  }

  Future googleSignIn() async {
    state = const AsyncLoading();
    // try {
    //   // state = AsyncData(_authRepository.)
    // } catch (e, str) {
    //   state = AsyncError(e, str);
    // }
    state = await AsyncValue.guard(() async {
      await _authRepository.googleSignIn();
      return _authRepository.currentUser;
    });
  }

  Future facebookSignIn() async {
    state = const AsyncLoading();

    // try {
    // } catch (e, str) {
    //   state = AsyncError(e, str);
    // }
    state = await AsyncValue.guard(() async {
      await _authRepository.signInWIthFacebook();

      return _authRepository.currentUser;
    });
  }
}
