import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_watch/presentation/authentication/auth_repository/auth_repository.dart';

class AuthNotifier extends AsyncNotifier<User?> {
  late final AuthRepository _authRepository;

  @override
  Future<User?> build() async {
    _authRepository = ref.watch(authRepositoryProvider);

    // Listen to verification changes
    _authRepository.authStateChanges.listen((user) {
      state = AsyncData(user);
    });

    return _authRepository.currentUser;
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _authRepository.signInWithEmail(email, password);
      return _authRepository.currentUser;
    });
  }

  Future<void> signUpWithEmail(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _authRepository.signUpWithEmail(email, password);
      return _authRepository.currentUser;
    });
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _authRepository.signInWithGoogle();
      return _authRepository.currentUser;
    });
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthNotifier, User?>(() {
  return AuthNotifier();
});

final authStateprovider = StreamProvider<User?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
});
