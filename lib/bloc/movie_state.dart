import 'package:equatable/equatable.dart';

import 'package:flixora/data/models/movie_model.dart';

/// Represents the various states of movie data loading.
///
/// Used by [MovieBloc] to communicate the current state to the UI.
/// Extends [Equatable] for efficient state comparison in BLoC.

/// Base class for all movie-related states.
abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any data has been loaded.
class MovieInitial extends MovieState {
  const MovieInitial();
}

/// State emitted while movies are being fetched for the first time.
class MovieLoading extends MovieState {
  const MovieLoading();
}

/// State emitted when movies have been successfully loaded.
class MovieLoaded extends MovieState {
  final List<Movie> movies;
  final int currentPage;
  final bool hasReachedMax;

  const MovieLoaded({
    required this.movies,
    this.currentPage = 1,
    this.hasReachedMax = false,
  });

  MovieLoaded copyWith({
    List<Movie>? movies,
    int? currentPage,
    bool? hasReachedMax,
  }) {
    return MovieLoaded(
      movies: movies ?? this.movies,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [movies, currentPage, hasReachedMax];
}

/// State emitted while loading additional pages (pagination).
class MovieLoadingMore extends MovieState {
  final List<Movie> movies;
  final int currentPage;

  const MovieLoadingMore({
    required this.movies,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [movies, currentPage];
}

/// State emitted when an error occurs during data fetching.
class MovieError extends MovieState {
  final String message;
  final List<Movie> previousMovies;

  const MovieError({
    required this.message,
    this.previousMovies = const [],
  });

  @override
  List<Object?> get props => [message, previousMovies];
}

// ── Search States ─────────────────────────────────────────────────────────

/// State emitted while a search query is being processed.
class MovieSearchLoading extends MovieState {
  const MovieSearchLoading();
}

/// State emitted when search results are returned successfully.
class MovieSearchLoaded extends MovieState {
  final List<Movie> movies;
  final String query;

  const MovieSearchLoaded({
    required this.movies,
    required this.query,
  });

  @override
  List<Object?> get props => [movies, query];
}

/// State emitted when the search returns no results.
class MovieSearchEmpty extends MovieState {
  final String query;

  const MovieSearchEmpty({required this.query});

  @override
  List<Object?> get props => [query];
}
