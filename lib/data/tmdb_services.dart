// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_watch/config/tmdb_config.dart';
import 'package:movie_watch/models/credits.dart';
import 'package:movie_watch/models/episodes.dart';
import 'package:movie_watch/models/genre.dart';
import 'package:movie_watch/models/movie_details.dart';
import 'package:movie_watch/models/movies.dart';
import 'package:movie_watch/models/recommendations.dart';
import 'package:movie_watch/models/series_trailer.dart';
import 'package:movie_watch/models/show_details.dart';
import 'package:movie_watch/models/tvseries_credit.dart';
import 'package:movie_watch/models/videos.dart';

class TmdbServices {
  var formattedDate = DateTime.now().toIso8601String().split('T')[0];
  var releaseAfterDate = DateTime.now()
      .subtract(const Duration(days: 45))
      .toIso8601String()
      .split('T')[0];

  var limitDate = DateTime.now()
      .subtract(const Duration(days: 3650))
      .toIso8601String()
      .split('T')[0];

  var seriesLimit = DateTime.now()
      .subtract(const Duration(days: 8395))
      .toIso8601String()
      .split('T')[0];

  var trendingSeriesStart = DateTime.now()
      .subtract(const Duration(days: 1825))
      .toIso8601String()
      .split('T')[0];

  final _apikey = TmdbConfig.apiKey;
  final header =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiMjczZjAwODhkZWFhZWJiNTM2ZDYwZDk3ZGUyNjJlNyIsIm5iZiI6MTc1OTczNzk4NC4yNjQ5OTk5LCJzdWIiOiI2OGUzNzg4MGNkMzcyYTRjZGRjMjI4ZTYiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.kPDBwcifpbou680XP1fFktUaFj-Z3ZmlkmPMUKcvqJ0';
  String buildDiscoverUrl({
    int page = 1,
    String sortBy = 'popularity.desc',
    bool includeAdult = false,
    bool includeVideo = false,
    String language = 'en-US',
    String? releaseAfter,
    String? releaseBefore,
    int? voteCount,
    double? voteAverageGte,
    String? genreId,
    String? region,
    String? query, // for title-based search (future)
    String? withCast, // for actor/crew-based personalization (future)
  }) {
    final base = 'https://api.themoviedb.org/3/discover/movie';

    final params = {
      'include_adult': includeAdult.toString(),
      'include_video': includeVideo.toString(),
      'language': language,
      'page': page.toString(),
      'sort_by': sortBy,
      if (releaseAfter != null) 'primary_release_date.gte': releaseAfter,
      if (releaseBefore != null) 'primary_release_date.lte': releaseBefore,
      if (voteCount != null) 'vote_count.gte': '$voteCount',
      if (voteAverageGte != null) 'vote_average.gte': '$voteAverageGte',
      if (genreId != null) 'with_genres': genreId,
      if (region != null) 'region': region,
      if (query != null) 'query': query, // allows title search
      if (withCast != null)
        'with_cast': withCast, // allows actor-based discovery
    };

    return '$base?${Uri(queryParameters: params).query}';
  }

