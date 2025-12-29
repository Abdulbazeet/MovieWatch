// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:movie_watch/config/utils.dart';
import 'package:shimmer/shimmer.dart';

import 'package:movie_watch/config/enums.dart';
import 'package:movie_watch/config/tmdb_config.dart';
import 'package:movie_watch/models/movie/movies.dart';

class MovieSection extends ConsumerWidget {
  final String title;
  final TableType tableType;
  final AsyncValue<List<Movie>> movies;
  final VoidCallback? onShowAll;

  const MovieSection({
    required this.title,
    required this.tableType,
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
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                InkWell(
                  onTap: onShowAll,
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      'Show all',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 200,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final imageWidth = constraints.maxWidth * 0.3;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final movie = list[index];
                        final date = DateTime.parse(movie.releaseDate!);

                        final formatedDate = DateFormat(
                          'MMM d, yyyy',
                        ).format(date);
                        return GestureDetector(
                          onTap: () {
                            switch (tableType) {
                              case TableType.movies:
                                context.push(
                                  '/details',
                                  extra: {
                                    'id': list[index].id,
                                    'tableType': tableType,
                                  },
                                );
                              case TableType.tvshows:
                                context.push(
                                  '/tvshows-details',
                                  extra: list[index].id
                                );
                                break;
                              default:
                            }
                          },
                          child: Container(
                            width: 100,
                            height: 150,
                            margin: EdgeInsets.only(right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CachedNetworkImage(
                                  imageUrl:
                                      '${TmdbConfig.img_url}w500${movie.posterPath}',
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                        width: 100,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
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
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                      ),
                                  errorWidget: (context, _, __) => Container(
                                    width: 100,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.surfaceVariant,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(Icons.broken_image),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  movie.title ?? '',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  formatedDate,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  //    ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            error: (error, _) => Padding(
              padding: EdgeInsets.all(20),
              child: Text('Error: $error'),
            ),
            loading: () => Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 200,
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
                      width: 100,
                      height: 150,
                      margin: EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: .5),
                        borderRadius: BorderRadius.circular(10),
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
