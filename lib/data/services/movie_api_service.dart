import 'package:flixora/data/models/cast_model.dart';
import 'package:flixora/data/models/movie_model.dart';

/// Abstract contract for the movie API service.
///
/// Defines the interface for fetching movie data from a remote source.
/// Concrete implementations will handle HTTP requests to the TMDB API.
abstract class MovieApiService {
  /// Fetches a paginated list of popular movies.
  Future<List<Movie>> getPopularMovies({int page = 1});

  /// Fetches a paginated list of trending movies (daily).
  Future<List<Movie>> getTrendingMovies({int page = 1});

  /// Fetches a paginated list of now-playing movies (for banner/carousel).
  Future<List<Movie>> getNowPlayingMovies({int page = 1});

  /// Fetches a paginated list of top-rated movies.
  Future<List<Movie>> getTopRatedMovies({int page = 1});

  /// Fetches a paginated list of upcoming movies.
  Future<List<Movie>> getUpcomingMovies({int page = 1});

  /// Fetches detailed information for a specific movie by [id].
  Future<Movie> getMovieDetail(int id);

  /// Fetches similar movies for a given [movieId].
  Future<List<Movie>> getSimilarMovies(int movieId, {int page = 1});

  /// Fetches cast members for a given [movieId].
  Future<List<CastMember>> getMovieCredits(int movieId);

  /// Searches movies by [query] string with pagination support.
  Future<List<Movie>> searchMovies({required String query, int page = 1});
}
