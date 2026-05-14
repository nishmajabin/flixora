import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:flixora/core/constants/app_constants.dart';
import 'package:flixora/core/utils/api_exception.dart';
import 'package:flixora/core/utils/app_logger.dart';
import 'package:flixora/data/models/cast_model.dart';
import 'package:flixora/data/models/movie_model.dart';
import 'package:flixora/data/services/movie_api_service.dart';

/// Concrete implementation of [MovieApiService] using the TMDB API.
///
/// Handles HTTP requests, response parsing, and error mapping
/// for all movie-related API calls.
class MovieApiServiceImpl implements MovieApiService {
  final http.Client _client;

  MovieApiServiceImpl({http.Client? client})
      : _client = client ?? http.Client();

  // ── Public API ──────────────────────────────────────────────────────────

  @override
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    final url = _buildUrl(
      AppConstants.popularMoviesEndpoint,
      page: page,
      extraParams: {'language': 'en-US'},
    );
    AppLogger.network('GET Popular Movies — page $page');
    final response = await _get(url);
    return _parseMovieList(response);
  }

  @override
  Future<List<Movie>> getTrendingMovies({int page = 1}) async {
    final url = _buildUrl(
      AppConstants.trendingMoviesEndpoint,
      page: page,
      extraParams: {'language': 'en-US'},
    );
    AppLogger.network('GET Trending Movies — page $page');
    final response = await _get(url);
    return _parseMovieList(response);
  }

  @override
  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    final url = _buildUrl(
      AppConstants.nowPlayingMoviesEndpoint,
      page: page,
      extraParams: {'language': 'en-US'},
    );
    AppLogger.network('GET Now Playing Movies — page $page');
    final response = await _get(url);
    return _parseMovieList(response);
  }

  @override
  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    final url = _buildUrl(
      AppConstants.topRatedMoviesEndpoint,
      page: page,
      extraParams: {'language': 'en-US'},
    );
    AppLogger.network('GET Top Rated Movies — page $page');
    final response = await _get(url);
    return _parseMovieList(response);
  }

  @override
  Future<List<Movie>> getUpcomingMovies({int page = 1}) async {
    final url = _buildUrl(
      AppConstants.upcomingMoviesEndpoint,
      page: page,
      extraParams: {'language': 'en-US'},
    );
    AppLogger.network('GET Upcoming Movies — page $page');
    final response = await _get(url);
    return _parseMovieList(response);
  }

  @override
  Future<Movie> getMovieDetail(int id) async {
    final url = _buildUrl('${AppConstants.movieDetailEndpoint}/$id');
    AppLogger.network('GET Movie Detail — id $id');

    final response = await _get(url);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return Movie.fromJson(json);
  }

  @override
  Future<List<Movie>> getSimilarMovies(int movieId, {int page = 1}) async {
    final url = _buildUrl(
      '${AppConstants.movieDetailEndpoint}/$movieId/similar',
      page: page,
      extraParams: {'language': 'en-US'},
    );
    AppLogger.network('GET Similar Movies — movieId $movieId, page $page');
    final response = await _get(url);
    return _parseMovieList(response);
  }

  @override
  Future<List<CastMember>> getMovieCredits(int movieId) async {
    final url = _buildUrl(
      '${AppConstants.movieDetailEndpoint}/$movieId/credits',
      extraParams: {'language': 'en-US'},
    );
    AppLogger.network('GET Movie Credits — movieId $movieId');

    final response = await _get(url);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final castList = json['cast'] as List<dynamic>? ?? [];
    return castList
        .map((e) => CastMember.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<Movie>> searchMovies({
    required String query,
    int page = 1,
  }) async {
    final url = _buildUrl(
      AppConstants.searchMovieEndpoint,
      page: page,
      extraParams: {'query': query, 'language': 'en-US'},
    );
    AppLogger.network('GET Search Movies — query "$query", page $page');

    final response = await _get(url);
    return _parseMovieList(response);
  }

  // ── Private Helpers ─────────────────────────────────────────────────────

  /// Constructs a full TMDB API URL with authentication and pagination.
  Uri _buildUrl(
    String endpoint, {
    int? page,
    Map<String, String>? extraParams,
  }) {
    final queryParams = <String, String>{
      'api_key': AppConstants.apiKey,
      if (page != null) 'page': page.toString(),
      if (extraParams != null) ...extraParams,
    };
    return Uri.parse('${AppConstants.baseUrl}$endpoint')
        .replace(queryParameters: queryParams);
  }

  /// Performs a GET request with timeout and error handling.
  Future<http.Response> _get(Uri url) async {
    try {
      final response = await _client
          .get(url)
          .timeout(AppConstants.connectionTimeout);

      return _handleResponse(response);
    } on SocketException {
      AppLogger.error('Network error — no internet connection');
      throw const NetworkException();
    } on HttpException catch (e) {
      AppLogger.error('HTTP error: $e');
      throw const ServerException();
    } on FormatException catch (e) {
      AppLogger.error('Response format error: $e');
      throw const ServerException(
        message: 'Invalid response format from server.',
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        AppLogger.error('Request timed out');
        throw const TimeoutException();
      }
      AppLogger.error('Unexpected network error: $e');
      throw const ServerException();
    }
  }

  /// Maps HTTP status codes to appropriate exceptions.
  http.Response _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response;
      case 401:
        AppLogger.error('401 Unauthorized — check API key');
        throw const UnauthorizedException();
      case 404:
        AppLogger.error('404 Not Found');
        throw const NotFoundException();
      default:
        if (response.statusCode >= 500) {
          AppLogger.error('Server error: ${response.statusCode}');
          throw ServerException(statusCode: response.statusCode);
        }
        throw ApiException(
          message: 'Request failed with status ${response.statusCode}.',
          statusCode: response.statusCode,
        );
    }
  }

  /// Parses the `results` array from a TMDB paginated response.
  List<Movie> _parseMovieList(http.Response response) {
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final results = json['results'] as List<dynamic>? ?? [];
    return results
        .map((e) => Movie.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
