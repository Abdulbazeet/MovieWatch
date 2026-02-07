import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:movie_watch/config/enums.dart';
import 'package:movie_watch/config/tmdb_config.dart';
import 'package:movie_watch/data/tmdb_providers.dart';
import 'package:movie_watch/presentation/watchlist/widget/favourite.dart';
import 'package:movie_watch/presentation/watchlist/widget/seen.dart';
import 'package:shimmer/shimmer.dart';

class Watchlist extends ConsumerWidget {
  const Watchlist({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seenMovieList = ref.watch(seenProvider(MediaType.movie));
    final seenTvList = ref.watch(seenProvider(MediaType.tv));
    final favMList = ref.watch(favListProvider(MediaType.movie));
    final favTvList = ref.watch(favListProvider(MediaType.tv));
    final favPList = ref.watch(favListProvider(MediaType.person));
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "My Lists",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            TabBar(
              dividerColor: Colors.transparent,
              tabs: [
                Tab(
                  child: Text(
                    "Seenlist",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    "Favourites",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    "Watchlist",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SeenWidget(
                    seenMovieList: seenMovieList,
                    seenTvList: seenTvList,
                  ),
                  FavouriteWidget(
                    favMList: favMList,
                    favTvList: favTvList,
                    favPList: favPList,
                  ),
                  Center(child: Text("Watchlist")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
