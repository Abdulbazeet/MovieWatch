import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:movie_watch/config/enums.dart';
import 'package:movie_watch/config/tmdb_config.dart';
import 'package:movie_watch/data/notifiers/movie-details_notifiers.dart';
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

  @override
  Widget build(BuildContext context) {
    final movieDetaiil = ref.watch(
      movieDetailsNotifierProvider(widget.currentMovie!.id),
    );
    return Scaffold(
      body: Center(
        child: movieDetaiil.when(
          data: (data) {
            final date = DateFormat(
              'MMMM d, yyyy',
            ).format(DateTime.parse(data.movieDetails.release_date));
            return ListView(
              children: [
                SizedBox(
                  height: .35.sh,
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
                        top: 10.r,
                        left: 0,

                        child: IconButton(
                          onPressed: () {
                            context.pop();
                          },
                          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        ),
                      ),
                      Positioned(
                        bottom: 10.r,
                        right: 20.r,
                        left: 20.r,
                        child: Row(
                          children: [
                            Icon(Icons.calendar_month, color: Colors.white),
                            SizedBox(width: 10.r),
                            Text(
                              date,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.r),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              data.movieDetails.title,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            icon: (Icon(Icons.favorite_rounded, size: 20.r)),
                          ),
                          IconButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            icon: (Icon(Icons.bookmark, size: 20.r)),
                          ),
                        ],
                      ),
                      if (data.movieDetails.tagline.isNotEmpty)
                        SizedBox(height: 5.r),
                      Text(
                        data.movieDetails.tagline,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(height: 10.r),
                      Text(
                        data.movieDetails.genres
                            .map((e) => e.name)
                            .join("  .  "),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.r),

                      Wrap(
                        children: [
                          Text(
                            data.movieDetails.overview,
                            style: Theme.of(context).textTheme.bodySmall,
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
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.r),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cast',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            'See all',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      SizedBox(height: 10.r),
                      SizedBox(
                        height: 170.h,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.credits.cast.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 10.r,
                                horizontal: 10.r,
                              ),
                              margin: EdgeInsets.only(right: 10.r),
                              decoration: BoxDecoration(
                                // color: Colors.grey,
                                borderRadius: BorderRadius.circular(10.r),
                              ),

                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 40.r,
                                    backgroundColor: Colors.grey,

                                    backgroundImage:
                                        data.credits.cast[index].profilePath!.isNotEmpty 
                                        ? NetworkImage(
                                            '${TmdbConfig.img_url}original${data.credits.cast[index].profilePath}',
                                          )
                                        : data.credits.cast[index].gender == 1
                                        ? AssetImage(
                                            'assets/images/female.jpeg',
                                          )
                                        : data.credits.cast[index].gender == 0
                                        ? AssetImage(
                                            'assets/images/unknown.png',
                                          )
                                        : data.credits.cast[index].gender == 2
                                        ? AssetImage('assets/images/male.png')
                                        : null,
                                  ),
                                 
                                  Text(
                                    data.credits.cast[index].originalName,
                                    textAlign: TextAlign.center,
                                    maxLines: 4,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    data.credits.cast[index].character,
                                    textAlign: TextAlign.center,
                                    maxLines: 4,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                  Text(
                                    data.credits.cast[index].knownForDepartment,
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
                      SizedBox(height: 10.r),
                      Row(
                        children: [
                          Text(
                            'Trailers',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      SizedBox(height: 10.r),
                      SizedBox(
                        height: 150.h,
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
                                  margin: EdgeInsets.only(right: 10.r),
                                  width: 240.w,
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
                                                      BorderRadius.circular(
                                                        10.r,
                                                      ),
                                                  child: Image.network(
                                                    thumbnailUrl,
                                                    width: double.infinity,
                                                    height: 200.h,
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
                      SizedBox(height: 10.r),
                      if (data.recommendations.isNotEmpty)
                        Row(
                          children: [
                            Text(
                              'Recommendations',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),

                      SizedBox(height: 10.r),
                      if (data.recommendations.isNotEmpty)
                        SizedBox(
                          height: 240.h,
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
                                  width: 130.w,
                                  margin: EdgeInsets.only(right: 20.r),
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
                                                  width: 130.w,
                                                  height: 190.h,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10.r,
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
                                                width: 130.w,
                                                height: 190.h,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.surfaceVariant,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        10.r,
                                                      ),
                                                ),
                                              ),
                                            ),
                                        errorWidget: (context, _, __) =>
                                            Container(
                                              width: 130.w,
                                              height: 190.h,
                                              decoration: BoxDecoration(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.surfaceVariant,
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                              ),
                                              child: const Icon(
                                                Icons.broken_image,
                                              ),
                                            ),
                                      ),
                                      SizedBox(height: 10.r),
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
                                      SizedBox(height: 10.r),
                                      Text(
                                        formatedDate,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
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
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
