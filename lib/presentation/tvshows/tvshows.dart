import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_watch/common/widgets/movie_section.dart';
import 'package:movie_watch/data/tmdb_providers.dart';
import 'package:movie_watch/presentation/movies_screen/image_section.dart';
import 'package:sizer/sizer.dart';

class TvShows extends ConsumerStatefulWidget {
  const TvShows({super.key});

  @override
  ConsumerState<TvShows> createState() => _TvShowsState();
}

class _TvShowsState extends ConsumerState<TvShows> {
  @override
  Widget build(BuildContext context) {
    final popularSeries = ref.watch(popularSeriesProvider);
    final genreId = ref.watch(seriesGenreProvider);
    final airingToday = ref.watch(airingTodayProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            //popular header
            ImageSection(
              genreId: genreId,
              movies: popularSeries,
              onPressesd: () {},
            ),

            //airing today
            MovieSection(
              movies: airingToday,
              title: 'Airing Today',
              onShowAll: () {},
            ),

            //popular series
            MovieSection(
              movies: popularSeries,
              title: 'Popular',
              onShowAll: () {},
            ),
            SliverToBoxAdapter(child: SizedBox(height: 20.sh)),
          ],
        ),
      ),
    );
  }
}
