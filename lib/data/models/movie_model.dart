import 'package:equatable/equatable.dart';

/// Movie data model for the Flixora application.
///
/// Uses [Equatable] for value-based equality, which is essential
/// for proper BLoC state comparison and UI rebuilds.
class Movie extends Equatable {
  final int id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final String? releaseDate;
  final List<int> genreIds;
  final double popularity;
  final bool adult;
  final String? originalLanguage;

  const Movie({
    required this.id,
    required this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.voteAverage = 0.0,
    this.voteCount = 0,
    this.releaseDate,
    this.genreIds = const [],
    this.popularity = 0.0,
    this.adult = false,
    this.originalLanguage,
  });

  /// Creates a [Movie] instance from a JSON map (TMDB API response).
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] as int? ?? 0,
      releaseDate: json['release_date'] as String?,
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      adult: json['adult'] as bool? ?? false,
      originalLanguage: json['original_language'] as String?,
    );
  }

  /// Converts this [Movie] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'release_date': releaseDate,
      'genre_ids': genreIds,
      'popularity': popularity,
      'adult': adult,
      'original_language': originalLanguage,
    };
  }

  /// Alias for [fromJson] — creates a [Movie] from a generic map.
  factory Movie.fromMap(Map<String, dynamic> map) => Movie.fromJson(map);

  /// Alias for [toJson] — converts this [Movie] to a generic map.
  Map<String, dynamic> toMap() => toJson();

  /// Converts this [Movie] to a map suitable for SQFlite insertion.
  ///
  /// Genre IDs are stored as a comma-separated string since
  /// SQLite does not support list columns.
  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'release_date': releaseDate,
      'genre_ids': genreIds.join(','),
      'popularity': popularity,
      'adult': adult ? 1 : 0,
      'original_language': originalLanguage,
    };
  }

  /// Creates a [Movie] instance from a SQFlite database row.
  factory Movie.fromDbMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'] as int,
      title: map['title'] as String? ?? '',
      overview: map['overview'] as String?,
      posterPath: map['poster_path'] as String?,
      backdropPath: map['backdrop_path'] as String?,
      voteAverage: (map['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: map['vote_count'] as int? ?? 0,
      releaseDate: map['release_date'] as String?,
      genreIds: (map['genre_ids'] as String?)
              ?.split(',')
              .where((e) => e.isNotEmpty)
              .map((e) => int.parse(e))
              .toList() ??
          [],
      popularity: (map['popularity'] as num?)?.toDouble() ?? 0.0,
      adult: (map['adult'] as int?) == 1,
      originalLanguage: map['original_language'] as String?,
    );
  }

  /// Creates a copy of this [Movie] with the given fields replaced.
  Movie copyWith({
    int? id,
    String? title,
    String? overview,
    String? posterPath,
    String? backdropPath,
    double? voteAverage,
    int? voteCount,
    String? releaseDate,
    List<int>? genreIds,
    double? popularity,
    bool? adult,
    String? originalLanguage,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      releaseDate: releaseDate ?? this.releaseDate,
      genreIds: genreIds ?? this.genreIds,
      popularity: popularity ?? this.popularity,
      adult: adult ?? this.adult,
      originalLanguage: originalLanguage ?? this.originalLanguage,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        overview,
        posterPath,
        backdropPath,
        voteAverage,
        voteCount,
        releaseDate,
        genreIds,
        popularity,
        adult,
        originalLanguage,
      ];

  @override
  String toString() => 'Movie(id: $id, title: $title)';
}
