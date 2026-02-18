import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/errors/error_handler.dart';
import 'package:tisini/core/errors/exceptions.dart';

void main() {
  group('ErrorHandler.withRetry', () {
    test('returns result on first successful attempt', () async {
      final result = await ErrorHandler.withRetry(action: () async => 42);
      expect(result, 42);
    });

    test('retries on 5xx ServerException and succeeds', () async {
      var attempts = 0;
      final result = await ErrorHandler.withRetry(
        action: () async {
          attempts++;
          if (attempts < 3) {
            throw const ServerException(
              'Internal Server Error',
              statusCode: 500,
            );
          }
          return 'success';
        },
        initialDelay: const Duration(milliseconds: 1),
      );
      expect(result, 'success');
      expect(attempts, 3);
    });

    test('does not retry on 4xx ServerException', () async {
      await expectLater(
        () => ErrorHandler.withRetry(
          action: () async {
            throw const ServerException('Not Found', statusCode: 404);
          },
          initialDelay: const Duration(milliseconds: 1),
        ),
        throwsA(isA<ServerException>()),
      );
    });

    test('throws after max retries exceeded', () async {
      await expectLater(
        () => ErrorHandler.withRetry(
          action: () async {
            throw const ServerException(
              'Internal Server Error',
              statusCode: 500,
            );
          },
          maxRetries: 2,
          initialDelay: const Duration(milliseconds: 1),
        ),
        throwsA(isA<ServerException>()),
      );
    });

    test('does not retry non-ServerException', () async {
      await expectLater(
        () => ErrorHandler.withRetry(
          action: () async {
            throw const NoConnectionException();
          },
          initialDelay: const Duration(milliseconds: 1),
        ),
        throwsA(isA<NoConnectionException>()),
      );
    });
  });
}
