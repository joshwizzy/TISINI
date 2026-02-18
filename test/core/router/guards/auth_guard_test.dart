import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/providers/auth_state_provider.dart';
import 'package:tisini/core/router/guards/auth_guard.dart';

void main() {
  group('authGuard', () {
    const unauthenticated = AuthState();
    const authenticated = AuthState(status: AuthStatus.authenticated);

    group('unauthenticated user', () {
      test('allows public paths', () {
        for (final path in publicPaths) {
          expect(
            authGuard(location: path, authState: unauthenticated),
            isNull,
            reason: 'Should allow $path',
          );
        }
      });

      test('redirects private paths to /login', () {
        const privatePaths = ['/home', '/pay', '/pia', '/activity', '/more'];
        for (final path in privatePaths) {
          expect(
            authGuard(location: path, authState: unauthenticated),
            '/login',
            reason: 'Should redirect $path to /login',
          );
        }
      });
    });

    group('authenticated user', () {
      test('allows splash path', () {
        expect(authGuard(location: '/', authState: authenticated), isNull);
      });

      test('redirects public paths (except /) to /home', () {
        const authPublicPaths = [
          '/onboarding',
          '/login',
          '/otp',
          '/create-pin',
          '/permissions',
        ];
        for (final path in authPublicPaths) {
          expect(
            authGuard(location: path, authState: authenticated),
            '/home',
            reason: 'Should redirect $path to /home',
          );
        }
      });

      test('allows private paths', () {
        const privatePaths = ['/home', '/pay', '/pia', '/activity', '/more'];
        for (final path in privatePaths) {
          expect(
            authGuard(location: path, authState: authenticated),
            isNull,
            reason: 'Should allow $path',
          );
        }
      });
    });
  });
}