  String buildDiscoverTvUrl({
    int page = 1,
    String sortBy = 'popularity.desc',
    bool includeAdult = false,
    bool includeNullFirstAirDates = false,
    String language = 'en-US',
    String? airDateGte,
    String? airDateLte,
    String? firstAirDateGte,
    String? firstAirDateLte,
    int? firstAirDateYear,
    double? voteAverageGte,
    double? voteAverageLte,
    int? voteCountGte,
    int? voteCountLte,
    String? withCompanies,
    String? genreId,
    String? withKeywords,
    String? withNetworks,
    String? withOriginCountry,
    String? withOriginalLanguage,
    int? withRuntimeGte,
    int? withRuntimeLte,
    String? withStatus, // possible: 0–5
    String? withWatchMonetizationTypes, // e.g., "flatrate,free,ads"
    String? withWatchProviders,
    String? withoutCompanies,
    String? withoutGenres,
    String? withoutKeywords,
    String? withoutWatchProviders,
    String? withType, // possible: 0–6
    String? watchRegion,
    String? timezone,
    bool? screenedTheatrically,
  }) {
    const base = 'https://api.themoviedb.org/3/discover/tv';

    final params = {
      'include_adult': includeAdult.toString(),
      'include_null_first_air_dates': includeNullFirstAirDates.toString(),
      'language': language,
      'page': page.toString(),
      'sort_by': sortBy,
      if (airDateGte != null) 'air_date.gte': airDateGte,
      if (airDateLte != null) 'air_date.lte': airDateLte,
      if (firstAirDateGte != null) 'first_air_date.gte': firstAirDateGte,
      if (firstAirDateLte != null) 'first_air_date.lte': firstAirDateLte,
      if (firstAirDateYear != null)
        'first_air_date_year': firstAirDateYear.toString(),
      if (voteAverageGte != null) 'vote_average.gte': voteAverageGte.toString(),
      if (voteAverageLte != null) 'vote_average.lte': voteAverageLte.toString(),
      if (voteCountGte != null) 'vote_count.gte': voteCountGte.toString(),
      if (voteCountLte != null) 'vote_count.lte': voteCountLte.toString(),
      if (withCompanies != null) 'with_companies': withCompanies,
      if (genreId != null) 'with_genres': genreId,
      if (withKeywords != null) 'with_keywords': withKeywords,
      if (withNetworks != null) 'with_networks': withNetworks,
      if (withOriginCountry != null) 'with_origin_country': withOriginCountry,
      if (withOriginalLanguage != null)
        'with_original_language': withOriginalLanguage,
      if (withRuntimeGte != null) 'with_runtime.gte': withRuntimeGte.toString(),
      if (withRuntimeLte != null) 'with_runtime.lte': withRuntimeLte.toString(),
      if (withStatus != null) 'with_status': withStatus,
      if (withWatchMonetizationTypes != null)
        'with_watch_monetization_types': withWatchMonetizationTypes,
      if (withWatchProviders != null)
        'with_watch_providers': withWatchProviders,
      if (withoutCompanies != null) 'without_companies': withoutCompanies,
      if (withoutGenres != null) 'without_genres': withoutGenres,
      if (withoutKeywords != null) 'without_keywords': withoutKeywords,
      if (withoutWatchProviders != null)
        'without_watch_providers': withoutWatchProviders,
      if (withType != null) 'with_type': withType,
      if (watchRegion != null) 'watch_region': watchRegion,
      if (timezone != null) 'timezone': timezone,
      if (screenedTheatrically != null)
        'screened_theatrically': screenedTheatrically.toString(),
    };

    return '$base?${Uri(queryParameters: params).query}';
  }

