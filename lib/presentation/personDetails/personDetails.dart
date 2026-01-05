import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:movie_watch/config/enums.dart';
import 'package:movie_watch/config/tmdb_config.dart';
import 'package:movie_watch/data/notifiers/person_details-notifier.dart';
import 'package:movie_watch/models/person/person-credits.dart';
import 'package:shimmer/shimmer.dart';

class PersonDetails extends ConsumerStatefulWidget {
  final int personId;
  final String name;
  const PersonDetails({super.key, required this.personId, required this.name});

  @override
  ConsumerState<PersonDetails> createState() => _PersonDetailsState();
}

class _PersonDetailsState extends ConsumerState<PersonDetails> {
  @override
  Widget build(BuildContext context) {
    final screensize = MediaQuery.of(context).size.height;
    final personDetails = ref.watch(
      personDetailsNotifierProvider(widget.personId),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0).copyWith(top: 0),
        child: personDetails.when(
          data: (data) {
            // final List<PersonCredits> orderedKnownForList =
            // // List<PersonCredits>.from(data.personCredits)..sort(
            //   (a, b) => (b.popularity ?? 0).compareTo(a.popularity ?? 0),
            // );

            // movieCreditsOnly.sort(
            //   (a, b) => (b.vote_average ?? 0).compareTo(a.vote_average ?? 0),
            // ); // Sort descending

            final List<PersonCredits> movieCreditsOnly = data.personCredits
                .where(
                  (credit) => credit.media_type == 'movie',
                ) // Filter only movies
                .toList();

            movieCreditsOnly.sort(
              (a, b) => (b.popularity ?? 0).compareTo(a.popularity ?? 0),
            ); // Sort descending

            final List<PersonCredits> orderedMovieList =
                movieCreditsOnly.length > 7
                ? movieCreditsOnly.sublist(0, 7)
                : movieCreditsOnly;
            //   final d = data.personCredits.where((element) { return element.release_date!;}).toList();
            //  final date = DateFormat('yyyy').format(DateTime.parse(data.personCredits))
            // final sortByDate = data.personCredits;
            // sortByDate.sort(
            //   (a, b) {

            //     return b.release_date!.compareTo(a.release_date!);
            //   },
            // );

            List<PersonCredits> noDateList = [];
            List<PersonCredits> datedList = [];
            for (var credits in data.personCredits) {
              if (credits.release_date == null ||
                  credits.release_date!.isEmpty) {
                noDateList.add(credits);
              } else if (credits.release_date != null ||
                  credits.release_date!.isNotEmpty) {
                datedList.add(credits);
              }
            }
            datedList.sort(
              (a, b) => b.release_date!.compareTo(a.release_date!),
            );

            return ListView(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl:
                                '${TmdbConfig.img_url}original${data.personDetails.profile_path}',
                            imageBuilder: (context, imageProvider) => Container(
                              height: screensize * .22,
                              width: MediaQuery.of(context).size.width * .3,

                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: .5),
                              highlightColor: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: .3),
                              child: Container(
                                width: MediaQuery.of(context).size.width * .3,
                                height: screensize * .22,
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surfaceVariant,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Container(height: screensize * .22),
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Known For',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),

                          if (data.personDetails.known_for_department != null &&
                              data
                                  .personDetails
                                  .known_for_department!
                                  .isNotEmpty) ...[
                            SizedBox(width: 10),
                            Text(
                              data.personDetails.known_for_department!,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                          if (data.personDetails.birthday != null &&
                              data.personDetails.birthday!.isNotEmpty) ...[
                            SizedBox(height: 15),
                            Text(
                              'Date of Birth',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 10),
                            Text(
                              DateFormat('MMMM d, yyy').format(
                                DateTime.parse(data.personDetails.birthday!),
                              ),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                          if (data.personDetails.deathday != null &&
                              data.personDetails.deathday!.isNotEmpty) ...[
                            SizedBox(height: 15),
                            Text(
                              'Date of Death',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 10),
                            Text(
                              DateFormat('MMMM d, yyy').format(
                                DateTime.parse(data.personDetails.deathday!),
                              ),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.personDetails.biography!,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Divider(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSecondary.withValues(alpha: .4),
                ),
                SizedBox(height: 20),
                Text(
                  'Best know for',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 210,
                  child: ListView.builder(
                    itemCount: orderedMovieList.length,
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final items = orderedMovieList[index];

                      return Container(
                        // height: 250,
                        width: 100,
                        margin: EdgeInsets.only(right: 10),
                        child: Column(
                          children: [
                            CachedNetworkImage(
                              imageUrl: items.poster_path != null
                                  ? "${TmdbConfig.img_url}original${items.poster_path}"
                                  : "${TmdbConfig.img_url}original${items.backdrop_path}",
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                    height: 150,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: imageProvider,
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
                                  width: 100,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surfaceVariant,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                height: 150,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              items.title!,
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 3,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  data.personDetails.known_for_department!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 10),
                ListView.builder(
                  itemCount: datedList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var items = datedList[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (items.media_type == 'movie') {
                              context.push(
                                '/details',
                                extra: {
                                  'tableType': TableType.movies,
                                  'id': items.id,
                                },
                              );
                            } else if (items.media_type == 'tv') {
                              context.push('/tvshows-details', extra: items.id);
                            }
                          },
                          child: Row(
                            children: [
                              Center(
                                child: Text(
                                  DateFormat(
                                    'yyyy',
                                  ).format(DateTime.parse(items.release_date!)),
                                ),
                              ),
                              SizedBox(width: 10),
                              CachedNetworkImage(
                                imageUrl:                                     items.poster_path != null &&
                                        items.poster_path!.isNotEmpty 

                                    ? "${TmdbConfig.img_url}original${items.poster_path}"
                                    : "${TmdbConfig.img_url}original${items.backdrop_path}",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      height: 120,
                                      width: 80,

                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
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
                                        width: 80,
                                        height: 120,
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
                                errorWidget: (context, url, error) => Container(
                                  height: 120,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey,
                                  ),
                                ),
                              ),

                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      items.title!,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                      maxLines: 2,
                                    ),
                                    Text(
                                      "as ${items.character}",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                    Text(
                                      items.media_type.toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary
                                                .withValues(alpha: .4),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Divider(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSecondary.withValues(alpha: .4),
                        ),
                      ],
                    );
                  },
                ),

                ///
                ///
                ///
                ///
                SizedBox(height: 20),
                Text('Others', style: Theme.of(context).textTheme.bodyMedium),
                SizedBox(height: 10),
                ListView.builder(
                  itemCount: noDateList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var items = noDateList[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (items.media_type == 'movie') {
                              context.push(
                                '/details',
                                extra: {
                                  'tableType': TableType.movies,
                                  'id': items.id,
                                },
                              );
                            } else if (items.media_type == 'tv') {
                              context.push('/tvshows-details', extra: items.id);
                            }
                          },
                          child: Row(
                            children: [
                              Center(child: Text('')),
                              SizedBox(width: 10),
                              CachedNetworkImage(
                                imageUrl:
                                    items.poster_path != null && items.poster_path!.isNotEmpty 
                                    ? "${TmdbConfig.img_url}original${items.poster_path}"
                                    : "${TmdbConfig.img_url}original${items.backdrop_path}",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      height: 120,
                                      width: 80,

                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
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
                                        width: 80,
                                        height: 120,
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
                                errorWidget: (context, url, error) => Container(
                                  height: 120,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey,
                                  ),
                                ),
                              ),

                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      items.title!,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                      maxLines: 2,
                                    ),
                                    Text(
                                      "as ${items.character ?? ''}",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                    Text(
                                      items.media_type.toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary
                                                .withValues(alpha: .4),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Divider(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSecondary.withValues(alpha: .4),
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          },
          loading: () => Center(child: CircularProgressIndicator.adaptive()),
          error: (error, stackTrace) => Center(
            child: Text(
              "$error - $stackTrace",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ),
    );
  }
}
