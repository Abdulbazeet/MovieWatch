import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:movie_watch/config/tmdb_config.dart';
import 'package:movie_watch/models/movies.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
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
            padding: EdgeInsets.symmetric(horizontal: 5.sw, vertical: 1.h),
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
                  child: Text(
                    'Show all',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Movie list
          movies.when(
            data: (list) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.sw),
              child: SizedBox(
                height: 30.sh,
                child: ListView.builder(
                
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final movie = list[index];
                    final date = DateTime.parse(movie.releaseDate!);

                    final formatedDate = DateFormat('MMM d, yyyy').format(date);
                    return Container(
                      width: 35.sw,
                      margin: EdgeInsets.only(right: 3.sw),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl:
                                '${TmdbConfig.img_url}w500${movie.posterPath}',
                            imageBuilder: (context, imageProvider) => Container(
                              width: 35.sw,
                              height: 24.sh,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
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
                                width: 35.sw,
                                height: 24.sh,
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surfaceVariant,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            errorWidget: (context, _, __) =>
                                const Icon(Icons.broken_image),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            movie.title ?? '',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 1.h),
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
              padding: const EdgeInsets.all(16.0),
              child: Text('Error: $error'),
            ),
            loading: () => Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.sw),
              child: SizedBox(
                height: 24.sh,
                child: Shimmer.fromColors(
                  baseColor: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: .5),
                  highlightColor: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: .3),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (_, __) => Container(
                      width: 35.sw,
                      margin: EdgeInsets.only(right: 3.sw),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
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
