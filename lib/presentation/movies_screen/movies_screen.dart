import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_watch/common/widgets/movie_section.dart';
import 'package:movie_watch/config/enums.dart';
import 'package:movie_watch/config/utils.dart';
import 'package:movie_watch/data/tmdb_providers.dart';
import 'package:movie_watch/presentation/movies_screen/image_section.dart';

class MovieScreen extends ConsumerStatefulWidget {
  const MovieScreen({super.key});

  @override
  ConsumerState<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends ConsumerState<MovieScreen>
     {
  String dropdownvalue = 'One';
  Timer? timer;
  int _currentPage = 0;
  final controller = PageController(viewportFraction: 1);
  TableType tableType = TableType.movies;

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    final populaMovies = ref.watch(popularMoviesProvider);
    final genreId = ref.watch(movieGenreProvider);
    final trendingMovies = ref.watch(trendingMoviesProvider);
    final upcomingMovies = ref.watch(upComingMovies);
    final topRated = ref.watch(topRatedMovies);
    final nowPlayingMovies = ref.watch(nowPlayingProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            //popular header
            //
            ImageSection(
              genreId: genreId,
              tableType: tableType,
              movies: populaMovies,
            ),
            /***
             * 
             * now playing row
             */
            MovieSection(
              tableType: tableType,
              movies: nowPlayingMovies,
              title: 'Now Playing',
              onShowAll: () {
                context.push(
                  '/show-all',
                  extra: {
                    'title': 'Now Playing',
                    'tableType': tableType,
                    "movieType": MovieType.nowPlaying,
                  },
                );
              },
            ),

            /**
             * Popular row
             */
            MovieSection(
              tableType: tableType,
              movies: populaMovies,
              title: 'Popular',
              onShowAll: () {
                context.push(
                  '/show-all',
                  extra: {
                    'title': 'Popular',
                    'tableType': tableType,
                    "movieType": MovieType.popular,
                  },
                );
              },
            ),
            /**
             * Trending row
             */
            MovieSection(
              tableType: tableType,
              movies: trendingMovies,
              title: 'Trending',
              onShowAll: () {
                context.push(
                  '/show-all',
                  extra: {
                    'title': 'Trending',
                    'tableType': tableType,
                    "movieType": MovieType.trending,
                  },
                );
              },
            ),

            /***
             * Upcoming
             */
            MovieSection(
              tableType: tableType,
              movies: upcomingMovies,
              title: 'Upcoming',
              onShowAll: () {
                context.push(
                  '/show-all',
                  extra: {
                    'title': 'Upcoming',
                    'tableType': tableType,
                    "movieType": MovieType.upcoming,
                  },
                );
              },
            ),
            /**
             * Top rated row
             */
            MovieSection(
              tableType: tableType,
              movies: topRated,
              title: 'Top Rated',
              onShowAll: () {
                context.push(
                  '/show-all',
                  extra: {
                    'title': 'Top Rated',
                    'tableType': tableType,
                    "movieType": MovieType.topRated,
                  },
                );
              },
            ),

            /**
             * spacer
             */
            SliverToBoxAdapter(
              child: SizedBox(height: 85),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
