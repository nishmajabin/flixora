import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flixora/logic/cubit/movie_detail/movie_detail_state.dart';
import 'package:flixora/core/utils/api_exception.dart';
import 'package:flixora/core/utils/app_logger.dart';
import 'package:flixora/data/models/cast_model.dart';
import 'package:flixora/data/models/movie_model.dart';
import 'package:flixora/data/services/movie_repository.dart';

/// Cubit responsible for managing a single movie's detail state.
///
/// Fetches movie detail, cast, similar movies, and favorite status
/// concurrently for maximum speed.
class MovieDetailCubit extends Cubit<MovieDetailState> {
  final MovieRepository _repository;

  MovieDetailCubit({required MovieRepository repository})
      : _repository = repository,
        super(const MovieDetailInitial());

  /// Fetches all detail data for the movie identified by [movieId].
  Future<void> fetchMovieDetail(int movieId) async {
    emit(const MovieDetailLoading());

    try {
      // Fetch detail, cast, similar, and favorite status concurrently.
      final results = await Future.wait([
        _repository.getMovieDetail(movieId),
        _repository.getMovieCredits(movieId),
        _repository.getSimilarMovies(movieId),
        _repository.isInWatchlist(movieId),
      ]);

      final movie = results[0] as Movie;
      final castList = results[1] as List<CastMember>;
      final similar = results[2] as List<Movie>;
      final isFav = results[3] as bool;

      emit(MovieDetailLoaded(
        movie: movie,
        cast: castList,
        similarMovies: similar,
        isFavorite: isFav,
      ));
      AppLogger.info('Loaded full detail for movie id=$movieId.');
    } on ApiException catch (e) {
      emit(MovieDetailError(message: e.message));
      AppLogger.error('MovieDetail fetch failed: ${e.message}');
    } catch (e) {
      emit(const MovieDetailError(message: 'Failed to load movie details.'));
      AppLogger.error('MovieDetail unexpected error: $e');
    }
  }

  /// Toggles the favorite status of the current movie.
  Future<void> toggleFavorite(Movie movie) async {
    final currentState = state;
    if (currentState is! MovieDetailLoaded) return;

    final newFavorite = !currentState.isFavorite;

    // Optimistic update
    emit(currentState.copyWith(isFavorite: newFavorite));

    try {
      if (newFavorite) {
        await _repository.addToWatchlist(movie);
      } else {
        await _repository.removeFromWatchlist(movie.id);
      }
      AppLogger.info('Favorite toggled for "${movie.title}": $newFavorite');
    } catch (e) {
      // Revert on failure
      emit(currentState.copyWith(isFavorite: !newFavorite));
      AppLogger.error('Failed to toggle favorite: $e');
    }
  }
}
