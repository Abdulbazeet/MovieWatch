import 'package:movie_watch/presentation/authentication/auth_repository/auth_repository.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthRepository _authRepository;
  AuthNotifier(this._authRepository) : super( AsyncData(_authRepository.currentUser)) {
    _authRepository.authStateChanges.listen(
      (AuthState state) => this.state = AsyncData(state.session?.user),
    );
    setInitialState();
  }
  Future<void> setInitialState() async {
    final user = _authRepository.currentUser;
    state = AsyncData(user);
  }

  Future signInWithEmail(String email, String password) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _authRepository.signInWithEmail(email, password);
      return _authRepository.currentUser;
    });
  }

  Future signUpWithEmail(String email, String password) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _authRepository.signUpWithEmail(email, password);
      return _authRepository.currentUser;
    });
  }

  Future googleSignIn() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _authRepository.googleSignIn();
      return _authRepository.currentUser;
    });
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
      final _authRepository = ref.watch(authRepositoryProvider);

      return AuthNotifier(_authRepository);
    });

final authStateprovider = StreamProvider<AuthState?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
});
