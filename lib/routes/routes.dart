import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_watch/models/movies.dart';
import 'package:movie_watch/presentation/authentication/sign_in.dart';
import 'package:movie_watch/presentation/authentication/sign_up.dart';
import 'package:movie_watch/presentation/bottombar/bottom_bar.dart';
import 'package:movie_watch/presentation/details/details.dart';
import 'package:movie_watch/presentation/movies_screen/movies_screen.dart';
import 'package:movie_watch/presentation/onboard/onboard.dart';
import 'package:movie_watch/presentation/onboard/splash_screen.dart';
import 'package:movie_watch/presentation/profile/profile.dart';
import 'package:movie_watch/presentation/search/search.dart';
import 'package:movie_watch/presentation/tab_bar/tab_bar.dart';
import 'package:movie_watch/presentation/watchlist/watchlist.dart';

class AppRoutes {
  static final GoRouter goRoute = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/onboard', builder: (context, state) => const OnBoard()),
      GoRoute(path: '/sign-up', builder: (context, state) => SignUp()),
      GoRoute(path: '/sign-in', builder: (context, state) => SignIn()),
      GoRoute(path: '/bottom-bar', builder: (context, state) => Bottombar()),
      GoRoute(
        path: '/movie-screen',
        builder: (context, state) => MovieScreen(),
      ),

      GoRoute(path: '/search', builder: (context, state) => const Search()),
      GoRoute(
        path: 'watchlist',
        builder: (context, state) => const Watchlist(),
      ),
      GoRoute(path: '/profile', builder: (context, state) => Profile()),
      GoRoute(
        path: '/details',
        pageBuilder: (context, state) {
          final currentMovie = state.extra as Movie;
          return CustomTransitionPage(
            key: state.pageKey,
            child: Details(currentMovie: currentMovie),
            transitionDuration: const Duration(milliseconds: 700),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    ),
                    child: child,
                  );
                },
          );
        },
      ),
      GoRoute(
        path: '/tab-screen',
        builder: (context, state) => const TabScreen(),
      ),
    ],
  );
}
