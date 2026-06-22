import 'dart:developer' as developer;

/// Lightweight logging utility for the Flixora application.
///
/// Wraps [dart:developer] log with severity-level prefixes
/// and a consistent tag format for easy filtering in console output.
class AppLogger {
  AppLogger._();

  static const String _tag = 'Flixora';

  static void info(String message, {String? tag}) {
    developer.log(
      'INFO: $message',
      name: tag ?? _tag,
    );
  }

  static void debug(String message, {String? tag}) {
    developer.log(
      'DEBUG: $message',
      name: tag ?? _tag,
    );
  }

  static void warning(String message, {String? tag}) {
    developer.log(
      'WARNING: $message',
      name: tag ?? _tag,
    );
  }

  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      'ERROR: $message',
      name: tag ?? _tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void network(String message, {String? tag}) {
    developer.log(
      'NETWORK: $message',
      name: tag ?? _tag,
    );
  }

  static void database(String message, {String? tag}) {
    developer.log(
      'DATABASE: $message',
      name: tag ?? _tag,
    );
  }
}