  Future<List<Movie>> fetchPopularMovies({
    int page = 1,
    String? genreId,
  }) async {
    try {
      final url = buildDiscoverUrl(
        voteCount: 100,
        sortBy: 'popularity.desc',
        releaseBefore: formattedDate,
        page: page,
        genreId: genreId,
      );
      // 'https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&release_date.lte=$formattedDate&sort_by=popularity.desc&vote_count.gte=100';

      http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $header',
        },
      );
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['results'];
        return data.map((e) => Movie.fromJson(e)).toList();
      } else {
        print(response.body);
        throw Exception('Error is ${response.body}');
      }
    } catch (e) {
      print(e);
      throw Exception('Error fetching popular movies: $e');
    }
  }

  Future<List<Genres>> fetchMovieGenre() async {
    try {
      const url = "https://api.themoviedb.org/3/genre/movie/list?language=en";

      http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $header',
        },
      );
      if (response.statusCode == 200) {
        List<Genres> genres = [];
        var g = jsonDecode(response.body);
        for (var genre in g['genres']) {
          genres.add(Genres.fromMap(genre));
        }
        return genres;
      } else {
        throw Exception('Error is ${response.body}');
      }
    } catch (e) {
      print(e);
      throw Exception('Error fetching genres: $e');
    }
  }

  Future<List<Movie>> fetchTrendingMovies({
    int page = 1,
    String? genreId,
  }) async {
    try {
      final url = buildDiscoverUrl(
        releaseAfter: releaseAfterDate,
        sortBy: 'popularity.desc',
        voteCount: 50,
        page: page,
        genreId: genreId,
      );
      // 'https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&release_date.lte=$formattedDate&sort_by=popularity.desc&vote_count.gte=50';

      http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $header',
        },
      );
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['results'];
        return data.map((e) => Movie.fromJson(e)).toList();
      } else {
        throw Exception('Error is ${response.body}');
      }
    } catch (e) {
      print(e);
      throw Exception('Error fetching genres: $e');
    }
  }

  Future<List<Movie>> fetchNowPlaying({int page = 1, String? genreId}) async {
    final url = buildDiscoverUrl(
      voteCount: 100,
      sortBy: 'primary_release_date.desc',
      releaseBefore: formattedDate,
      page: page,
      genreId: genreId,
    );
    // 'https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&primary_release_date.lte=$formattedDate&sort_by=primary_release_date.desc&vote_count.gte=50';

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $header',
        },
      );
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['results'];
        return data.map((e) => Movie.fromJson(e)).toList();
      } else {
        throw Exception('Error is ${response.body}');
      }
    } catch (e, str) {
      throw Exception('Error is $e - $str');
    }
  }

  Future<List<Movie>> fetchUpcomingMovies({
    int page = 1,
    String? genreId,
  }) async {
    final url = buildDiscoverUrl(
      sortBy: 'primary_release_date.des',
      releaseAfter: formattedDate,
      page: page,
      genreId: genreId,
    );
    // 'https://api.themoviedb.org/3/discover/movie?include_adult=true&include_video=false&language=en-US&page=1&sort_by=release_date.asc&release_date.gte=today';

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $header',
        },
      );
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['results'];
        return data.map((e) => Movie.fromJson(e)).toList();
      } else {
        throw Exception('Error is ${response.body}');
      }
    } catch (e, str) {
      throw Exception('Error is $e - $str');
    }
  }

  Future<List<Movie>> fetchTopRated({int page = 1, String? genreId}) async {
    final url = buildDiscoverUrl(
      sortBy: 'vote_average.desc',
      voteCount: 800,
      releaseAfter: limitDate,
      page: page,
      genreId: genreId,
    );

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $header',
        },
      );
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['results'];
        return data.map((e) => Movie.fromJson(e)).toList();
      } else {
        throw Exception('Error is ${response.body}');
      }
    } catch (e, str) {
      throw Exception('Error is $e - $str');
    }
  }

  Future<MovieDetails> fetchMovieDetails(int movieId) async {
    try {
      final url = 'https://api.themoviedb.org/3/movie/$movieId?language=en-US';

      http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $header',
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        return MovieDetails.fromMap(data);
      } else {
        throw Exception('Error is ${response.body}, movie details');
      }
    } catch (e, str) {
      // print(e);
      throw Exception('Error fetching movie details: $e, $str');
    }
  }

  Future<Credits> fetchMovieCredits(int movieId) async {
    try {
      final url =
          'https://api.themoviedb.org/3/movie/$movieId/credits?language=en-US';

      http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $header',
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        return Credits.fromMap(data);
      } else {
        throw Exception('Error is ${response.body}, credits');
      }
    } catch (e) {
      print(e);
      throw Exception('Error fetching movie details: $e');
    }
  }

  Future<List<Movie>> fetchMovieRecommendations(int movieId) async {
    try {
      final url =
          'https://api.themoviedb.org/3/movie/$movieId/recommendations?language=en-US&page=1';

      http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $header',
        },
      );
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['results'];
        return data.map((e) => Movie.fromMap(e)).toList();
      } else {
        throw Exception('Error is ${response.body}, video recommendations');
      }
    } catch (e) {
      print(e);
      throw Exception('Error fetching movie recommendations: $e');
    }
  }

  Future<Videos> fetchMovieVideos(int movieId) async {
    try {
      final url =
          'https://api.themoviedb.org/3/movie/$movieId/videos?language=en-US';

      http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $header',
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return Videos.fromMap(data);
      } else {
        throw Exception('Error is ${response.body} movie videos');
      }
    } catch (e) {
      print(e);
      throw Exception('Error fetching videos: $e');
    }
  }

  ///series
  ///
  ///
  ///
  ///
  ///
  Future<List<Movie>> fetchPopularSeries({
    int page = 1,
    String? genreId,
  }) async {
    try {
      final url = buildDiscoverTvUrl(
        sortBy: 'popularity.desc',
        voteCountGte: 100,
        page: page,
        genreId: genreId,
      );

      http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $header',
        },
      );
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['results'];
        return data.map((e) => Movie.fromJson(e)).toList();
      } else {
        throw Exception('Error is ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching popular movies: $e');
    }
  }

  Future<List<Genres>> fetchSeriesGenre() async {
    try {
      const url = 'https://api.themoviedb.org/3/genre/tv/list?language=en';

      http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $header',
        },
      );
      if (response.statusCode == 200) {
        List<Genres> genres = [];
        var g = jsonDecode(response.body);
        for (var genre in g['genres']) {
          genres.add(Genres.fromMap(genre));
        }
        return genres;
      } else {
        throw Exception('Error is ${response.body}');
      }
    } catch (e) {
      print(e);
      throw Exception('Error fetching genres: $e');
    }
  }

  Future<List<Movie>> fetchAiringToday({int page = 1, String? genreId}) async {
    final url = buildDiscoverTvUrl(
      sortBy: 'popularity.desc',
      voteCountGte: 100,
      airDateGte: formattedDate,
      airDateLte: formattedDate,
      page: page,
      genreId: genreId,
    );
    'https://api.themoviedb.org/3/tv/airing_today?language=en-US&page=1';

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $header',
        },
      );
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['results'];
        return data.map((e) => Movie.fromJson(e)).toList();
      } else {
        throw Exception('Error is ${response.body}');
      }
    } catch (e, str) {
      throw Exception('Error is $e - $str');
    }
  }

  Future<List<Movie>> fetchNewSeries({int page = 1, String? genreId}) async {
    final url = buildDiscoverTvUrl(
      sortBy: 'first_air_date.desc',
      voteCountGte: 100,
      airDateLte: formattedDate,
      page: page,
      genreId: genreId,
    );
    'https://api.themoviedb.org/3/tv/airing_today?language=en-US&page=1';

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $header',
        },
      );
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['results'];
        return data.map((e) => Movie.fromJson(e)).toList();
      } else {
        throw Exception('Error is ${response.body}');
      }
    } catch (e, str) {
      throw Exception('Error is $e - $str');
    }
  }

  Future<List<Movie>> fetchTrendingSeries({
    int page = 1,
    String? genreId,
  }) async {
    final url = buildDiscoverTvUrl(
      sortBy: 'popularity.desc',
      voteCountGte: 50,
      airDateGte: releaseAfterDate,
      firstAirDateGte: trendingSeriesStart,
      withStatus: '0|1|2',
      page: page,
      genreId: genreId,
    );
    'https://api.themoviedb.org/3/tv/airing_today?language=en-US&page=1';

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $header',
        },
      );
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['results'];
        return data.map((e) => Movie.fromJson(e)).toList();
      } else {
        throw Exception('Error is ${response.body}');
      }
    } catch (e, str) {
      throw Exception('Error is $e - $str');
    }
  }

  Future<List<Movie>> fetchUpcomingSeries({
    int page = 1,
    String? genreId,
  }) async {
    final url = buildDiscoverTvUrl(
      sortBy: 'first_air_date.asc',

      firstAirDateGte: formattedDate,
      page: page,
      genreId: genreId,
    );
    'https://api.themoviedb.org/3/tv/airing_today?language=en-US&page=1';

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $header',
        },
      );
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['results'];
        return data.map((e) => Movie.fromJson(e)).toList();
      } else {
        throw Exception('Error is ${response.body}');
      }
    } catch (e, str) {
      throw Exception('Error is $e - $str');
    }
  }

  Future<List<Movie>> fetchTopRatedSeries({
    int page = 1,
    String? genreId,
  }) async {
    final url = buildDiscoverTvUrl(
      sortBy: 'vote_average.desc',
      voteCountGte: 800,
      airDateGte: seriesLimit,
      voteAverageGte: 7.0,
      page: page,
      genreId: genreId,
    );

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $header',
        },
      );
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['results'];
        return data.map((e) => Movie.fromJson(e)).toList();
      } else {
        throw Exception('Error is ${response.body}');
      }
    } catch (e, str) {
      throw Exception('Error is $e - $str');
    }
  }

  Future<TvShow> fetchTvSeriesDetails({required int seriesId}) async {
    var url = 'https://api.themoviedb.org/3/tv/$seriesId?language=en-US';

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $header',
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // print(data);
        return TvShow.fromMap(data);
      } else {
        print(response.body);

        throw Exception('Error is ${response.body}');
      }
    } catch (e, str) {
      print("$e - $str");
      throw Exception('Error is $e - $str');
    }
  }

  Future<List<TvSeriesCredits>> fetchTvSeriesCredit({
    required int seriesId,
  }) async {
    var url =
        'https://api.themoviedb.org/3/tv/$seriesId/aggregate_credits?language=en-US';

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $header',
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['cast'];

        return TvSeriesCredits.listFromMap(data);
        //return data.map((e) => TvSeriesCredits.listFromMap(e)).toList();
      } else {
        print(response.body);

        throw Exception('Error is ${response.body}');
      }
    } catch (e, str) {
      print("$e and $str");
      throw Exception('Error is $e - $str');
    }
  }

  Future<RecommendedSeries> fetchRecommendedTvSeries({
    required int seriesId,
  }) async {
    var url =
        'https://api.themoviedb.org/3/tv/$seriesId/recommendations?language=en-US&page=1';

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $header',
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return RecommendedSeries.fromMap(data);
      } else {
        print(response.body);

        throw Exception('Error is ${response.body}');
      }
    } catch (e, str) {
      throw Exception('Error is $e - $str');
    }
  }

  Future<SeriesTrailers> fetchTvSeriesTrailers({required int seriesId}) async {
    var url = 'https://api.themoviedb.org/3/tv/$seriesId/videos?language=en-US';

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $header',
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return SeriesTrailers.fromMap(data);
      } else {
        print(response.body);

        throw Exception('Error is ${response.body}');
      }
    } catch (e, str) {
      throw Exception('Error is $e - $str');
    }
  }

  Future<Episodes> fetchEpisodeDeatils(
    int seriesId,
    int episode_number,
    int season_number,
  ) async {
    var url =
        'https://api.themoviedb.org/3/tv/$seriesId/season/$season_number/episode/$episode_number?language=en-US';

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $header',
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return Episodes.fromMap(data);
      } else {
        throw Exception(response.body);
      }
    } catch (e, st) {
      throw Exception(" $e - $st");
    }
  }
}
