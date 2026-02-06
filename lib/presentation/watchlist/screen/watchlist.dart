import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:movie_watch/config/enums.dart';
import 'package:movie_watch/config/tmdb_config.dart';
import 'package:movie_watch/data/tmdb_providers.dart';
import 'package:movie_watch/presentation/watchlist/widget/seen.dart';
import 'package:shimmer/shimmer.dart';

class Watchlist extends ConsumerStatefulWidget {
  const Watchlist({super.key});

  @override
  ConsumerState<Watchlist> createState() => _WatchlistState();
}

late TabController _tabBarController;

class _WatchlistState extends ConsumerState<Watchlist>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _tabBarController = TabController(length: 3, vsync: this);
  }

  List<String> favOptions = ['Movies', 'Tv Shows', 'Person'];

  String _favString = 'Movies';

  @override
  Widget build(BuildContext context) {
    final seenMovieList = ref.watch(seenProvider(MediaType.movie));
    final seenTvList = ref.watch(seenProvider(MediaType.tv));
    final favMList = ref.watch(favListProvider(MediaType.movie));
    final favTvList = ref.watch(favListProvider(MediaType.tv));
    final favPList = ref.watch(favListProvider(MediaType.person));
    return Scaffold(
      appBar: AppBar(
        title: Text("My Lists", style: Theme.of(context).textTheme.bodyMedium),
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
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                child: Text(
                  "Favourites",
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                child: Text(
                  "Watchlist",
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
            controller: _tabBarController,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabBarController,
              children: [
                SeenWidget(
                  seenMovieList: seenMovieList,
                  seenTvList: seenTvList,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      SizedBox(
                        height: 60,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,

                          children: List.generate(
                            favOptions.length,
                            (index) => Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: FilterChip(
                                onSelected: (value) {
                                  setState(() {
                                    if (value == true) {
                                      _favString = favOptions[index];
                                    }
                                  });
                                },
                                color: _favString == favOptions[index]
                                    ? WidgetStatePropertyAll(
                                        Theme.of(context).colorScheme.primary
                                            .withValues(alpha: .2),
                                      )
                                    : WidgetStatePropertyAll(
                                        Colors.grey.withValues(alpha: .2),
                                      ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),

                                  side: BorderSide(
                                    color: _favString == favOptions[index]
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey,
                                  ),
                                ),

                                label: Text(
                                  favOptions[index],
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      if (_favString == 'Movies') ...[
                        Expanded(
                          child: favMList.when(
                            data: (data) {
                              if (data.isEmpty) {
                                return Center(
                                  child: Text("No seen movies yet."),
                                );
                              }

                              return ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  final movie = data[index];
                                  final date =
                                      movie.releaseDate != null &&
                                          movie.releaseDate!.isNotEmpty
                                      ? DateFormat("EEE MMM d, yyyy").format(
                                          DateTime.parse(movie.releaseDate!),
                                        )
                                      : null;

                                  return GestureDetector(
                                    onTap: () {
                                      context.push(
                                        "/details",
                                        extra: {'id': movie.id},
                                      );
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 120,
                                      margin: EdgeInsets.only(bottom: 20),
                                      decoration: BoxDecoration(
                                        // color: Colors.grey
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.surface,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black,
                                            offset: Offset(3, 3),
                                            blurRadius: 3,
                                            spreadRadius: 0,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl:
                                                "${TmdbConfig.img_url}original/${movie.posterPath}",
                                            imageBuilder:
                                                (
                                                  context,
                                                  imageProvider,
                                                ) => Container(
                                                  width: 100,
                                                  height: 160,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                10,
                                                              ),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                10,
                                                              ),
                                                        ),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                            errorWidget:
                                                (
                                                  context,
                                                  url,
                                                  error,
                                                ) => Container(
                                                  width: 100,
                                                  height: 160,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                10,
                                                              ),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                10,
                                                              ),
                                                        ),
                                                  ),
                                                ),
                                            placeholder: (context, url) =>
                                                Shimmer.fromColors(
                                                  baseColor: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withValues(alpha: .5),
                                                  highlightColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .onSurface
                                                          .withValues(
                                                            alpha: .3,
                                                          ),
                                                  child: Container(
                                                    width: 100,
                                                    height: 160,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                  10,
                                                                ),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                  10,
                                                                ),
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10.0,
                                                  ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    movie.title ?? 'No Title',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    movie.overview ??
                                                        'No Description',
                                                    style: Theme.of(
                                                      context,
                                                    ).textTheme.bodySmall,
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(height: 10),

                                                  Row(
                                                    children: [
                                                      Text(
                                                        date!,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      movie.voteAverage != 0.0
                                                          ? Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.star,
                                                                  color: Colors
                                                                      .yellow,
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  "${movie.voteAverage.toStringAsFixed(1)} / 10",
                                                                  style: Theme.of(context)
                                                                      .textTheme
                                                                      .bodySmall
                                                                      ?.copyWith(
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                ),
                                                              ],
                                                            )
                                                          : SizedBox.shrink(),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            loading: () =>
                                Center(child: CircularProgressIndicator()),
                            error: (error, stackTrace) => Center(
                              child: Text("Error loading seen movies."),
                            ),
                          ),
                        ),
                      ],
                      if (_favString == 'Tv Shows') ...[
                        Expanded(
                          child: favTvList.when(
                            data: (data) {
                              if (data.isEmpty) {
                                return Center(
                                  child: Text("No favourite Tv shows yet."),
                                );
                              }

                              return ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  final movie = data[index];
                                  final date =
                                      movie.releaseDate != null &&
                                          movie.releaseDate!.isNotEmpty
                                      ? DateFormat("EEE MMM d, yyyy").format(
                                          DateTime.parse(movie.releaseDate!),
                                        )
                                      : null;

                                  return GestureDetector(
                                    onTap: () {
                                      context.push(
                                        "/tvshows-details",
                                        extra: movie.id,
                                      );
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 120,
                                      margin: EdgeInsets.only(bottom: 20),
                                      decoration: BoxDecoration(
                                        // color: Colors.grey
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.surface,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black,
                                            offset: Offset(3, 3),
                                            blurRadius: 3,
                                            spreadRadius: 0,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl:
                                                "${TmdbConfig.img_url}original/${movie.posterPath}",
                                            imageBuilder:
                                                (
                                                  context,
                                                  imageProvider,
                                                ) => Container(
                                                  width: 100,
                                                  height: 160,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                10,
                                                              ),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                10,
                                                              ),
                                                        ),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                            errorWidget:
                                                (
                                                  context,
                                                  url,
                                                  error,
                                                ) => Container(
                                                  width: 100,
                                                  height: 160,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                10,
                                                              ),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                10,
                                                              ),
                                                        ),
                                                  ),
                                                ),
                                            placeholder: (context, url) =>
                                                Shimmer.fromColors(
                                                  baseColor: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withValues(alpha: .5),
                                                  highlightColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .onSurface
                                                          .withValues(
                                                            alpha: .3,
                                                          ),
                                                  child: Container(
                                                    width: 100,
                                                    height: 160,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                  10,
                                                                ),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                  10,
                                                                ),
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10.0,
                                                  ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    movie.title ?? 'No Title',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    movie.overview ??
                                                        'No Description',
                                                    style: Theme.of(
                                                      context,
                                                    ).textTheme.bodySmall,
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(height: 10),

                                                  Row(
                                                    children: [
                                                      Text(
                                                        date!,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      movie.voteAverage != 0.0
                                                          ? Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.star,
                                                                  color: Colors
                                                                      .yellow,
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  "${movie.voteAverage.toStringAsFixed(1)} / 10",
                                                                  style: Theme.of(context)
                                                                      .textTheme
                                                                      .bodySmall
                                                                      ?.copyWith(
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                ),
                                                              ],
                                                            )
                                                          : SizedBox.shrink(),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            loading: () =>
                                Center(child: CircularProgressIndicator()),
                            error: (error, stackTrace) => Center(
                              child: Text("Error loading seen movies."),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        if (_favString == 'Person') ...[
                          Expanded(
                            child: favPList.when(
                              data: (data) {
                                if (data.isEmpty) {
                                  return Center(
                                    child: Text("No favourite persons yet."),
                                  );
                                }

                                return ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    final movie = data[index];
                                    final date =
                                        movie.releaseDate != null &&
                                            movie.releaseDate!.isNotEmpty
                                        ? DateFormat("EEE MMM d, yyyy").format(
                                            DateTime.parse(movie.releaseDate!),
                                          )
                                        : null;

                                    return GestureDetector(
                                      onTap: () {
                                        context.push(
                                          "/details",
                                          extra: {'id': movie.id},
                                        );
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 120,
                                        margin: EdgeInsets.only(bottom: 20),
                                        decoration: BoxDecoration(
                                          // color: Colors.grey
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.surface,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black,
                                              offset: Offset(3, 3),
                                              blurRadius: 3,
                                              spreadRadius: 0,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl:
                                                  "${TmdbConfig.img_url}original/${movie.posterPath}",
                                              imageBuilder:
                                                  (
                                                    context,
                                                    imageProvider,
                                                  ) => Container(
                                                    width: 100,
                                                    height: 160,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                  10,
                                                                ),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                  10,
                                                                ),
                                                          ),
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                              errorWidget:
                                                  (
                                                    context,
                                                    url,
                                                    error,
                                                  ) => Container(
                                                    width: 100,
                                                    height: 160,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                  10,
                                                                ),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                  10,
                                                                ),
                                                          ),
                                                    ),
                                                  ),
                                              placeholder: (context, url) =>
                                                  Shimmer.fromColors(
                                                    baseColor: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface
                                                        .withValues(alpha: .5),
                                                    highlightColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .onSurface
                                                            .withValues(
                                                              alpha: .3,
                                                            ),
                                                    child: Container(
                                                      width: 100,
                                                      height: 160,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                              topLeft:
                                                                  Radius.circular(
                                                                    10,
                                                                  ),
                                                              bottomLeft:
                                                                  Radius.circular(
                                                                    10,
                                                                  ),
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10.0,
                                                    ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      movie.title ?? 'No Title',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                      movie.overview ??
                                                          'No Description',
                                                      style: Theme.of(
                                                        context,
                                                      ).textTheme.bodySmall,
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(height: 10),

                                                    Row(
                                                      children: [
                                                        Text(
                                                          date!,
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .bodySmall
                                                              ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        movie.voteAverage != 0.0
                                                            ? Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons.star,
                                                                    color: Colors
                                                                        .yellow,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(
                                                                    "${movie.voteAverage.toStringAsFixed(1)} / 10",
                                                                    style: Theme.of(context)
                                                                        .textTheme
                                                                        .bodySmall
                                                                        ?.copyWith(
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                  ),
                                                                ],
                                                              )
                                                            : SizedBox.shrink(),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              loading: () =>
                                  Center(child: CircularProgressIndicator()),
                              error: (error, stackTrace) => Center(
                                child: Text("Error loading favourite  person."),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
                Center(child: Text("Watchlist")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
