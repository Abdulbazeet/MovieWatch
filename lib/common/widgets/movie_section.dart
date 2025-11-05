import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:movie_watch/config/tmdb_config.dart';
import 'package:movie_watch/models/movies.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieSection extends ConsumerWidget {
  final String title;
  final AsyncValue<List<Movie>> movies;
  final VoidCallback? onShowAll;

  const MovieSection({
    super.key,
    required this.title,
    required this.movies,
    this.onShowAll,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header Row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 20.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                
                  onTap: onShowAll,
                  child: Container(
                   margin: EdgeInsets.only(left: 10.r,),
                    child: Text(
                      'Show all',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Movie list
          movies.when(
            data: (list) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.r),
              child: SizedBox(
                height: 240.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final movie = list[index];
                    final date = DateTime.parse(movie.releaseDate!);

                    final formatedDate = DateFormat('MMM d, yyyy').format(date);
                    return Container(
                      width: 130.w,
                      margin: EdgeInsets.only(right: 20.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl:
                                '${TmdbConfig.img_url}w500${movie.posterPath}',
                            imageBuilder: (context, imageProvider) => Container(
                              width: 130.w,
                              height: 190.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
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
                                width: 130.w,
                                height: 190.h,
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surfaceVariant,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                            ),
                            errorWidget: (context, _, __) => Container(
                              width: 130.w,
                              height: 190.h,
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: const Icon(Icons.broken_image),
                            ),
                          ),
                          SizedBox(height: 10.r),
                          Text(
                            movie.title ?? '',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 10.r),
                          Text(
                            formatedDate,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            error: (error, _) => Padding(
              padding: EdgeInsets.all(20.r),
              child: Text('Error: $error'),
            ),
            loading: () => Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.r),
              child: SizedBox(
                height: 190.h,
                child: Shimmer.fromColors(
                  baseColor: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: .5),
                  highlightColor: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: .3),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 20,
                    itemBuilder: (_, __) => Container(
                      width: 130.w,
                      margin: EdgeInsets.only(right: 20.r),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: .5),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
