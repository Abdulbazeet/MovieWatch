import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_watch/config/tmdb_config.dart';
import 'package:movie_watch/models/cast.dart';
import 'package:movie_watch/models/genre.dart';
import 'package:movie_watch/models/movie_details.dart';
import 'package:movie_watch/models/movies.dart';

class TmdbServices {
  final _apikey = TmdbConfig.apiKey;
  final header =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiMjczZjAwODhkZWFhZWJiNTM2ZDYwZDk3ZGUyNjJlNyIsIm5iZiI6MTc1OTczNzk4NC4yNjQ5OTk5LCJzdWIiOiI2OGUzNzg4MGNkMzcyYTRjZGRjMjI4ZTYiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.kPDBwcifpbou680XP1fFktUaFj-Z3ZmlkmPMUKcvqJ0';

  Future<List<Movie>> fetchPopularMovies() async {
    try {
      const url = 'https://api.themoviedb.org/3/movie/popular?language=en-US';

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

  Future<List<Movie>> fetchTrendingMovies() async {
    try {
      const url =
          'https://api.themoviedb.org/3/trending/all/week?language=en-US';

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
        return MovieDetails.fromJson(data);
      } else {
        throw Exception('Error is ${response.body}');
      }
    } catch (e) {
      print(e);
      throw Exception('Error fetching movie details: $e');
    }
  }

  Future<Cast> fetchMovieCast(int movieId) async {
    try {
      final url =
          "https://api.themoviedb.org/3/movie/$movieId/credits?api_key=$_apikey&language=en-US";
      http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $header',
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return Cast.fromJson(data);
      } else {
        throw Exception('Error is ${response.body}');
      }
    } catch (e) {
      print(e);
      throw Exception('Error fetching movie details: $e');
    }
  }

  Future<List<Movie>> fetchNowPlaying() async {
    var url =
        'https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=1';

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

  Future<List<Movie>> fetchUpcomingMovies() async {
    var url =
        'https://api.themoviedb.org/3/movie/upcoming?language=en-US&page=1';

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

  Future<List<Movie>> fetchTopRated() async {
    var url =
        'https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1';
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

  ///series
  ///
  ///
  ///
  ///
  ///
  Future<List<Movie>> fetchPopularSeries() async {
    try {
      const url =
          'https://api.themoviedb.org/3/tv/popular?language=en-US&page=1';

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

  Future<List<Movie>> fetchAiringToday() async {
    const url =
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

}
