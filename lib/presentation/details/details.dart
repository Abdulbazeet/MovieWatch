import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_watch/config/tmdb_config.dart';
import 'package:movie_watch/data/tmdb_providers.dart';
import 'package:movie_watch/models/movies.dart';
import 'package:shimmer/shimmer.dart';

class Details extends ConsumerStatefulWidget {
  final Movie? currentMovie;
  const Details({super.key, this.currentMovie});

  @override
  ConsumerState<Details> createState() => _DetailsState();
}

class _DetailsState extends ConsumerState<Details> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final movie_details = ref.watch(
      movieDetailsProvider(widget.currentMovie!.id),
    );
    final cast_details = ref.watch(movieCreditsProvider(widget.currentMovie!.id));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 40.h,
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.currentMovie!.id,
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
                          Tween(
                            begin: 0.6,
                            end: 1.0,
                          ).chain(CurveTween(curve: Curves.easeInOut)),
                        ),
                        child: ScaleTransition(
                          scale: animation.drive(
                            Tween(
                              begin: 0.95,
                              end: 1.0,
                            ).chain(CurveTween(curve: Curves.easeInOut)),
                          ),
                          child: toContext.widget,
                        ),
                      );
                    },
                child: CachedNetworkImage(
                  imageUrl:
                      'https://image.tmdb.org/t/p/w780${widget.currentMovie!.backdropPath}',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,

                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: .5),
                    highlightColor: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: .3),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Theme.of(context).colorScheme.surfaceVariant,
                    ),
                  ),

                  errorWidget: (context, error, stackTrace) => CachedNetworkImage(
                    imageUrl:
                        'https://image.tmdb.org/t/p/w500${widget.currentMovie!.backdropPath}',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: .5),
                      highlightColor: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: .3),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Theme.of(context).colorScheme.surfaceVariant,
                      ),
                    ),
                    errorWidget: (context, _, __) =>
                        const Icon(Icons.broken_image),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                children: [
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Expanded(
                        child: Hero(
                          tag: widget.currentMovie!.title!,
                          child: Text(
                            widget.currentMovie!.title!,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      GestureDetector(
                        onTap: () {},
                        child: Icon(Icons.bookmark_add),
                      ),
                      SizedBox(width: 3.w),
                      GestureDetector(onTap: () {}, child: Icon(Icons.share)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                children: [
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Text(
                        movie_details.value != null
                            ? movie_details.value!.release_date.substring(0, 4)
                            : 'Loading',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '|',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Icon(Icons.star, color: Colors.amber, size: 15.sp),
                      SizedBox(width: 2.w),
                      Text(
                        widget.currentMovie!.voteAverage.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      movie_details.when(
                        data: (data) {
                          final genre = data.genres;
                          return Wrap(
                            spacing: 2.w,
                            children: [
                              for (int i = 0; i < genre.length; i++) ...[
                                Text(
                                  genre[i].name,
                                  style: Theme.of(context).textTheme.bodyMedium!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                if (i < genre.length - 1)
                                  Text(
                                    '|',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                              ],
                            ],
                          );
                        },
                        error: (_, __) => Text(
                          'Error loading genres',
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        loading: () {
                          return SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  AnimatedSize(
                    duration: Duration(milliseconds: 300),
                    child: movie_details.when(
                      data: (data) => Text(
                        data.overview,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: isExpanded ? null : 5,
                        overflow: isExpanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                      ),
                      error: (_, __) => Text(
                        'Error loading overview',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      loading: () => Text(
                        'Loading overview...',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  //  SizedBox(height: 3.h),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Text(
                      isExpanded ? 'See less...' : 'See more...',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        // fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cast',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'See more',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      cast_details.when(
                        data: (cast) {
                          return Column(
                            children: [
                              // CachedNetworkImage(
                              //   imageUrl:
                              //       "${TmdbConfig.img_url}w200/${cast.profilePath}",
                              // ),
                              Text(cast.name),
                            ],
                          );
                        },
                        error: (error, stackTrace) {
                          return Text(
                            '$error - $stackTrace',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontStyle: FontStyle.italic),
                          );
                        },
                        loading: () {
                          return Text(
                            'Loading...',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontStyle: FontStyle.italic),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
