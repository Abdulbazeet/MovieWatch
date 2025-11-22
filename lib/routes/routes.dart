// ignore_for_file: unused_local_variable

import 'package:go_router/go_router.dart';
import 'package:movie_watch/config/enums.dart';
import 'package:movie_watch/models/movies.dart';
import 'package:movie_watch/models/recommendedMovies.dart';
import 'package:movie_watch/presentation/authentication/sign_in.dart';
import 'package:movie_watch/presentation/authentication/sign_up.dart';
import 'package:movie_watch/presentation/bottombar/bottom_bar.dart';
import 'package:movie_watch/presentation/details/details.dart';
import 'package:movie_watch/presentation/movies_screen/movies_screen.dart';
import 'package:movie_watch/presentation/onboard/onboard.dart';
import 'package:movie_watch/presentation/onboard/splash_screen.dart';
import 'package:movie_watch/presentation/profile/profile.dart';
import 'package:movie_watch/presentation/search/search.dart';
import 'package:movie_watch/presentation/series_details/tvshow_screen.dart';
import 'package:movie_watch/presentation/show_all/show_all.dart';
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
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          final tableType = extras['tableType'] as TableType;
          final movieOrRec =
              extras['movie']; // could be Movie OR Recommendations

          Movie? movie;
          Recommendations? recommendations;

          if (movieOrRec is Movie) {
            movie = movieOrRec;
          } else if (movieOrRec is Recommendations) {
            recommendations = movieOrRec;
          }
          return Details(currentMovie: movieOrRec, tableType: tableType);
        },
      ),
      GoRoute(
        path: '/tvshows-details',
        builder: (context, state) {
          final m = state.extra as Movie;

          return TvshowScreen(currentMovie: m);
        },
      ),
      // GoRoute(
      //   path: '/series-details',
      //   builder: (context, state) {
      //     final m = state.extra as Movie;

      //     return SeriesDetails(m);
      //   },
      // ),
      GoRoute(
        path: '/tab-screen',
        builder: (context, state) => const TabScreen(),
      ),
      GoRoute(
        path: '/show-all',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;

          final title = extras['title'] as String;
          final movieType = extras['movieType'] as MovieType;
          final tableType = extras['tableType'] as TableType;
          return ShowAll(
            title: title,
            movieType: movieType,
            tableType: tableType,
          );
        },
      ),
    ],
  );
}
