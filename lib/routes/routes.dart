import 'package:go_router/go_router.dart';
import 'package:movie_watch/presentation/authentication/sign_in.dart';
import 'package:movie_watch/presentation/authentication/sign_up.dart';
import 'package:movie_watch/presentation/bottombar/bottom_bar.dart';
import 'package:movie_watch/presentation/home/home.dart';
import 'package:movie_watch/presentation/onboard/onboard.dart';
import 'package:movie_watch/presentation/onboard/splash_screen.dart';
import 'package:movie_watch/presentation/profile/profile.dart';
import 'package:movie_watch/presentation/search/search.dart';
import 'package:movie_watch/presentation/watchlist/watchlist.dart';

class AppRoutes {
  static final GoRouter goRoute = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/onboard', builder: (context, state) => const OnBoard()),
      GoRoute(path: '/sign-up', builder: (context, state) => SignUp()),
      GoRoute(path: '/sign-in', builder: (context, state) => SignIn()),
      GoRoute(path: '/bottom-bar', builder: (context, state) => Bottombar()),
      GoRoute(path: '/home', builder: (context, state) => Home()),

      GoRoute(path: '/search', builder: (context, state) => const Search()),
      GoRoute(
        path: 'watchlist',
        builder: (context, state) => const Watchlist(),
      ),
      GoRoute(path: '/profile', builder: (context, state) => Profile()),
    ],
  );
}
