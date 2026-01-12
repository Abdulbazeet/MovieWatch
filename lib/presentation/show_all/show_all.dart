// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:movie_watch/config/tmdb_config.dart';
import 'package:movie_watch/data/movie_list_notifiers.dart';
import 'package:movie_watch/data/tmdb_providers.dart';
import 'package:shimmer/shimmer.dart';

import 'package:movie_watch/config/enums.dart';

class ShowAll extends ConsumerStatefulWidget {
  final String title;
  final MovieType movieType;
  final TableType tableType;
  ShowAll({
    required this.title,
    required this.movieType,
    required this.tableType,
  });

  @override
  ConsumerState<ShowAll> createState() => _ShowAllState();
}

class _ShowAllState extends ConsumerState<ShowAll> {
  bool _initialFetchDone = false;

  List<String> chosenGenre = [];
  List<String> chosenGenreId = [];
  String? selectedGenre;
  // String? get genreId => chosenGenreId.isEmpty ? null : chosenGenreId.join(',');
  bool chosen = false;
  final _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        ref
            .read(
              movieListNotifier((
                selectedGenre,
                widget.movieType,
                widget.tableType,
              )).notifier,
            )
            .loadMore(selectedGenre, widget.movieType, widget.tableType);
      }
    });
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   // if (!_initialFetchDone) {
    //   //   _initialFetchDone = true;
    //   // }else{

    //   // }
    //   ref
    //       .read(
    //         movieListNotifier((
    //           selectedGenre,
    //           widget.movieType,
    //           widget.tableType,
    //         )).notifier,
    //       )
    //       .refreshUI(selectedGenre, widget.movieType, widget.tableType);
    // });
  }

  @override
  Widget build(BuildContext context) {
    final genre = switch (widget.tableType) {
      TableType.movies => ref.watch(movieGenreProvider),
      TableType.tvshows => ref.watch(seriesGenreProvider),
      TableType.anime => ref.watch(seriesGenreProvider),
      TableType.kdramas => ref.watch(seriesGenreProvider),
    };
    final movie = ref.watch(
      movieListNotifier((selectedGenre, widget.movieType, widget.tableType)),
    );
    // .refreshUI(selectedGenre, widget.movieType, widget.tableType);
    showGenre(BuildContext ocntext) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(5),
          ).copyWith(),
        ),

        builder: (context) => StatefulBuilder(
          builder: (context, genreState) => SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Center(
                    child: Text(
                      'Choose Genres',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),

                  SizedBox(height: 20),

                  Expanded(
                    child: ListView.builder(
                      itemCount: genre.value!.length,

                      itemBuilder: (context, index) {
                        var genreName = genre.value![index].name;
                        var genreIds = genre.value![index].id;
                        bool isSelected = chosenGenre.contains(genreName);

                        return GestureDetector(
                          onTap: () {
                            genreState(() {
                              if (chosenGenre.contains(genreName)) {
                                chosenGenre.remove(genreName);
                                chosenGenreId.remove(genreIds.toString());
                              } else {
                                chosenGenre.add(genreName);
                                chosenGenreId.add(genreIds.toString());
                              }
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              // color: Theme.of(context).colorScheme.secondary,
                              //borderRadius: BorderRadius.circular(2 ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    genreName,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () {
                        //  genreState(() {});
                        String? joinedId = chosenGenreId.isEmpty
                            ? null
                            : chosenGenreId.join(',');

                        setState(() {
                          selectedGenre = joinedId;
                        });
                        ref.invalidate(
                          movieListNotifier((
                            selectedGenre,
                            widget.movieType,
                            widget.tableType,
                          )),
                        );

                        ref
                            .read(
                              movieListNotifier((
                                selectedGenre,
                                widget.movieType,
                                widget.tableType,
                              )).notifier,
                            )
                            .refreshUI(
                              selectedGenre,
                              widget.movieType,
                              widget.tableType,
                            );
                        print(selectedGenre);
                        context.pop();
                        // print(genreId);
                      },
                      child: Text(
                        'Apply Filters',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: context.pop,
        ),
        actions: [
          IconButton(
            onPressed: () => showGenre(context),
            icon: Icon(
              Icons.filter_alt,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (chosenGenre.isEmpty)
                    Container(
                      height: 40,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'All',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.white),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              showGenre(context);
                            },
                            child: Icon(
                              Icons.close,
                              size: 17,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (chosenGenre.isEmpty) SizedBox(width: 10),
                  if (chosenGenre.isNotEmpty)
                    Expanded(
                      child: SizedBox(
                        height: 40,

                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: chosenGenre.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final text = chosenGenre[index];
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 10),

                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    text,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: Colors.white),
                                  ),
                                  SizedBox(width: 2),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        final genreName = chosenGenre[index];
                                        final genreIndex = chosenGenre.indexOf(
                                          genreName,
                                        );
                                        chosenGenre.removeAt(genreIndex);
                                        chosenGenreId.removeAt(genreIndex);
                                        selectedGenre = chosenGenreId.isEmpty
                                            ? null
                                            : chosenGenreId.join(',');
                                      });
                                      ref.invalidate(
                                        movieListNotifier((
                                          selectedGenre,
                                          widget.movieType,
                                          widget.tableType,
                                        )),
                                      );

                                      ref
                                          .read(
                                            movieListNotifier((
                                              selectedGenre,
                                              widget.movieType,
                                              widget.tableType,
                                            )).notifier,
                                          )
                                          .refreshUI(
                                            selectedGenre,
                                            widget.movieType,
                                            widget.tableType,
                                          );

                                      print(selectedGenre);
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size: 17,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  SizedBox(width: 10),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: movie.when(
                  data: (data) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        return GridView.builder(
                          controller: _scrollController,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 100, // max width per tile
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 20,
                                childAspectRatio: .36,
                              ),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final movie = data[index];
                            var showDate = DateTime.parse(movie.releaseDate!);
                            final formatedDate = DateFormat(
                              'MMM d, yyyy',
                            ).format(showDate);
                            return GestureDetector(
                              onTap: () {
                                context.push(
                                  '/details',
                                  extra: {
                                    'id': data[index].id,
                                    'tableType': widget.tableType,
                                  },
                                );
                              },
                              child: Container(
                                //    margin: EdgeInsets.only(right: 10 ),
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
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                      errorWidget: (context, _, __) =>
                                          Container(
                                            width: 100,
                                            height: 150,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Container(
                                              width: 100,
                                              height: 150,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: const Icon(
                                                Icons.broken_image,
                                              ),
                                            ),
                                          ),
                                    ),
                                    SizedBox(height: 10),
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
                                    SizedBox(height: 5),
                                    Text(
                                      formatedDate,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                      maxLines: 1,
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  error: (error, stackTrace) {
                    return Center(
                      child: Text(
                        '$error - $stackTrace',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );
                  },
                  loading: () =>
                      Center(child: const CircularProgressIndicator.adaptive()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
