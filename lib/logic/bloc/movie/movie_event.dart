import 'package:equatable/equatable.dart';

/// Represents the events that can be dispatched to [MovieBloc].
///
/// Each event triggers a specific action in the BLoC,
/// such as fetching movies, loading the next page, or searching.

/// Base class for all movie-related events.
abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object?> get props => [];
}

/// Dispatched to fetch the initial list of trending movies.
class FetchMovies extends MovieEvent {
  const FetchMovies();
}

/// Dispatched to load the next page of movies (infinite scroll).
class FetchMoreMovies extends MovieEvent {
  const FetchMoreMovies();
}

/// Dispatched to refresh the movie list (pull-to-refresh).
class RefreshMovies extends MovieEvent {
  const RefreshMovies();
}

/// Dispatched to search movies by query string.
class SearchMovies extends MovieEvent {
  final String query;

  const SearchMovies({required this.query});

  @override
  List<Object?> get props => [query];
}

/// Dispatched to clear the search and restore trending movies.
class ClearSearch extends MovieEvent {
  const ClearSearch();
}
