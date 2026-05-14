import 'package:flixora/data/models/movie_model.dart';

/// Abstract contract for local movie database operations.
///
/// Defines the interface for caching and retrieving movie data
/// from the local SQFlite database.
abstract class MovieDatabaseHelper {
  /// Initializes the database and creates tables if they don't exist.
  Future<void> initDatabase();

  /// Caches a list of movies to the local database.
  ///
  /// If [clearExisting] is true, existing cached movies are removed first.
  Future<void> cacheMovies(List<Movie> movies, {bool clearExisting = false});

  /// Retrieves all cached movies from the local database.
  Future<List<Movie>> getCachedMovies();

  /// Retrieves a single cached movie by its [id].
  Future<Movie?> getCachedMovieById(int id);

  /// Clears all cached movies from the database.
  Future<void> clearCache();

  /// Checks whether the cache has valid (non-expired) data.
  Future<bool> isCacheValid();

  // ── Favorites / Watchlist ───────────────────────────────────────────────

  /// Adds a movie to the favorites/watchlist.
  Future<void> addFavorite(Movie movie);

  /// Removes a movie from the favorites/watchlist.
  Future<void> removeFavorite(int movieId);

  /// Returns true if the movie is in the favorites/watchlist.
  Future<bool> isFavorite(int movieId);

  /// Retrieves all favorite/watchlisted movies.
  Future<List<Movie>> getFavorites();

  /// Closes the database connection.
  Future<void> close();
}
