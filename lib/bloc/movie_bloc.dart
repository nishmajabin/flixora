import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flixora/bloc/movie_event.dart';
import 'package:flixora/bloc/movie_state.dart';
import 'package:flixora/core/utils/api_exception.dart';
import 'package:flixora/core/utils/app_logger.dart';
import 'package:flixora/data/services/movie_repository.dart';

/// BLoC responsible for managing the movie list and search state.
///
/// Handles trending movies, pagination, pull-to-refresh,
/// and TMDB search with debounce.
class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository _repository;

  /// Stores the last loaded trending state so we can restore it
  /// when the user clears the search.
  MovieLoaded? _lastTrendingState;

  /// Debounce timer for search input.
  Timer? _debounce;

  MovieBloc({required MovieRepository repository})
      : _repository = repository,
        super(const MovieInitial()) {
    on<FetchMovies>(_onFetchMovies);
    on<FetchMoreMovies>(_onFetchMoreMovies);
    on<RefreshMovies>(_onRefreshMovies);
    on<SearchMovies>(_onSearchMovies);
    on<ClearSearch>(_onClearSearch);
  }

  // ── Trending Movies ─────────────────────────────────────────────────────

  Future<void> _onFetchMovies(FetchMovies event, Emitter<MovieState> emit) async {
    emit(const MovieLoading());
    try {
      final movies = await _repository.getPopularMovies(page: 1);
      final loaded = MovieLoaded(movies: movies, currentPage: 1, hasReachedMax: movies.isEmpty);
      _lastTrendingState = loaded;
      emit(loaded);
      AppLogger.info('Loaded ${movies.length} movies (page 1).');
    } on ApiException catch (e) {
      emit(MovieError(message: e.message));
      AppLogger.error('FetchMovies failed: ${e.message}');
    } catch (e) {
      emit(const MovieError(message: 'An unexpected error occurred.'));
      AppLogger.error('FetchMovies unexpected error: $e');
    }
  }

  Future<void> _onFetchMoreMovies(FetchMoreMovies event, Emitter<MovieState> emit) async {
    final currentState = state;
    if (currentState is! MovieLoaded || currentState.hasReachedMax) return;

    final nextPage = currentState.currentPage + 1;
    emit(MovieLoadingMore(movies: currentState.movies, currentPage: currentState.currentPage));

    try {
      final newMovies = await _repository.getPopularMovies(page: nextPage);
      final loaded = MovieLoaded(
        movies: [...currentState.movies, ...newMovies],
        currentPage: nextPage,
        hasReachedMax: newMovies.isEmpty,
      );
      _lastTrendingState = loaded;
      emit(loaded);
      AppLogger.info('Loaded ${newMovies.length} more movies (page $nextPage). Total: ${loaded.movies.length}');
    } on ApiException catch (e) {
      emit(MovieError(message: e.message, previousMovies: currentState.movies));
    } catch (e) {
      emit(MovieError(message: 'Failed to load more movies.', previousMovies: currentState.movies));
    }
  }

  Future<void> _onRefreshMovies(RefreshMovies event, Emitter<MovieState> emit) async {
    emit(const MovieLoading());
    try {
      final movies = await _repository.getPopularMovies(page: 1);
      final loaded = MovieLoaded(movies: movies, currentPage: 1, hasReachedMax: movies.isEmpty);
      _lastTrendingState = loaded;
      emit(loaded);
      AppLogger.info('Refreshed movie list — ${movies.length} movies.');
    } on ApiException catch (e) {
      emit(MovieError(message: e.message));
    } catch (e) {
      emit(const MovieError(message: 'Failed to refresh movies.'));
    }
  }

  // ── Search ──────────────────────────────────────────────────────────────

  Future<void> _onSearchMovies(SearchMovies event, Emitter<MovieState> emit) async {
    final query = event.query.trim();

    // If query is empty, treat as clear
    if (query.isEmpty) {
      add(const ClearSearch());
      return;
    }

    // Debounce: cancel previous timer and wait 400ms
    _debounce?.cancel();
    final completer = Completer<void>();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      completer.complete();
    });

    emit(const MovieSearchLoading());

    // Wait for debounce
    await completer.future;

    try {
      AppLogger.network('Searching movies: "$query"');
      final movies = await _repository.searchMovies(query: query, page: 1);

      if (movies.isEmpty) {
        emit(MovieSearchEmpty(query: query));
        AppLogger.info('Search "$query" returned 0 results.');
      } else {
        emit(MovieSearchLoaded(movies: movies, query: query));
        AppLogger.info('Search "$query" returned ${movies.length} results.');
      }
    } on ApiException catch (e) {
      emit(MovieError(message: e.message));
      AppLogger.error('Search failed: ${e.message}');
    } catch (e) {
      emit(const MovieError(message: 'Search failed. Please try again.'));
      AppLogger.error('Search unexpected error: $e');
    }
  }

  Future<void> _onClearSearch(ClearSearch event, Emitter<MovieState> emit) async {
    _debounce?.cancel();
    AppLogger.info('Search cleared — restoring trending movies.');

    // Restore the last trending state if available
    if (_lastTrendingState != null) {
      emit(_lastTrendingState!);
    } else {
      // If no cached state, re-fetch
      add(const FetchMovies());
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
