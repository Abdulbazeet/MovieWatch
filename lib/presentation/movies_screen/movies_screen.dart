import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_watch/common/widgets/movie_section.dart';
import 'package:movie_watch/config/movie_type.dart';
import 'package:movie_watch/data/tmdb_providers.dart';
import 'package:movie_watch/presentation/movies_screen/image_section.dart';
import 'package:sizer/sizer.dart';

class MovieScreen extends ConsumerStatefulWidget {
  const MovieScreen({super.key});

  @override
  ConsumerState<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends ConsumerState<MovieScreen>
    with AutomaticKeepAliveClientMixin {
  String dropdownvalue = 'One';
  Timer? timer;
  int _currentPage = 0;
  final controller = PageController(viewportFraction: 1);
  MovieType movieType = MovieType.movie;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
              movies: populaMovies,
              onPressesd: () {},
            ),
            /***
             * 
             * now playing row
             */
            MovieSection(
              movies: nowPlayingMovies,
              title: 'Now Playing',
              onShowAll: () {
                context.push(
                  '/show-all',
                  extra: {'title': 'Now Playing', 'movieType': movieType},
                );
              },
            ),

            /**
             * Popular row
             */
            MovieSection(
              movies: populaMovies,
              title: 'Popular',
              onShowAll: () {},
            ),
            /**
             * Trending row
             */
            MovieSection(
              movies: trendingMovies,
              title: 'Trending',
              onShowAll: () {},
            ),

            /***
             * Upcoming
             */
            MovieSection(
              movies: upcomingMovies,
              title: 'Upcoming',
              onShowAll: () {},
            ),
            /**
             * Top rated row
             */
            MovieSection(
              movies: topRated,
              title: 'Top Rated',
              onShowAll: () {},
            ),

            /**
             * spacer
             */
            SliverToBoxAdapter(child: SizedBox(height: 20.sh)),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
