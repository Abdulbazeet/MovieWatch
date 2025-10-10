import 'package:go_router/go_router.dart';
import 'package:movie_watch/presentation/onboard/authentication/sign_in.dart';
import 'package:movie_watch/presentation/onboard/authentication/sign_up.dart';
import 'package:movie_watch/presentation/onboard/onboard.dart';

class AppRoutes {
  static final GoRouter goRoute = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const OnBoard()),
      GoRoute(path: '/sign-up', builder: (context, state) => SignUp()),
      GoRoute(path: '/sign-in', builder: (context, state) => SignIn()),
    ],
  );
}
