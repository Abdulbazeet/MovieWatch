import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_watch/presentation/authentication/auth_controller/auth_notifier.dart';
import 'package:movie_watch/presentation/authentication/auth_repository/auth_repository.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

final authControllerProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
      final _authRepository = ref.watch(authRepositoryProvider);

      return AuthNotifier(_authRepository);
    });

final authStateprovider = StreamProvider<User?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
});
