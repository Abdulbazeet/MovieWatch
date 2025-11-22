import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
 import 'package:go_router/go_router.dart';
import 'package:movie_watch/common/widgets/movie_section.dart';
import 'package:movie_watch/config/enums.dart';
import 'package:movie_watch/data/tmdb_providers.dart';
import 'package:movie_watch/presentation/movies_screen/image_section.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
    TableType tableType = TableType.tvshows;

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
                tableType: tableType,
                genreId: genreId,
                movies: popularSeries,
              ),

              //airing today
              MovieSection(
                tableType: tableType,
                movies: airingToday,
                title: 'Airing Today',
                onShowAll: () {
                  context.push(
                    '/show-all',
                    extra: {
                      'title': 'Airing Today',
                      'tableType': tableType,
                      "movieType": MovieType.airingToday,
                    },
                  );
                },
              ),

              //New series
              MovieSection(
                tableType: tableType,
                movies: newSeries,
                title: 'New',
                onShowAll: () {
                  context.push(
                    '/show-all',
                    extra: {
                      'title': 'New',
                      'tableType': tableType,
                      "movieType": MovieType.nowPlaying,
                    },
                  );
                },
              ),

              //popular series
              MovieSection(
                tableType: tableType,
                movies: popularSeries,
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
              MovieSection(
                tableType: tableType,
                movies: trending,
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
              MovieSection(
                tableType: tableType,
                movies: upcoming,
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

              SliverToBoxAdapter(child: SizedBox(height: 85)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
