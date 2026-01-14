import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_watch/presentation/authentication/auth_controller/auth_notifier.dart';
import 'package:movie_watch/presentation/authentication/auth_provider/auth_provider.dart';
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
    final authProvider = ref.watch(authStateprovider);
    return authProvider.when(
      data: (user) {
        final auth = user?.session?.user;
        return FutureBuilder(
          future: SharedDB.skipONboard(),
          builder: (context, snapshot) {
            final skipped = snapshot.data ?? false;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox.shrink();
            }
            if (auth != null || skipped) {
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
