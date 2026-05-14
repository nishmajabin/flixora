/// App-level constants for the Flixora application.
///
/// Centralizes all static configuration values including API endpoints,
/// pagination settings, database configuration, and asset paths.
class AppConstants {
  AppConstants._();

  // ── App Info ──────────────────────────────────────────────────────────────
  static const String appName = 'Flixora';
  static const String appVersion = '1.0.0';

  // ── API Configuration ─────────────────────────────────────────────────────
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String apiKey = '8ddbcb5cf389ceabaf5b46a18ecc894c';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p';

  // ── Image Sizes ───────────────────────────────────────────────────────────
  static const String posterSizeSmall = '/w185';
  static const String posterSizeMedium = '/w342';
  static const String posterSizeLarge = '/w500';
  static const String backdropSizeMedium = '/w780';
  static const String backdropSizeLarge = '/original';

  // ── API Endpoints ─────────────────────────────────────────────────────────
  static const String trendingMoviesEndpoint = '/trending/movie/day';
  static const String popularMoviesEndpoint = '/movie/popular';
  static const String topRatedMoviesEndpoint = '/movie/top_rated';
  static const String nowPlayingMoviesEndpoint = '/movie/now_playing';
  static const String upcomingMoviesEndpoint = '/movie/upcoming';
  static const String movieDetailEndpoint = '/movie'; // Append /{id}
  static const String searchMovieEndpoint = '/search/movie';

  // ── Pagination ────────────────────────────────────────────────────────────
  static const int defaultPageSize = 20;
  static const int paginationThreshold = 5; // Items before end to trigger load

  // ── Database ──────────────────────────────────────────────────────────────
  static const String databaseName = 'flixora.db';
  static const int databaseVersion = 1;
  static const String moviesTable = 'movies';
  static const String favoriteMoviesTable = 'favorite_movies';

  // ── Cache Duration ────────────────────────────────────────────────────────
  static const Duration cacheDuration = Duration(hours: 6);

  // ── Timeouts ──────────────────────────────────────────────────────────────
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ── Error Messages ────────────────────────────────────────────────────────
  static const String networkErrorMessage =
      'No internet connection. Please check your network settings.';
  static const String serverErrorMessage =
      'Something went wrong. Please try again later.';
  static const String timeoutErrorMessage =
      'Connection timed out. Please try again.';
  static const String unknownErrorMessage =
      'An unexpected error occurred.';
  static const String noDataMessage = 'No movies found.';
}
