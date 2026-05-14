import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flixora/bloc/watchlist/watchlist_state.dart';
import 'package:flixora/core/utils/app_logger.dart';
import 'package:flixora/data/models/movie_model.dart';
import 'package:flixora/data/services/movie_repository.dart';

/// Cubit managing the user's watchlist (favorites).
///
/// Reads from and writes to the local SQFlite database
/// through [MovieRepository].
class WatchlistCubit extends Cubit<WatchlistState> {
  final MovieRepository _repository;

  WatchlistCubit({required MovieRepository repository})
      : _repository = repository,
        super(const WatchlistState());

  /// Loads the watchlist from the database.
  Future<void> loadWatchlist() async {
    emit(state.copyWith(status: WatchlistStatus.loading));
    final movies = await _repository.getWatchlist();
    emit(state.copyWith(status: WatchlistStatus.loaded, movies: movies));
    AppLogger.info('Watchlist loaded: ${movies.length} movies.');
  }

  /// Toggles a movie's watchlist status. Returns the new isFavorite state.
  Future<bool> toggleWatchlist(Movie movie) async {
    final isCurrentlyFavorite = await _repository.isInWatchlist(movie.id);

    if (isCurrentlyFavorite) {
      await _repository.removeFromWatchlist(movie.id);
      AppLogger.info('Removed "${movie.title}" from watchlist.');
    } else {
      await _repository.addToWatchlist(movie);
      AppLogger.info('Added "${movie.title}" to watchlist.');
    }

    // Reload the list
    await loadWatchlist();
    return !isCurrentlyFavorite;
  }

  /// Checks if a movie is in the watchlist.
  Future<bool> isInWatchlist(int movieId) async {
    return _repository.isInWatchlist(movieId);
  }
}
