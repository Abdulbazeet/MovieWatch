import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  bool skipOnBOard = false;
  void loadPreference() async {
    var skip = await SharedDB.skipONboard();
    setState(() {
      skipOnBOard = skip;
    });
  }

  @override
  void initState() {
    super.initState();
    loadPreference();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(authStateprovider);

    return userState.when(
      data: (user) {
        if (user != null || skipOnBOard == true) {
          return Bottombar();
        }
        return OnBoard();
      },
      error: (error, stackTrace) {
        return Scaffold(body: Center(child: Text("$error - $stackTrace")));
      },
      loading: () {
        return Scaffold(body: const CircularProgressIndicator.adaptive());
      },
    );
  }
}
