import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_watch/common/widgets/movie_section.dart';
import 'package:movie_watch/data/tmdb_providers.dart';
import 'package:movie_watch/presentation/movies_screen/image_section.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

class TvShows extends ConsumerStatefulWidget {
  const TvShows({super.key});

  @override
  ConsumerState<TvShows> createState() => _TvShowsState();
}

class _TvShowsState extends ConsumerState<TvShows>
    with AutomaticKeepAliveClientMixin {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  Future<void> _onRefresh() async {
    // Re-fetch data
    await Future.wait([
      ref.refresh(popularSeriesProvider.future),
      ref.refresh(seriesGenreProvider.future),
      ref.refresh(airingTodayProvider.future),
      ref.refresh(newSeriesPovider.future),
      ref.refresh(trendingSeriesPovider.future),
      ref.refresh(upcomingSeriesPovider.future),
      ref.refresh(topRatedSeriesPovider.future),
    ]);

    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // important for keepAlive

    final popularSeries = ref.watch(popularSeriesProvider);
    final genreId = ref.watch(seriesGenreProvider);
    final airingToday = ref.watch(airingTodayProvider);
    final newSeries = ref.watch(newSeriesPovider);
    final trending = ref.watch(trendingSeriesPovider);
    final upcoming = ref.watch(upcomingSeriesPovider);
    final topRated = ref.watch(topRatedSeriesPovider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      body: SafeArea(
        child: SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          header: WaterDropMaterialHeader(
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          child: CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
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

              //New series
              MovieSection(movies: newSeries, title: 'New', onShowAll: () {}),

              //popular series
              MovieSection(
                movies: popularSeries,
                title: 'Popular',
                onShowAll: () {},
              ),
              MovieSection(
                movies: trending,
                title: 'Trending',
                onShowAll: () {},
              ),
              MovieSection(
                movies: upcoming,
                title: 'Upcoming',
                onShowAll: () {},
              ),
              MovieSection(
                movies: topRated,
                title: 'Top Rated',
                onShowAll: () {},
              ),

              SliverToBoxAdapter(child: SizedBox(height: 20.sh)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
