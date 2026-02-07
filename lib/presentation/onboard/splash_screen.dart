import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_watch/presentation/authentication/auth_controller/auth_notifier.dart';
import 'package:movie_watch/presentation/bottombar/bottom_bar.dart';
import 'package:movie_watch/presentation/onboard/onboard.dart';
import 'package:movie_watch/utils/sharedDB.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateprovider);
    return authState.when(
      data: (user) {
        return FutureBuilder(
          future: SharedDB.skipONboard(),
          builder: (context, snapshot) {
            final skipped = snapshot.data ?? false;
            // Wait for shared preferences to load
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (user != null || skipped) {
              return const Bottombar();
            }
            return const OnBoard();
          },
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) =>
          Scaffold(body: Center(child: Text('Error: $error'))),
    );
  }
}
