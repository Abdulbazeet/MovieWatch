import 'package:go_router/go_router.dart';
import 'package:movie_watch/presentation/authentication/sign_in.dart';
import 'package:movie_watch/presentation/authentication/sign_up.dart';
import 'package:movie_watch/presentation/home/home.dart';
import 'package:movie_watch/presentation/onboard/onboard.dart';
import 'package:movie_watch/presentation/onboard/splash_screen.dart';

class AppRoutes {
  static final GoRouter goRoute = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/onboard', builder: (context, state) => const OnBoard()),
      GoRoute(path: '/sign-up', builder: (context, state) => SignUp()),
      GoRoute(path: '/sign-in', builder: (context, state) => SignIn()),
      GoRoute(path: '/home', builder: (context, state) => Home()),
    ],
  );
}
