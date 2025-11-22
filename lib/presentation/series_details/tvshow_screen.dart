import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:movie_watch/config/enums.dart';
import 'package:movie_watch/config/tmdb_config.dart';
import 'package:movie_watch/data/notifiers/tvseries-details_notifier.dart';
import 'package:movie_watch/data/tmdb_providers.dart';
import 'package:movie_watch/models/movies.dart';

class TvshowScreen extends ConsumerStatefulWidget {
  final Movie? currentMovie;

  const TvshowScreen({super.key, required this.currentMovie});

  @override
  ConsumerState<TvshowScreen> createState() => _TvshowScreenState();
}

class _TvshowScreenState extends ConsumerState<TvshowScreen> {
  bool isExpanded = false;
  TextOverflow? _overflow = TextOverflow.ellipsis;
  int? maxline = 3;
  String more = 'See more';
  @override
  Widget build(BuildContext context) {
    final details = ref.watch(
      tvseriesDetailsNotifierProvider(widget.currentMovie!.id),
    );
    // final t = ref.watch(test(widget.currentMovie!.id));
    //  print(t.value![0].name);
    final screensize = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: details.when(
          data: (data) {
            final date = DateFormat(
              'yyyy',
            ).format(DateTime.parse(data.tvshwDetails.lastAirDate));

            final lastDate = DateFormat(
              'yyyy',
            ).format(DateTime.parse(data.tvshwDetails.nextEpisodeToAir!));
            return ListView(
              children: [
                SizedBox(
                  height: screensize * .35,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          color: Colors.grey,
                          child: Image.network(
                            '${TmdbConfig.img_url}original${data.tvshwDetails.backdropPath}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withValues(alpha: .9),
                                  Colors.black.withValues(alpha: .5),
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: .5),
                                  Colors.black.withValues(alpha: .9),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        top: 10,
                        left: 0,

                        child: IconButton(
                          onPressed: () {
                            context.pop();
                          },
                          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 20,
                        left: 20,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.tvshwDetails.name,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.calendar_month, color: Colors.white),
                                SizedBox(width: 10),
                                Text(
                                  "(${date} - ${lastDate != 'null' ? lastDate : 'present'})",
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              data.tvshwDetails.name,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            icon: (Icon(Icons.favorite_rounded, size: 20)),
                          ),
                          IconButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            icon: (Icon(Icons.bookmark, size: 20)),
                          ),
                        ],
                      ),
                      if (data.tvshwDetails.tagline.isNotEmpty)
                        SizedBox(height: 5),
                      Text(
                        data.tvshwDetails.tagline,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        data.tvshwDetails.genres
                            .map((e) => e.name)
                            .join("  .  "),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),

                      Wrap(
                        children: [
                          Text(
                            data.tvshwDetails.overview,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: maxline,
                            overflow: _overflow,
                          ),

                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (maxline == 3) {
                                  maxline = null;
                                  more = 'See less';
                                  _overflow = null;
                                } else {
                                  maxline = 3;
                                  more = 'See more';
                                  _overflow = TextOverflow.ellipsis;
                                }
                              });
                            },
                            child: Text(
                              more,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cast',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            'See all',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 160,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.tvseriesCredit.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            if (data.tvseriesCredit[index].knownForDepartment !=
                                'Acting') {
                              return SizedBox.shrink();
                            } return Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                // color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),

                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.grey,

                                    backgroundImage:
                                        data
                                            .tvseriesCredit[index]
                                            .profilePath!
                                            .isNotEmpty
                                        ? NetworkImage(
                                            '${TmdbConfig.img_url}original${data.tvseriesCredit[index].profilePath}',
                                          )
                                        : data.tvseriesCredit[index].gender == 1
                                        ? AssetImage(
                                            'assets/images/female.jpeg',
                                          )
                                        : data.tvseriesCredit[index].gender == 0
                                        ? AssetImage(
                                            'assets/images/unknown.png',
                                          )
                                        : data.tvseriesCredit[index].gender == 2
                                        ? AssetImage('assets/images/male.png')
                                        : null,
                                  ),

                                  Text(
                                    data.tvseriesCredit[index].originalName,
                                    textAlign: TextAlign.center,
                                    maxLines: 4,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    data
                                        .tvseriesCredit[index]
                                        .roles[0]
                                        .character,
                                    textAlign: TextAlign.center,
                                    maxLines: 4,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                  Text(
                                    "${data.tvseriesCredit[index].roles[0].episodeCount} episodes",
                                    textAlign: TextAlign.center,
                                    maxLines: 4,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Previously aired',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 10),

                      // SizedBox(
                      //   height: 170 ,
                      //   child: ListView.builder(
                      //     shrinkWrap: true,
                      //     itemCount: data.tvseriesCredit.length,
                      //     scrollDirection: Axis.horizontal,
                      //     itemBuilder: (context, index) {
                      //       return Container(
                      //         padding: EdgeInsets.symmetric(
                      //           vertical: 10 ,
                      //           horizontal: 10 ,
                      //         ),
                      //         margin: EdgeInsets.only(right: 10 ),
                      //         decoration: BoxDecoration(
                      //           // color: Colors.grey,
                      //           borderRadius: BorderRadius.circular(10 ),
                      //         ),

                      //         child: Column(
                      //           children: [
                      //             CircleAvatar(
                      //               radius: 40 ,
                      //               backgroundColor: Colors.grey,

                      //               backgroundImage:
                      //                   data
                      //                       .tvseriesCredit[index]
                      //                       .profilePath!
                      //                       .isNotEmpty
                      //                   ? NetworkImage(
                      //                       '${TmdbConfig.img_url}original${data.tvseriesCredit[index].profilePath}',
                      //                     )
                      //                   : data.tvseriesCredit[index].gender == 1
                      //                   ? AssetImage(
                      //       tttttttr                'assets/images/female.jpeg',
                      //                     )
                      //                   : data.tvseriesCredit[index].gender == 0
                      //                   ? AssetImage(
                      //                       'assets/images/unknown.png',
                      //                     )
                      //                   : data.tvseriesCredit[index].gender == 2
                      //                   ? AssetIdmage('assets/images/male.png')
                      //                   : null,
                      //             ),

                      //             Text(
                      //               data.tvseriesCredit[index].name,
                      //               textAlign: TextAlign.center,
                      //               maxLines: 4,
                      //               style: Theme.of(context).textTheme.bodySmall
                      //           /        ?.copyWith(fontWeight: FontWeight.bold),
                      //             ),
                      //             // Text(
                      //             //   data
                      //             //       .tvseriesCredit[index]
                      //             //        oles[0]
                      //             //       .character,
                      //             //   textAlign: TextAlign.center,
                      //             //   maxLines: 4,
                      //             //   style: Theme.of(
                      //             //     context,
                      //             //   ).textTheme.bodySmall,
                      //             // ),
                      //             Text(
                      //               data
                      //                   .tvseriesCredit[index]
                      //                   .knownForDepartment,
                      //               style: Theme.of(
                      //                 context,
                      //               ).textTheme.bodySmall,
                      //             ),
                      //           ],
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            );
          },
          error: (error, stackTrace) {
            return Text('Error: $error');
          },
          loading: () {
            return const CircularProgressIndicator.adaptive();
          },
        ),
      ),
    );
  }
}
