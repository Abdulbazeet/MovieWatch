enum TableType { movies, tvshows, kdramas, anime }

enum MovieType {
  nowPlaying,
  popular,
  topRated,
  trending,
  upcoming,
  airingToday,
}

enum bottomType { trailers, recommendations }

enum MediaType {
  person,
  movie,
  tv,
  kdrama;

  String get value => name;
  static MediaType fromString(String value) {
    return MediaType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => MediaType.movie, // safe fallback
    );
  }
}
