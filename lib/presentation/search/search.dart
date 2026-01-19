// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:movie_watch/config/enums.dart';
import 'package:movie_watch/config/tmdb_config.dart';
import 'package:movie_watch/config/utils.dart';
import 'package:movie_watch/data/notifiers/search_notifier.dart';
import 'package:movie_watch/presentation/search/widget/search_widget.dart';

class Search extends ConsumerStatefulWidget {
  const Search({super.key});

  @override
  ConsumerState<Search> createState() => _SearchState();
}

class _SearchState extends ConsumerState<Search> {
  final _seachController = TextEditingController();

  bool has_searched = false;
  @override
  void dispose() {
    _seachController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _seachController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final searchResult = ref.watch(searchResultsNotifierProvider);
    var persons =
        searchResult.asData?.value
            .where((element) => element.media_type == 'person')
            .toList() ??
        [];
    var movies =
        searchResult.asData?.value
            .where((element) => element.media_type == 'movie')
            .toList() ??
        [];
    var tvshows =
        searchResult.asData?.value
            .where((element) => element.media_type == 'tv')
            .toList() ??
        [];
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _seachController,
                              decoration: InputDecoration(
                                hintText:
                                    'Search for a movie, tv show, person....',
                                border: InputBorder.none,
                                hintStyle: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                      fontStyle: FontStyle.italic,
                                    ),
                              ),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                              onSubmitted: (value) {
                                if (value.isNotEmpty) {
                                  setState(() {
                                    has_searched = true;
                                  });
                                  ref
                                      .read(
                                        searchResultsNotifierProvider.notifier,
                                      )
                                      .searchQuery(value);
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          _seachController.text.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    _seachController.clear();
                                  },
                                  child: Icon(
                                    Icons.clear,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                )
                              : GestureDetector(
                                  child: Icon(
                                    Icons.mic,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              !has_searched
                  ? SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'No search results yet.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    )
                  : searchResult.when(
                      data: (data) {
                        if (data.isNotEmpty) {
                          return SliverToBoxAdapter(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (tvshows.isNotEmpty)
                                  SearchWidget(
                                    media_type: 'Tv Show',
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),

                                      // separatorBuilder: (context, index) =>
                                      itemCount: tvshows.length,
                                      itemBuilder: (context, index) {
                                        final date = DateFormat('yyyy').format(
                                          DateTime.parse(
                                            tvshows[index].first_air_date!,
                                          ),
                                        );

                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              context.push(
                                                '/tvshows-details',
                                                extra: tvshows[index].id,
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                  10,
                                                                ),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                  10,
                                                                ),
                                                            bottomRight:
                                                                Radius.circular(
                                                                  10,
                                                                ),
                                                          ),
                                                      child: Container(
                                                        height: 100,
                                                        width: 70,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child:
                                                            tvshows[index]
                                                                    .poster_path !=
                                                                null
                                                            ? Image.network(
                                                                '${TmdbConfig.img_url}original${tvshows[index].poster_path}',

                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : Image.network(
                                                                '${TmdbConfig.img_url}original${tvshows[index].backdrop_path}',

                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            tvshows[index]
                                                                .name!,
                                                            style:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .textTheme
                                                                    .bodyMedium,
                                                          ),
                                                          SizedBox(height: 3),
                                                          Text(
                                                            date,
                                                            style:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .textTheme
                                                                    .bodySmall,
                                                          ),
                                                          SizedBox(height: 3),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .yellow,
                                                                size: 16,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                tvshows[index]
                                                                    .vote_average!
                                                                    .toStringAsFixed(
                                                                      1,
                                                                    ),
                                                                style: Theme.of(
                                                                  context,
                                                                ).textTheme.bodySmall,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 5),
                                                Divider(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withValues(alpha: .4),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                if (movies.isNotEmpty)
                                  SearchWidget(
                                    media_type: 'Movie',
                                    child: ListView.builder(
                                      shrinkWrap: true,

                                      itemCount: movies.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        final date =
                                            (movies[index].first_air_date !=
                                                    null &&
                                                movies[index].first_air_date !=
                                                    '')
                                            ? DateFormat('yyyy').format(
                                                DateTime.parse(
                                                  movies[index].first_air_date!,
                                                ),
                                              )
                                            : null;

                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              context.push(
                                                '/details',
                                                extra: {
                                                  'id': movies[index].id,
                                                  'tableType': TableType.movies,
                                                },
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                  10,
                                                                ),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                  10,
                                                                ),
                                                            bottomRight:
                                                                Radius.circular(
                                                                  10,
                                                                ),
                                                          ),
                                                      child: Container(
                                                        height: 100,
                                                        width: 70,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child:
                                                            movies[index]
                                                                    .poster_path !=
                                                                null
                                                            ? Image.network(
                                                                '${TmdbConfig.img_url}original${movies[index].poster_path}',

                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : Image.network(
                                                                '${TmdbConfig.img_url}original${movies[index].backdrop_path}',

                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            movies[index].name!,
                                                            style:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .textTheme
                                                                    .bodyMedium,
                                                          ),

                                                          if (date != null ||
                                                              date != '') ...[
                                                            SizedBox(height: 3),
                                                            Text(
                                                              date ?? 'TBA',
                                                              style:
                                                                  Theme.of(
                                                                        context,
                                                                      )
                                                                      .textTheme
                                                                      .bodySmall,
                                                            ),
                                                          ],
                                                          SizedBox(height: 3),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .yellow,
                                                                size: 16,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                movies[index]
                                                                    .vote_average!
                                                                    .toStringAsFixed(
                                                                      1,
                                                                    ),
                                                                style: Theme.of(
                                                                  context,
                                                                ).textTheme.bodySmall,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 5),
                                                Divider(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withValues(alpha: .4),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                if (persons.isNotEmpty)
                                  SearchWidget(
                                    media_type: 'Person',
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),

                                      itemCount: persons.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  context.push(
                                                    '/person-details',
                                                    extra: {
                                                      'id': persons[index].id,
                                                      'name':
                                                          persons[index].name,
                                                    },
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius:
                                                          35, // → 80px diameter, change to 50 for 100px, etc.
                                                      backgroundImage:
                                                          persons[index]
                                                                  .profile_path !=
                                                              null
                                                          ? NetworkImage(
                                                              '${TmdbConfig.img_url}original${persons[index].profile_path}',
                                                            )
                                                          : const AssetImage(
                                                                  'assets/images/unknown.png',
                                                                )
                                                                as ImageProvider,
                                                      backgroundColor: Colors
                                                          .grey
                                                          .shade300, // optional fallback
                                                    ),
                                                    SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            persons[index]
                                                                .name!,
                                                            style:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .textTheme
                                                                    .bodyMedium,
                                                          ),
                                                          SizedBox(height: 3),
                                                          if (persons[index]
                                                                  .known_for_department !=
                                                              null)
                                                            Text(
                                                              persons[index]
                                                                  .known_for_department!,
                                                              style:
                                                                  Theme.of(
                                                                        context,
                                                                      )
                                                                      .textTheme
                                                                      .bodySmall,
                                                            ),
                                                          SizedBox(height: 3),
                                                          if (persons[index]
                                                                  .known_for !=
                                                              null)
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: GestureDetector(
                                                                child: Text(
                                                                  persons[index]
                                                                      .known_for!
                                                                      .map(
                                                                        (e) =>
                                                                            e.title ??
                                                                            e.title,
                                                                      )
                                                                      .join(
                                                                        ', ',
                                                                      ),
                                                                  style: Theme.of(context)
                                                                      .textTheme
                                                                      .bodySmall
                                                                      ?.copyWith(
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Divider(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withValues(alpha: .4),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                SizedBox(height: 100),
                              ],
                            ),
                          );
                        } else {
                          return SliverFillRemaining(
                            child: Center(
                              child: Text(
                                'No results found.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          );
                        }
                      },
                      error: (error, stackTrace) => SliverFillRemaining(
                        child: Center(child: Text('An error occurred: $error')),
                      ),
                      loading: () => SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator.adaptive(),
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
