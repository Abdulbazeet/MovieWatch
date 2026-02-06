import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:movie_watch/config/tmdb_config.dart';
import 'package:movie_watch/models/movie/movies.dart';
import 'package:shimmer/shimmer.dart';

class SeenWidget extends StatefulWidget {
  final AsyncValue<List<Movie>> seenMovieList;
  final AsyncValue<List<Movie>> seenTvList;

  const SeenWidget({
    super.key,
    required this.seenMovieList,
    required this.seenTvList,
  });

  @override
  State<SeenWidget> createState() => _SeenWidgetState();
}

class _SeenWidgetState extends State<SeenWidget> {
  // final String _pickedString;
    List<String> seenOptions = ['Movies', 'Tv Shows'];
  String _pickedString = 'Movies';

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                seenOptions.length,
                (index) => Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: FilterChip(
                    onSelected: (value) {
                      setState(() {
                        if (value == true) {
                          _pickedString = seenOptions[index];
                        }
                      });
                    },
                    color: _pickedString == seenOptions[index]
                        ? WidgetStatePropertyAll(
                            Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: .2),
                          )
                        : WidgetStatePropertyAll(
                            Colors.grey.withValues(alpha: .2),
                          ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),

                      side: BorderSide(
                        color: _pickedString == seenOptions[index]
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                      ),
                    ),

                    label: Text(
                      seenOptions[index],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          if (_pickedString == 'Movies') ...[
            Expanded(
              child: widget.seenMovieList.when(
                data: (data) {
                  if (data.isEmpty) {
                    return Center(child: Text("No seen movies yet."));
                  }

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final movie = data[index];
                      final date =
                          movie.releaseDate != null &&
                              movie.releaseDate!.isNotEmpty
                          ? DateFormat(
                              "EEE MMM d, yyyy",
                            ).format(DateTime.parse(movie.releaseDate!))
                          : null;

                      return GestureDetector(
                        onTap: () {
                          context.push("/details", extra: {'id': movie.id});
                        },
                        child: Container(
                          width: double.infinity,
                          height: 120,
                          margin: EdgeInsets.only(bottom: 20),
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
                          child: Row(
                            children: [
                              CachedNetworkImage(
                                imageUrl:
                                    "${TmdbConfig.img_url}original/${movie.posterPath}",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      width: 100,
                                      height: 160,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                errorWidget: (context, url, error) => Container(
                                  width: 100,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
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
                                        height: 160,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        movie.title ?? 'No Title',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        movie.overview ?? 'No Description',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
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
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          SizedBox(width: 10),
                                          movie.voteAverage != 0.0
                                              ? Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.yellow,
                                                    ),
                                                    SizedBox(width: 5),
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
                loading: () => Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) =>
                    Center(child: Text("Error loading seen movies.")),
              ),
            ),
          ],
          if (_pickedString == 'Tv Shows') ...[
            Expanded(
              child: widget.seenTvList.when(
                data: (data) {
                  if (data.isEmpty) {
                    return Center(child: Text("No seen Tv shows yet."));
                  }

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final movie = data[index];
                      final date =
                          movie.releaseDate != null &&
                              movie.releaseDate!.isNotEmpty
                          ? DateFormat(
                              "EEE MMM d, yyyy",
                            ).format(DateTime.parse(movie.releaseDate!))
                          : null;

                      return GestureDetector(
                        onTap: () {
                          context.push("/tvshows-details", extra: movie.id);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 120,
                          margin: EdgeInsets.only(bottom: 20),
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
                          child: Row(
                            children: [
                              CachedNetworkImage(
                                imageUrl:
                                    "${TmdbConfig.img_url}original/${movie.posterPath}",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      width: 100,
                                      height: 160,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                errorWidget: (context, url, error) => Container(
                                  width: 100,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
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
                                        height: 160,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        movie.title ?? 'No Title',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        movie.overview ?? 'No Description',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
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
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          SizedBox(width: 10),
                                          movie.voteAverage != 0.0
                                              ? Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.yellow,
                                                    ),
                                                    SizedBox(width: 5),
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
                loading: () => Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) =>
                    Center(child: Text("Error loading seen movies.")),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
