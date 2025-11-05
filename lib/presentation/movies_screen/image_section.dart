// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import 'package:movie_watch/config/tmdb_config.dart';
import 'package:movie_watch/models/genre.dart';
import 'package:movie_watch/models/movies.dart';

class ImageSection extends ConsumerWidget {
  final VoidCallback? onPressesd;
  final AsyncValue<List<Movie>> movies;
  final AsyncValue<List<Genres>> genreId;
  const ImageSection({
    this.onPressesd,
    required this.movies,
    required this.genreId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: movies.when(
        data: (data) {
          return SizedBox(
            width: double.infinity,
            height: 220.h,

            child: Stack(
              children: [
                CarouselSlider.builder(
                  options: CarouselOptions(
                    autoPlay: true,
                    enableInfiniteScroll: true,
                    height: 220.h,
                    viewportFraction: .80,
                  ),
                  itemCount: data.length,

                  itemBuilder: (context, index, realIndex) {
                    return Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 20.r),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: GestureDetector(
                            onTap: onPressesd,
                            child: Hero(
                              tag: data[index].id,
                              transitionOnUserGestures: true,
                              flightShuttleBuilder:
                                  (
                                    flightContext,
                                    animation,
                                    direction,
                                    fromContext,
                                    toContext,
                                  ) {
                                    return FadeTransition(
                                      opacity: animation.drive(
                                        Tween(begin: 0.6, end: 1.0).chain(
                                          CurveTween(curve: Curves.easeInOut),
                                        ),
                                      ),
                                      child: ScaleTransition(
                                        scale: animation.drive(
                                          Tween(begin: 0.95, end: 1.0).chain(
                                            CurveTween(curve: Curves.easeInOut),
                                          ),
                                        ),
                                        child: toContext.widget,
                                      ),
                                    );
                                  },
                              child: CachedNetworkImage(
                                imageUrl:
                                    '${TmdbConfig.img_url}w780${data[index].backdropPath}',
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,

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
                                        width: double.infinity,
                                        height: double.infinity,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.surfaceVariant,
                                      ),
                                    ),

                                errorWidget: (context, error, stackTrace) =>
                                    CachedNetworkImage(
                                      imageUrl:
                                          '${TmdbConfig.img_url}w500${data[index].posterPath}',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
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
                                              width: double.infinity,
                                              height: double.infinity,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.surfaceVariant,
                                            ),
                                          ),
                                      errorWidget: (context, _, __) =>
                                          const Icon(Icons.broken_image),
                                    ),
                              ),
                            ),
                          ),
                        ),

                        Positioned.fill(
                          child: IgnorePointer(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: .5),
                                    Colors.black.withValues(alpha: .7),
                                    Colors.black.withValues(alpha: .7),
                                  ],
                                  //  stops: const [0.0, 0.7, 1.0],
                                ),
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          right: 0,
                          left: 0,
                          bottom: 2.h,
                          child: IgnorePointer(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.r),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Hero(
                                    tag: data[index].title!,
                                    child: Text(
                                      data[index].title!,
                                      textAlign: TextAlign.center,
                                      style:
                                          // ),
                                          Theme.of(
                                            context,
                                          ).textTheme.bodyLarge?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                          ),
                                    ),
                                  ),
                                  SizedBox(height: 10.r),
                                  SizedBox(height: 10.r),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        data[index].releaseDate!.substring(
                                          0,
                                          4,
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                            ),
                                      ),
                                      SizedBox(width: 10.r),
                                      Text(
                                        '|',
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                        ),
                                      ),
                                      SizedBox(width: 10.r),
                                      Expanded(
                                        child: genreId.when(
                                          data: (genres) {
                                            final movieGenres = data[index]
                                                .genreIds
                                                .map(
                                                  (id) => genres
                                                      .firstWhere(
                                                        (g) => g.id == id,
                                                        orElse: () => Genres(
                                                          id: 0,
                                                          name: '',
                                                        ),
                                                      )
                                                      .name,
                                                )
                                                .where(
                                                  (name) => name.isNotEmpty,
                                                )
                                                .toList();

                                            final genreText = movieGenres.join(
                                              ' • ',
                                            );

                                            return Text(
                                              genreText,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.secondary,
                                                  ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            );
                                          },
                                          error: (e, _) =>
                                              Text('Error loading genres'),
                                          loading: () =>
                                              const SizedBox.shrink(),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 10.r),

                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.visibility,
                                        size: 15.sp,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                      SizedBox(width: 10.w),
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 15.sp,
                                      ),
                                      SizedBox(width: 10.w),
                                      Text(
                                        data[index].voteAverage.toStringAsFixed(
                                          1,
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 1.h),
                                  SizedBox(height: 10.r),
                                  // Row(
                                  //   children: [
                                  //     ElevatedButton(
                                  //       onPressed: () {},
                                  //       style: ElevatedButton.styleFrom(
                                  //         fixedSize: Size(40.w, 6.h),
                                  //       ),
                                  //       child: Text('Watch Trailer'),
                                  //     ),
                                  //     SizedBox(width: 5.w),
                                  //     ElevatedButton(
                                  //       onPressed: () {},
                                  //       style: ElevatedButton.styleFrom(
                                  //         fixedSize: Size(10.w, 6.h),
                                  //         padding: EdgeInsets.zero,
                                  //         alignment: Alignment.center,
                                  //       ),
                                  //       child: Icon(
                                  //         Icons.bookmark_add,
                                  //         size: 20.sp,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) {
          return Text('Error: $error');
        },
        loading: () {
          return SizedBox(
            height: 40.h,
            child: Shimmer.fromColors(
              baseColor: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: .5),
              highlightColor: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: .3),
              //  period: const Duration(milliseconds: 1200),
              child: Container(
                width: double.infinity,
                height: 40.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
