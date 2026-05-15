import 'package:equatable/equatable.dart';
import 'package:flixora/data/models/movie_model.dart';

/// State for the watchlist/favorites screen.
class WatchlistState extends Equatable {
  final WatchlistStatus status;
  final List<Movie> movies;

  const WatchlistState({
    this.status = WatchlistStatus.initial,
    this.movies = const [],
  });

  WatchlistState copyWith({
    WatchlistStatus? status,
    List<Movie>? movies,
  }) {
    return WatchlistState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
    );
  }

  @override
  List<Object?> get props => [status, movies];
}

enum WatchlistStatus { initial, loading, loaded }
