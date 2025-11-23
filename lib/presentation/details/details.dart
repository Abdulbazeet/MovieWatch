import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:movie_watch/config/enums.dart';
import 'package:movie_watch/config/tmdb_config.dart';
import 'package:movie_watch/config/utils.dart';
import 'package:movie_watch/data/notifiers/movie-details_notifiers.dart';
import 'package:movie_watch/models/credits.dart';
import 'package:movie_watch/models/movies.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Details extends ConsumerStatefulWidget {
  final Movie? currentMovie;
  final TableType tableType;

  const Details({
    super.key,
    required this.currentMovie,
    required this.tableType,
  });

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
      movieDetailsNotifierProvider(widget.currentMovie!.id),
    );
    final screensize = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: movieDetaiil.when(
          data: (data) {
            final date = DateFormat(
              'yyyy',
            ).format(DateTime.parse(data.movieDetails.release_date));
            final duration = Utils.timeDuration(data.movieDetails.runtime);
            final List<Cast> casts = data.credits.cast.where((n) {
              return n.known_for_department == 'Acting';
            }).toList();
            final String directors = data.credits.cast
                .where((crew) => crew.known_for_department == 'Directing')
                .map((writer) => writer.name)
                .join(', ');
            final String writers = data.credits.cast
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
                        child: Container(
                          color: Colors.grey,
                          child: Image.network(
                            '${TmdbConfig.img_url}original${data.movieDetails.backdrop_path}',
                            fit: BoxFit.cover,
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
                            SizedBox(height: 10),
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
                                SizedBox(width: 30),
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
                                    ),
                                    child: Text(
                                      'Watch Trailer',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
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
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      SizedBox(height: 5),

                      SizedBox(height: 30),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Align(
                                child: Container(
                                  height: 150,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        '${TmdbConfig.img_url}w300${data.movieDetails.poster_path}',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,

                                left: 0,

                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: .7),
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Icon(Icons.add, color: Colors.white),
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
                      SizedBox(height:30),
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
                        height: 260,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          clipBehavior: Clip.none,
                          itemCount: casts.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 130,
                              padding: EdgeInsets.symmetric(
                                vertical: 20,
                                //  horizontal: 10,
                              ).copyWith(top: 0),
                              margin: EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                // color: Colors.grey
                                color: Theme.of(context).colorScheme.surface,
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
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    child: Container(
                                      width: 130, // = radius * 2
                                      height: 150,
                                      color: Colors.grey,

                                      child: Image.network(
                                        data
                                                .credits
                                                .cast[index]
                                                .profilePath!
                                                .isNotEmpty
                                            ? '${TmdbConfig.img_url}original${casts[index].profilePath}'
                                            : casts[index].gender == 1
                                            ? 'assets/images/female.jpeg'
                                            : casts[index].gender == 2
                                            ? 'assets/images/male.png'
                                            : 'assets/images/unknown.png',
                                        fit: BoxFit.cover,
                                        // ← THIS IS THE KEY
                                        // loadingBuilder:
                                        //     (context, child, loadingProgress) {
                                        //       if (loadingProgress == null)
                                        //         return child;
                                        //       return CircleAvatar(
                                        //         radius: 40,
                                        //         backgroundColor:
                                        //             Colors.grey.shade800,
                                        //       );
                                        //     },
                                        // errorBuilder:
                                        //     (context, error, stackTrace) =>
                                        //         CircleAvatar(
                                        //           radius: 40,
                                        //           backgroundColor:
                                        //               Colors.grey.shade800,
                                        //         ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    casts[index].originalName,
                                    textAlign: TextAlign.center,
                                    maxLines: 4,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
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
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        children: [
                          Text(
                            'Trailers',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          // physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.video.results.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final video = data.video.results[index];

                            // Only YouTube videos are supported
                            if (video.site != 'YouTube') {
                              return const SizedBox.shrink();
                            }

                            final videoId = YoutubePlayer.convertUrlToId(
                              'https://www.youtube.com/watch?v=${video.key}',
                            );

                            // Thumbnail URL from YouTube
                            final thumbnailUrl =
                                'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

                            // Local state to control when player loads
                            bool showPlayer = false;

                            return StatefulBuilder(
                              builder: (context, setInnerState) {
                                return Container(
                                  margin: EdgeInsets.only(right: 10),
                                  width: 240,
                                  child: GestureDetector(
                                    onTap: () {
                                      setInnerState(() {
                                        showPlayer = true;
                                      });
                                    },
                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      child: showPlayer
                                          ? YoutubePlayer(
                                              key: ValueKey(videoId),
                                              controller:
                                                  YoutubePlayerController(
                                                    initialVideoId:
                                                        videoId ?? '',
                                                    flags:
                                                        const YoutubePlayerFlags(
                                                          autoPlay: true,
                                                          mute: false,
                                                          enableCaption: false,
                                                        ),
                                                  ),
                                              showVideoProgressIndicator: true,
                                              progressIndicatorColor: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            )
                                          : Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    thumbnailUrl,
                                                    width: double.infinity,
                                                    height: 200,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                  ),
                                                  child: const Icon(
                                                    Icons.play_arrow_rounded,
                                                    size: 60,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
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
                                      'movie': data.recommendations[index],

                                      'tableType': widget.tableType,
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
    );
  }
}
