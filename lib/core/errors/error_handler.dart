import 'package:tisini/core/errors/exceptions.dart';

class ErrorHandler {
  /// Retry with exponential backoff for server errors (5xx).
  static Future<T> withRetry<T>({
    required Future<T> Function() action,
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 1),
  }) async {
    var delay = initialDelay;
    for (var attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        return await action();
      } on ServerException catch (e) {
        if (e.statusCode < 500 || attempt == maxRetries) rethrow;
        await Future<void>.delayed(delay);
        delay *= 2;
      }
    }
    throw const ServerException('Max retries exceeded', statusCode: 500);
  }
}
