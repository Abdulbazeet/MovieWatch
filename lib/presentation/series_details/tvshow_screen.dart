import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:movie_watch/config/tmdb_config.dart';
import 'package:movie_watch/config/utils.dart';
import 'package:movie_watch/data/notifiers/tvseries-details_notifier.dart';
import 'package:movie_watch/data/tmdb_providers.dart';
import 'package:movie_watch/models/movies.dart';
import 'package:movie_watch/models/show_details.dart';
import 'package:movie_watch/models/tvseries_credit.dart';

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

    _showEpisodeDetails(BuildContext newContext) {
      // final showdetails = ref.watch(
      //   episodeDetailsProvider((
      //     episodeNumber: 1,
      //     seasonNumber: 1,
      //     seriesId: 1,
      //   )),
      // );
      showBottomSheet(
        context: newContext,
        builder: (context) => StatefulBuilder(
          builder: (context, bottomState) {
            return BottomSheet(
              onClosing: () {
                
              },
              builder: (context) {
            
              return Container();
            },);
          },
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: details.when(
          data: (data) {
            // final date = DateFormat(
            //   'yyyy',
            // ).format(DateTime.parse(data.tvshwDetails.lastAirDate));

            final firstAir = DateFormat(
              'yyyy',
            ).format(DateTime.parse(data.tvshwDetails.firstAirDate));
            // final dateCheck = data.tvshwDetails.nextEpisodeToAir;
            final lastAir = DateFormat(
              'yyyy',
            ).format(DateTime.parse(data.tvshwDetails.lastAirDate));
            final duration = Utils.timeDuration(
              data.tvshwDetails.lastEpisodeToAir!.runtime,
            );

            final directors = data.tvseriesCredit
                .where((element) => element.knownForDepartment == 'Directing')
                .map((e) => e.name)
                .join(',');
            final writers = data.tvseriesCredit
                .where((element) => element.knownForDepartment == 'Writing')
                .map((e) => e.name)
                .join(',');
            final lastEpisode = data.tvshwDetails.lastEpisodeToAir!;
            final List<TvSeriesCredits> casts = data.tvseriesCredit
                .where((element) => element.knownForDepartment == 'Acting')
                .toList();
            final List<Season> seasons = data.tvshwDetails.seasons
                // .where((element) => element.knownForDepartment == 'Acting')
                .toList();

            final episodeDate = DateFormat(
              'EEE MMM d, yyyy',
            ).format(DateTime.parse(lastEpisode.airDate));
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
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),

                            Row(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '$firstAir - ${data.tvshwDetails.status == 'Ended' ? lastAir : 'present'}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(color: Colors.white),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: Text(
                                            "•",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize:
                                                  8, // makes it a small bullet
                                              height:
                                                  1, // removes extra line-height
                                              fontWeight: FontWeight
                                                  .w900, // makes the dot perfectly round
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                              size: 16,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              data.tvshwDetails.voteAverage
                                                  .toStringAsFixed(1),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: Text(
                                            "•",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize:
                                                  8, // makes it a small bullet
                                              height:
                                                  1, // removes extra line-height
                                              fontWeight: FontWeight
                                                  .w900, // makes the dot perfectly round
                                            ),
                                          ),
                                        ),
                                        Text(
                                          duration,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 3),
                                    Row(
                                      children: [
                                        Text(
                                          "${data.tvshwDetails.numberOfSeasons} seasons",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(width: 30),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      foregroundColor: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      'Watch Trailer',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Align(
                                child: Container(
                                  height: 150,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        '${TmdbConfig.img_url}w300${data.tvshwDetails.posterPath}',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,

                                left: 0,

                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: .7),
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Icon(Icons.add, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 30,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: data.tvshwDetails.genres.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(right: 8),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primaryContainer,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Text(
                                          data.tvshwDetails.genres[index].name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.secondary,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                if (data.tvshwDetails.tagline.isNotEmpty) ...[
                                  SizedBox(height: 5),
                                  Text(
                                    data.tvshwDetails.tagline,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(fontStyle: FontStyle.italic),
                                  ),
                                ],

                                SizedBox(height: 5),
                                Wrap(
                                  children: [
                                    Text(
                                      data.tvshwDetails.overview,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      if (directors.isNotEmpty) ...[
                        SizedBox(height: 30),

                        Divider(color: Theme.of(context).colorScheme.onSurface),
                        SizedBox(height: 10),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Directors',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            SizedBox(height: 5),
                            Text(
                              directors,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                          ],
                        ),
                      ],
                      if (writers.isNotEmpty) ...[
                        SizedBox(height: 10),

                        Divider(color: Theme.of(context).colorScheme.onSurface),
                        SizedBox(height: 10),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Writers',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            SizedBox(height: 5),
                            Text(
                              writers,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),

                        Divider(color: Theme.of(context).colorScheme.onSurface),
                      ],
                      SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Top Cast',
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
                        height: 260,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: casts.length,
                          physics: const BouncingScrollPhysics(),

                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,

                          itemBuilder: (context, index) {
                            return Container(
                              width: 130,
                              padding: EdgeInsets.symmetric(
                                vertical: 0,
                                //  horizontal: 10,
                              ).copyWith(top: 0),
                              margin: EdgeInsets.only(right: 20),
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

                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    child: Container(
                                      width: 130, // = radius * 2
                                      height: 150,
                                      color: Colors.grey,
                                      child: Image.network(
                                        casts[index].profilePath!.isNotEmpty
                                            ? '${TmdbConfig.img_url}original${casts[index].profilePath}'
                                            : casts[index].gender == 1
                                            ? 'assets/images/female.jpeg'
                                            : casts[index].gender == 2
                                            ? 'assets/images/male.png'
                                            : 'assets/images/unknown.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                  Text(
                                    casts[index].originalName,
                                    textAlign: TextAlign.center,
                                    maxLines: 4,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    casts[index].roles[0].character,
                                    textAlign: TextAlign.center,
                                    maxLines: 4,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                  Text(
                                    "${casts[index].roles[0].episodeCount} episodes",
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
                      SizedBox(height: 30),
                      Text(
                        'Last aired',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 160,
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            onTap: () => _showEpisodeDetails(context),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                  child: Container(
                                    width: 120,
                                    height: 200,
                                    decoration: BoxDecoration(),
                                    child: Image.network(
                                      "${TmdbConfig.img_url}original${data.tvshwDetails.lastEpisodeToAir!.stillPath}",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Season ${lastEpisode.seasonNumber} Episode ${lastEpisode.episodeNumber}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        Text(
                                          lastEpisode.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        Text(
                                          episodeDate,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                        ),
                                        Text(
                                          lastEpisode.overview,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
                                        ),
                                        SizedBox(height: 3),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                              size: 17,
                                            ),

                                            Text(
                                              lastEpisode.voteAverage
                                                  .toStringAsFixed(1),
                                              style: Theme.of(
                                                context,
                                              ).textTheme.labelSmall,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        'All Seasons',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 10),

                      SizedBox(
                        height: 160,
                        // width: 300,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: seasons.length,
                          clipBehavior: Clip.none,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            var items = seasons[index];
                            final seasonsYear = DateFormat(
                              'yyyy',
                            ).format(DateTime.parse(items.airDate));
                            return Container(
                              height: 160,
                              width: 350,
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
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
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                    child: Container(
                                      height: 160,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                      ),
                                      child: Image.network(
                                        "${TmdbConfig.img_url}original${items.posterPath}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            seasons[index].name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 4,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.yellow,
                                                      size: 17,
                                                    ),
                                                    Text(
                                                      items.voteAverage
                                                          .toStringAsFixed(1),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelSmall
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                seasonsYear,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "${items.episodeCount} episodes",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            items.overview,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 5,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
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
