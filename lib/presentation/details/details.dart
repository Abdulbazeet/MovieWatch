import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:movie_watch/config/enums.dart';
import 'package:movie_watch/config/tmdb_config.dart';
import 'package:movie_watch/config/utils.dart';
import 'package:movie_watch/data/notifiers/favourite_notifier.dart';
import 'package:movie_watch/data/notifiers/movie-details_notifiers.dart';
import 'package:movie_watch/data/notifiers/seen_notifier.dart';
import 'package:movie_watch/data/notifiers/watch_notifier.dart';
import 'package:movie_watch/models/movie/credits.dart';
import 'package:shimmer/shimmer.dart';

class Details extends ConsumerStatefulWidget {
  final int movieId;
  // final MovieType tableType;

  const Details({super.key, required this.movieId});

  @override
  ConsumerState<Details> createState() => _DetailsState();
}

class _DetailsState extends ConsumerState<Details> {
  bool isExpanded = false;
  TextOverflow? _overflow = TextOverflow.ellipsis;
  int? maxline = 3;
  String more = 'See more';
  @override
  void initState() {
    super.initState();
    //  _youtubePlayerController = YoutubePlayerController(initialVideoId: );
  }

  String text = 'Unmark from seen';

  @override
  Widget build(BuildContext context) {
    final movieDetaiil = ref.watch(
      movieDetailsNotifierProvider(widget.movieId),
    );
    final screensize = MediaQuery.of(context).size.height;
    final fav = ref.watch(favouriteNotifierProvider.notifier);
    final isFav = ref.watch(
      isFavouriteProvider((widget.movieId, MediaType.movie)),
    );
    final seenNotifier = ref.watch(seenNotifierProvider.notifier);
    final isSeen = ref.watch(isSeenProvider((widget.movieId, MediaType.movie)));
    final watch = ref.watch(watchNotifierProvider.notifier);
    final isWatch = ref.watch(
      isInWatchListProvider((widget.movieId, MediaType.movie)),
    );
    ref.listen(favouriteNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (data) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data.toString()),
              duration: Duration(seconds: 1),
            ),
          );
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('An error occurred: $error'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 1),
            ),
          );
        },
      );
    });
    ref.listen(seenNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (data) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data.toString()),
              // backgroundColor: Colors.green,
              duration: Duration(seconds: 1),
            ),
          );
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('An error occurred: $error'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 1),
            ),
          );
        },
      );
    });
    ref.listen(watchNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (data) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data.toString()),
              // backgroundColor: Colors.green,
              duration: Duration(seconds: 1),
            ),
          );
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('An error occurred: $error'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 1),
            ),
          );
        },
      );
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: movieDetaiil.when(
            data: (data) {
              final date = DateFormat(
                'yyyy',
              ).format(DateTime.parse(data.movieDetails.release_date));
              final duration = Utils.timeDuration(data.movieDetails.runtime);
              final List<Cast> casts = data.credits.cast.where((n) {
                return n.known_for_department == 'Acting';
              }).toList();
              final directors = data.credits.cast
                  .where((crew) => crew.known_for_department == 'Directing')
                  .map((writer) => writer.name)
                  .join(', ');
              final writers = data.credits.cast
                  .where((crew) => crew.known_for_department == 'Writing')
                  .map((writer) => writer.name)
                  .join(', ');
        
              return ListView(
                children: [
                  SizedBox(
                    height: screensize * .35,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CachedNetworkImage(
                            imageUrl: data.movieDetails.backdrop_path.isNotEmpty
                                ? '${TmdbConfig.img_url}original${data.movieDetails.backdrop_path}'
                                : '${TmdbConfig.img_url}original${data.movieDetails.poster_path}',
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: .5),
                              highlightColor: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: .3),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surfaceVariant,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: .9),
                                    Colors.black.withValues(alpha: .5),
                                    Colors.transparent,
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: .5),
                                    Colors.black.withValues(alpha: .9),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
        
                        Positioned(
                          top: 10,
                          left: 0,
        
                          child: IconButton(
                            onPressed: () {
                              context.pop();
                            },
                            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 20,
                          left: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                data.movieDetails.title,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                              ),
        
                              Row(
                                children: [
                                  Text(
                                    date,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: Colors.white),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: Text(
                                      "•",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 8, // makes it a small bullet
                                        height: 1, // removes extra line-height
                                        fontWeight: FontWeight
                                            .w900, // makes the dot perfectly round
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 16,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "${data.movieDetails.vote_average.toStringAsFixed(1)}/10",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: Text(
                                      "•",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 8, // makes it a small bullet
                                        height: 1, // removes extra line-height
                                        fontWeight: FontWeight
                                            .w900, // makes the dot perfectly round
                                      ),
                                    ),
                                  ),
                                  Text(
                                    duration,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
        
                  SizedBox(height: 20),
        
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
        
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  foregroundColor: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  // minimumSize: Size(70, 40),
                                ),
                                child: Text(
                                  'Watch Trailer',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            IconButton(
                              onPressed: () {
                                if (isSeen.value == true) {
                                  seenNotifier.removeSeen(
                                    widget.movieId,
                                    MediaType.movie,
                                  );
                                } else {
                                  seenNotifier.addSeen(
                                    widget.movieId,
                                    MediaType.movie,
                                  );
                                }
                              },
                              icon: Icon(
                                isSeen.whenOrNull(
                                  data: (data) => data
                                      ? Icons.visibility_sharp
                                      : Icons.visibility_off_outlined,
                                ),
        
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (isFav.value == true) {
                                  fav.removeFavourite(
                                    widget.movieId,
                                    MediaType.movie,
                                  );
                                } else {
                                  fav.addFavourite(
                                    widget.movieId,
                                    MediaType.movie,
                                  );
                                }
                              },
                              icon: Icon(
                                isFav.whenOrNull(
                                  data: (data) => data
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                ),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (isWatch.value == true) {
                                  watch.removeWatch(
                                    widget.movieId,
                                    MediaType.movie,
                                  );
                                } else {
                                  watch.addWatch(widget.movieId, MediaType.movie);
                                }
                              },
                              icon: Icon(
                                isWatch.whenOrNull(
                                  data: (data) => data
                                      ? Icons.bookmark
                                      : Icons.bookmark_add_outlined,
                                ),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Align(
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        '${TmdbConfig.img_url}w300${data.movieDetails.poster_path}',
        
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                          height: 150,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            ),
                                            image: DecorationImage(
                                              image: imageProvider,
                                            ),
                                          ),
                                        ),
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                          baseColor: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: .5),
                                          highlightColor: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: .3),
                                          child: Container(
                                            height: 150,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.surfaceVariant,
                                              borderRadius: BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                          ),
                                        ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                          height: 150,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            color: Colors.grey,
                                          ),
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 30,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: data.movieDetails.genres.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(right: 8),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primaryContainer,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Text(
                                            data.movieDetails.genres[index].name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.secondary,
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    data.movieDetails.tagline,
                                    style: Theme.of(context).textTheme.labelSmall
                                        ?.copyWith(fontStyle: FontStyle.italic),
                                  ),
                                  SizedBox(height: 5),
                                  Wrap(
                                    children: [
                                      Text(
                                        data.movieDetails.overview,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                        maxLines: maxline,
                                        overflow: _overflow,
                                      ),
        
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (maxline == 3) {
                                              maxline = null;
                                              more = 'See less';
                                              _overflow = null;
                                            } else {
                                              maxline = 3;
                                              more = 'See more';
                                              _overflow = TextOverflow.ellipsis;
                                            }
                                          });
                                        },
                                        child: Text(
                                          more,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
        
                        if (directors.isNotEmpty) ...[
                          SizedBox(height: 30),
        
                          Divider(color: Theme.of(context).colorScheme.onSurface),
                          SizedBox(height: 10),
        
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Directors',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              SizedBox(height: 5),
                              Text(
                                directors,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                              ),
                            ],
                          ),
                        ],
                        if (writers.isNotEmpty) ...[
                          SizedBox(height: 10),
        
                          Divider(color: Theme.of(context).colorScheme.onSurface),
                          SizedBox(height: 10),
        
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Writers',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              SizedBox(height: 5),
                              Text(
                                writers,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
        
                          Divider(color: Theme.of(context).colorScheme.onSurface),
                        ],
                        if (casts.isNotEmpty) ...[
                          SizedBox(height: 30),
        
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Top Cast',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                'See all',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            height: 240,
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              clipBehavior: Clip.none,
                              itemCount: casts.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    context.push(
                                      '/person-details',
                                      extra: {
                                        'id': casts[index].id,
                                        'name': casts[index].name,
                                      },
                                    );
                                  },
                                  child: Container(
                                    width: 130,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 20,
                                      //  horizontal: 10,
                                    ).copyWith(top: 0),
                                    margin: EdgeInsets.only(right: 20),
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
        
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl:
                                              casts[index].profilePath!.isNotEmpty
                                              ? '${TmdbConfig.img_url}original${casts[index].profilePath}'
                                              : casts[index].gender == 1
                                              ? 'assets/images/female.jpeg'
                                              : casts[index].gender == 2
                                              ? 'assets/images/male.png'
                                              : 'assets/images/unknown.png',
                                          imageBuilder:
                                              (
                                                context,
                                                imageProvider,
                                              ) => Container(
                                                width: 130, // = radius * 2
                                                height: 150,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(10),
                                                    topRight: Radius.circular(10),
                                                  ),
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                          errorWidget: (context, url, error) {
                                            return Container(
                                              width: 130, // = radius * 2
                                              height: 150,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft: Radius.circular(10),
                                                ),
                                                color: Colors.grey,
                                              ),
                                            );
                                          },
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                                baseColor: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withValues(alpha: .5),
                                                highlightColor: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withValues(alpha: .3),
                                                child: Container(
                                                  width: 130, // = radius * 2
                                                  height: 150,
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.surfaceVariant,
                                                    borderRadius:
                                                        BorderRadius.horizontal(
                                                          left: Radius.circular(
                                                            10,
                                                          ),
                                                          right: Radius.circular(
                                                            10,
                                                          ),
                                                        ),
                                                  ),
                                                ),
                                              ),
                                        ),
        
                                        SizedBox(height: 5),
                                        Text(
                                          casts[index].originalName,
                                          textAlign: TextAlign.center,
                                          maxLines: 4,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        Text(
                                          casts[index].character,
                                          textAlign: TextAlign.center,
                                          maxLines: 4,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
        
                        SizedBox(height: 30),
                        if (data.recommendations.isNotEmpty)
                          Row(
                            children: [
                              Text(
                                'Recommendations',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
        
                        SizedBox(height: 10),
                        if (data.recommendations.isNotEmpty)
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              itemCount: data.recommendations.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final movie = data.recommendations[index];
                                final date = DateTime.parse(movie.releaseDate!);
        
                                final formatedDate = DateFormat(
                                  'MMM d, yyyy',
                                ).format(date);
                                return GestureDetector(
                                  onTap: () {
                                    context.push(
                                      '/details',
                                      extra: {
                                        'id': data.recommendations[index].id,
                                      },
                                    );
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 150,
                                    margin: EdgeInsets.only(right: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl:
                                              '${TmdbConfig.img_url}w500${movie.posterPath}',
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                                    width: 100,
                                                    height: 150,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                                baseColor: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withValues(alpha: .5),
                                                highlightColor: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withValues(alpha: .3),
                                                child: Container(
                                                  width: 100,
                                                  height: 150,
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.surfaceVariant,
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                  ),
                                                ),
                                              ),
                                          errorWidget: (context, _, __) =>
                                              Container(
                                                width: 100,
                                                height: 150,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.surfaceVariant,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: const Icon(
                                                  Icons.broken_image,
                                                ),
                                              ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          movie.title ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          formatedDate,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
            error: (error, stackTrace) {
              return Text(error.toString());
            },
        
            loading: () {
              return const CircularProgressIndicator.adaptive();
            },
          ),
        ),
      ),
    );
  }
}
