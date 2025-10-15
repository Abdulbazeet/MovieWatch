import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_watch/data/tmdb_providers.dart';
import 'package:movie_watch/models/genre.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  String dropdownvalue = 'One';

  @override
  Widget build(BuildContext context) {
    final populaMovies = ref.watch(popularMoviesProvider);
    final genreId = ref.watch(genreProvider);
    final controller = PageController(viewportFraction: 1, initialPage: 0);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            populaMovies.when(
              data: (data) {
                return SizedBox(
                  width: double.infinity,
                  height: 40.sh,

                  child: Stack(
                    children: [
                      PageView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        controller: controller,
                        scrollDirection: Axis.horizontal,
                        itemCount: data[0].results.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl:
                                    'https://image.tmdb.org/t/p/w780${data[0].results[index].backdropPath}',
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,

                                // 🪄 Placeholder shimmer while loading
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                      baseColor: Theme.of(
                                        context,
                                      ).colorScheme.surfaceVariant,
                                      highlightColor: Theme.of(
                                        context,
                                      ).colorScheme.surface,
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
                                          'https://image.tmdb.org/t/p/w500${data[0].results[index].posterPath}',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          Shimmer.fromColors(
                                            baseColor: Theme.of(
                                              context,
                                            ).colorScheme.surfaceVariant,
                                            highlightColor: Theme.of(
                                              context,
                                            ).colorScheme.surface,
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

                              // Image.network(
                              //   'https://image.tmdb.org/t/p/w780${data[0].results[index].backdropPath}',
                              //   width: double.infinity,
                              //   height: double.infinity,
                              //   fit: BoxFit.cover,
                              //   errorBuilder: (context, error, stackTrace) {
                              //     // fallback to poster if backdrop missing
                              //     return Image.network(
                              //       'https://image.tmdb.org/t/p/w500${data[0].results[index].posterPath}',
                              //       width: double.infinity,
                              //       height: double.infinity,
                              //       fit: BoxFit.cover,
                              //     );
                              //   },
                              // ),
                              Positioned.fill(
                                child: IgnorePointer(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: .4),
                                    ),
                                  ),
                                ),
                              ),

                              Positioned(
                                right: 0,
                                left: 0,
                                bottom: 2.sh,
                                child: IgnorePointer(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5.sw,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          data[0].results[index].title,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 1.h),
                                        Row(
                                          children: [
                                            Text(
                                              data[0].results[index].releaseDate
                                                  .substring(0, 4),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.secondary,
                                                  ),
                                            ),

                                            SizedBox(width: 3.w),

                                            Text(
                                              '|',
                                              style: TextStyle(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.secondary,
                                              ),
                                            ),
                                            SizedBox(width: 3.w),
                                            genreId.when(
                                              data: (genres) {
                                                final movieGenres = data[0]
                                                    .results[index]
                                                    .genreIds
                                                    .map((id) {
                                                      final matched = genres
                                                          .firstWhere(
                                                            (g) => g.id == id,
                                                            orElse: () => Genre(
                                                              id: 0,
                                                              name: '',
                                                            ),
                                                          );
                                                      return matched.name;
                                                    })
                                                    .where(
                                                      (name) => name.isNotEmpty,
                                                    )
                                                    .toList();

                                                return Wrap(
                                                  spacing: 5,
                                                  children: [
                                                    for (
                                                      int i = 0;
                                                      i < movieGenres.length;
                                                      i++
                                                    ) ...[
                                                      Text(
                                                        movieGenres[i],
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                              color:
                                                                  Theme.of(
                                                                        context,
                                                                      )
                                                                      .colorScheme
                                                                      .secondary,
                                                            ),
                                                      ),
                                                      if (i <
                                                          movieGenres.length -
                                                              1)
                                                        Text(
                                                          ' | ',
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .bodyMedium
                                                              ?.copyWith(
                                                                color: Theme.of(
                                                                  context,
                                                                ).colorScheme.secondary,
                                                              ),
                                                        ),
                                                    ],
                                                  ],
                                                );
                                              },
                                              error: (e, _) =>
                                                  Text('Error: $e'),
                                              loading: () =>
                                                  const SizedBox.shrink(),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 1.h),
                                        Text(
                                          data[0].results[index].overview
                                              .toString(),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.secondary,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        controller.previousPage(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeIn,
                                        );
                                      },
                                      icon: Icon(
                                        Icons.arrow_back_ios,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.secondary,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        controller.nextPage(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeIn,
                                        );
                                      },
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.secondary,
                                      ),
                                    ),
                                  ],
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
                  height: 40.sh,
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
                      height: 40.sh,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
