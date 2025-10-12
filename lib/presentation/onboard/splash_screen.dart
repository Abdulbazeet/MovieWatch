import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_watch/presentation/authentication/auth_provider/auth_provider.dart';
import 'package:movie_watch/presentation/home/home.dart';
import 'package:movie_watch/presentation/onboard/onboard.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(authStaterovider);

    return userState.when(
      data: (user) {
        if (user != null) {
          return Home();
        }
        return OnBoard();
      },
      error: (error, stackTrace) {
        return Scaffold(body: Center(child: Text("$error - $stackTrace")));
      },
      loading: () {
        return Scaffold(body: CircularProgressIndicator());
      },
    );
  }
}
