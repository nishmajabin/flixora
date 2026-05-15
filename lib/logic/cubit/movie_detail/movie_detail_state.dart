import 'package:equatable/equatable.dart';

import 'package:flixora/data/models/cast_model.dart';
import 'package:flixora/data/models/movie_model.dart';

/// States for the movie detail screen — now includes cast and similar movies.
abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object?> get props => [];
}

/// Initial state before movie detail is loaded.
class MovieDetailInitial extends MovieDetailState {
  const MovieDetailInitial();
}

/// Loading state while fetching movie detail.
class MovieDetailLoading extends MovieDetailState {
  const MovieDetailLoading();
}

/// Successfully loaded movie detail with cast and similar movies.
class MovieDetailLoaded extends MovieDetailState {
  final Movie movie;
  final List<CastMember> cast;
  final List<Movie> similarMovies;
  final bool isFavorite;

  const MovieDetailLoaded({
    required this.movie,
    this.cast = const [],
    this.similarMovies = const [],
    this.isFavorite = false,
  });

  MovieDetailLoaded copyWith({
    Movie? movie,
    List<CastMember>? cast,
    List<Movie>? similarMovies,
    bool? isFavorite,
  }) {
    return MovieDetailLoaded(
      movie: movie ?? this.movie,
      cast: cast ?? this.cast,
      similarMovies: similarMovies ?? this.similarMovies,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [movie, cast, similarMovies, isFavorite];
}

/// Error state when movie detail fetch fails.
class MovieDetailError extends MovieDetailState {
  final String message;

  const MovieDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}
