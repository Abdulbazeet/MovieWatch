// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:movie_watch/config/tmdb_config.dart';
import 'package:movie_watch/data/now_playing_notifier.dart';
import 'package:movie_watch/data/tmdb_providers.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import 'package:movie_watch/config/movie_type.dart';

class ShowAll extends ConsumerStatefulWidget {
  final String title;
  final MovieType movieType;
  ShowAll({required this.title, required this.movieType});

  @override
  ConsumerState<ShowAll> createState() => _ShowAllState();
}

class _ShowAllState extends ConsumerState<ShowAll> {
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
      if(_scrollController.position.pixels >= _scrollController.position.maxScrollExtent -200){
        ref.read(nowPlayingNotifierProvider(selectedGenre).notifier).loadMore(selectedGenre);
      }
    },);
  }

  @override
  Widget build(BuildContext context) {
    final genre = switch (widget.movieType) {
      MovieType.movie => ref.watch(movieGenreProvider),
      MovieType.tvshow => ref.watch(seriesGenreProvider),
      MovieType.anime => ref.watch(seriesGenreProvider),
      MovieType.kdrama => ref.watch(seriesGenreProvider),
    };
    final movie = ref.watch(nowPlayingNotifierProvider(selectedGenre));
    showGenre(BuildContext ocntext) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(5.sw),
          ).copyWith(),
        ),

        builder: (context) => StatefulBuilder(
          builder: (context, genreState) => SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.sw, vertical: 3.sh),
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

                  SizedBox(height: 2.sh),

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
                            margin: EdgeInsets.symmetric(vertical: 1.sh),
                            padding: EdgeInsets.symmetric(
                              vertical: 3.sw,
                              horizontal: 2.sh,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(2.sw),
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
                            Radius.circular(2.sw),
                          ),
                        ),
                      ),
                      onPressed: () {
                        ref
                            .read(
                              nowPlayingNotifierProvider(
                                selectedGenre,
                              ).notifier,
                            )
                            .refreshUI(selectedGenre);

                        genreState(() {});

                        setState(() {
                          String? joinedId = chosenGenreId.isEmpty
                              ? null
                              : chosenGenreId.join(',');
                          selectedGenre = joinedId;
                        });
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
          padding: EdgeInsets.symmetric(horizontal: 5.sw),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (chosenGenre.isEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.sw,
                        vertical: 1.sh,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(2.sw),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'All',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.white),
                          ),
                          SizedBox(width: 2.sw),
                          GestureDetector(
                            onTap: () {
                              showGenre(context);
                            },
                            child: Icon(
                              Icons.close,
                              size: 17.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (chosenGenre.isEmpty) SizedBox(width: 1.5.sw),
                  if (chosenGenre.isNotEmpty)
                    Expanded(
                      child: SizedBox(
                        height: 4.sh,

                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: chosenGenre.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final text = chosenGenre[index];
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.sw,
                                vertical: 1.sh,
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 1.5.sw),

                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(2.sw),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    text,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: Colors.white),
                                  ),
                                  SizedBox(width: 2.sw),
                                  GestureDetector(
                                    onTap: () {
                                      ref
                                          .read(
                                            nowPlayingNotifierProvider(
                                              selectedGenre,
                                            ).notifier,
                                          )
                                          .refreshUI(selectedGenre);
                                      setState(() {
                                        chosenGenre.remove(text);
                                      });
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size: 17.sp,
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
                  SizedBox(width: 2.sw),
                ],
              ),
              SizedBox(height: 2.sh),
              Expanded(
                child: movie.when(
                  data: (data) {
                    return GridView.builder(
                      controller: _scrollController,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 35.w, // max width per tile
                        mainAxisSpacing: 2.sh,
                        crossAxisSpacing: 2.sw,
                        childAspectRatio: .5,
                      ),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final movie = data[index];
                        var showDate = DateTime.parse(movie.releaseDate!);
                        final formatedDate = DateFormat(
                          'MMM d, yyyy',
                        ).format(showDate);
                        return Container(
                          width: 35.sw,
                          margin: EdgeInsets.only(right: 3.sw),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CachedNetworkImage(
                                imageUrl:
                                    '${TmdbConfig.img_url}w500${movie.posterPath}',
                                imageBuilder: (context, imageProvider) =>
                                    Container(
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
                                        width: 35.sw,
                                        height: 24.sh,
                                        decoration: BoxDecoration(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.surfaceVariant,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                  loading: () => Center(
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
