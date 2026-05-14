/// Base exception class for API-related errors in Flixora.
///
/// Extends [Exception] and provides a human-readable [message]
/// along with an optional HTTP [statusCode] for granular error handling.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'ApiException(statusCode: $statusCode, message: $message)';
}

/// Thrown when there is no internet connectivity.
class NetworkException extends ApiException {
  const NetworkException({
    super.message = 'No internet connection. Please check your network settings.',
  });
}

/// Thrown when a request exceeds the configured timeout duration.
class TimeoutException extends ApiException {
  const TimeoutException({
    super.message = 'Connection timed out. Please try again.',
  });
}

/// Thrown when the server returns an unexpected response.
class ServerException extends ApiException {
  const ServerException({
    super.message = 'Something went wrong on the server. Please try again later.',
    super.statusCode,
  });
}

/// Thrown when the requested resource is not found (404).
class NotFoundException extends ApiException {
  const NotFoundException({
    super.message = 'The requested resource was not found.',
    super.statusCode = 404,
  });
}

/// Thrown when the API key is invalid or missing (401).
class UnauthorizedException extends ApiException {
  const UnauthorizedException({
    super.message = 'Invalid or missing API key.',
    super.statusCode = 401,
  });
}

/// Thrown when local cache read/write operations fail.
class CacheException implements Exception {
  final String message;

  const CacheException({
    this.message = 'Failed to access local cache.',
  });

  @override
  String toString() => 'CacheException(message: $message)';
}
