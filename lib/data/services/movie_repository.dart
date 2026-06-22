import 'package:flixora/core/utils/api_exception.dart';
import 'package:flixora/core/utils/app_logger.dart';
import 'package:flixora/data/database/movie_database_helper.dart';
import 'package:flixora/data/models/cast_model.dart';
import 'package:flixora/data/models/movie_model.dart';
import 'package:flixora/data/services/movie_api_service.dart';

class MovieRepository {
  final MovieApiService _apiService;
  final MovieDatabaseHelper _databaseHelper;

  MovieRepository({
    required MovieApiService apiService,
    required MovieDatabaseHelper databaseHelper,
  })  : _apiService = apiService,
        _databaseHelper = databaseHelper;

  // ── Trending Movies ─────────────────────────────────────────────────────

  /// Fetches trending movies with cache fallback.
  Future<List<Movie>> getTrendingMovies({int page = 1}) async {
    try {
      final movies = await _apiService.getTrendingMovies(page: page);
      if (page == 1) {
        await _databaseHelper.cacheMovies(movies, clearExisting: true);
      }
      return movies;
    } on NetworkException {
      return _getCachedMoviesFallback();
    } on ApiException catch (e) {
      AppLogger.error('Trending API error: ${e.message}');
      final cached = await _databaseHelper.getCachedMovies();
      if (cached.isNotEmpty) return cached;
      rethrow;
    } catch (e) {
      return _getCachedMoviesFallback();
    }
  }

  // ── Popular Movies ──────────────────────────────────────────────────────
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    try {
      AppLogger.info('Fetching movies from API (page $page)...');
      final movies = await _apiService.getPopularMovies(page: page);

      await _databaseHelper.cacheMovies(
        movies,
        clearExisting: page == 1,
      );

      AppLogger.info('API success: ${movies.length} movies (page $page).');
      return movies;
    } on NetworkException {
      AppLogger.warning('Network unavailable (page $page) — falling back to cache.');
      return _getCachedMoviesFallback();
    } on ApiException catch (e) {
      AppLogger.error('API error (page $page): ${e.message}');
      // For non-network API errors, also try cache fallback
      final cached = await _databaseHelper.getCachedMovies();
      if (cached.isNotEmpty) {
        AppLogger.info('API failed but cache has ${cached.length} movies — using cache.');
        return cached;
      }
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error fetching movies (page $page)', error: e, stackTrace: stackTrace);
      return _getCachedMoviesFallback();
    }
  }

  // ── Now Playing ─────────────────────────────────────────────────────────

  /// Fetches now-playing movies (used for the banner carousel).
  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    try {
      return await _apiService.getNowPlayingMovies(page: page);
    } on ApiException catch (e) {
      AppLogger.error('Now Playing fetch failed: ${e.message}');
      return [];
    } catch (e) {
      AppLogger.error('Now Playing unexpected error: $e');
      return [];
    }
  }

  // ── Top Rated ───────────────────────────────────────────────────────────

  /// Fetches top-rated movies.
  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    try {
      return await _apiService.getTopRatedMovies(page: page);
    } on ApiException catch (e) {
      AppLogger.error('Top Rated fetch failed: ${e.message}');
      return [];
    } catch (e) {
      AppLogger.error('Top Rated unexpected error: $e');
      return [];
    }
  }

  // ── Upcoming ────────────────────────────────────────────────────────────

  /// Fetches upcoming movies.
  Future<List<Movie>> getUpcomingMovies({int page = 1}) async {
    try {
      return await _apiService.getUpcomingMovies(page: page);
    } on ApiException catch (e) {
      AppLogger.error('Upcoming fetch failed: ${e.message}');
      return [];
    } catch (e) {
      AppLogger.error('Upcoming unexpected error: $e');
      return [];
    }
  }

  // ── Movie Detail ────────────────────────────────────────────────────────

  /// Fetches movie detail by [id] with cache fallback.
  Future<Movie> getMovieDetail(int id) async {
    try {
      final movie = await _apiService.getMovieDetail(id);
      AppLogger.info('Fetched movie detail: "${movie.title}"');
      return movie;
    } on NetworkException {
      AppLogger.warning('Network unavailable — checking cache for movie $id.');
      final cached = await _databaseHelper.getCachedMovieById(id);
      if (cached != null) {
        AppLogger.info('Found cached movie detail: "${cached.title}"');
        return cached;
      }
      AppLogger.error('No cached data for movie $id.');
      throw const NetworkException();
    } on ApiException {
      rethrow;
    }
  }

  // ── Similar Movies ──────────────────────────────────────────────────────

  /// Fetches similar movies for a given [movieId].
  Future<List<Movie>> getSimilarMovies(int movieId) async {
    try {
      return await _apiService.getSimilarMovies(movieId);
    } on ApiException catch (e) {
      AppLogger.error('Similar movies fetch failed: ${e.message}');
      return [];
    } catch (e) {
      AppLogger.error('Similar movies unexpected error: $e');
      return [];
    }
  }

  // ── Movie Credits ───────────────────────────────────────────────────────

  /// Fetches cast for a given [movieId].
  Future<List<CastMember>> getMovieCredits(int movieId) async {
    try {
      return await _apiService.getMovieCredits(movieId);
    } on ApiException catch (e) {
      AppLogger.error('Movie credits fetch failed: ${e.message}');
      return [];
    } catch (e) {
      AppLogger.error('Movie credits unexpected error: $e');
      return [];
    }
  }

  // ── Search ──────────────────────────────────────────────────────────────

  /// Searches movies by query (no caching for search results).
  Future<List<Movie>> searchMovies({
    required String query,
    int page = 1,
  }) async {
    return _apiService.searchMovies(query: query, page: page);
  }

  // ── Favorites / Watchlist ───────────────────────────────────────────────

  /// Adds a movie to the watchlist.
  Future<void> addToWatchlist(Movie movie) async {
    await _databaseHelper.addFavorite(movie);
  }

  /// Removes a movie from the watchlist.
  Future<void> removeFromWatchlist(int movieId) async {
    await _databaseHelper.removeFavorite(movieId);
  }

  /// Returns true if the movie is in the watchlist.
  Future<bool> isInWatchlist(int movieId) async {
    return _databaseHelper.isFavorite(movieId);
  }

  /// Retrieves all watchlisted movies.
  Future<List<Movie>> getWatchlist() async {
    return _databaseHelper.getFavorites();
  }

  // ── Cache Management ────────────────────────────────────────────────────

  /// Explicitly clears the local movie cache.
  Future<void> clearCache() async {
    AppLogger.database('Explicit cache clear requested.');
    await _databaseHelper.clearCache();
  }

  // ── Private ─────────────────────────────────────────────────────────────

  /// Returns cached movies or throws NetworkException if cache is empty.
  Future<List<Movie>> _getCachedMoviesFallback() async {
    final cached = await _databaseHelper.getCachedMovies();
    if (cached.isNotEmpty) {
      AppLogger.info('Offline fallback: loaded ${cached.length} movies from cache.');
      return cached;
    }
    AppLogger.error('Offline fallback failed: cache is empty.');
    throw const NetworkException();
  }
}
