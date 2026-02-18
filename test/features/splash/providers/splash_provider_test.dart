import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tisini/core/providers/core_providers.dart';
import 'package:tisini/core/storage/preferences.dart';
import 'package:tisini/core/storage/secure_storage.dart';
import 'package:tisini/features/splash/providers/splash_provider.dart';

class MockSecureStorage extends Mock implements SecureStorage {}

void main() {
  group('splashTargetRouteProvider', () {
    late MockSecureStorage mockStorage;

    setUp(() {
      mockStorage = MockSecureStorage();
    });

    Future<String> getTargetRoute({
      String? accessToken,
      String? refreshToken,
      bool hasSeenOnboarding = false,
    }) async {
      SharedPreferences.setMockInitialValues(
        hasSeenOnboarding ? {'has_seen_onboarding': true} : {},
      );
      final prefs = await SharedPreferences.getInstance();
      final preferences = Preferences(prefs: prefs);

      when(
        () => mockStorage.getAccessToken(),
      ).thenAnswer((_) async => accessToken);
      when(
        () => mockStorage.getRefreshToken(),
      ).thenAnswer((_) async => refreshToken);

      final container = ProviderContainer(
        overrides: [
          secureStorageProvider.overrideWithValue(mockStorage),
          preferencesProvider.overrideWithValue(preferences),
        ],
      );
      addTearDown(container.dispose);

      return container.read(splashTargetRouteProvider.future);
    }

    test('returns /home when tokens exist', () async {
      final route = await getTargetRoute(
        accessToken: 'access-token',
        refreshToken: 'refresh-token',
      );
      expect(route, '/home');
    });

    test('returns /onboarding for first launch', () async {
      final route = await getTargetRoute();
      expect(route, '/onboarding');
    });

    test('returns /login for returning user without tokens', () async {
      final route = await getTargetRoute(hasSeenOnboarding: true);
      expect(route, '/login');
    });

    test('returns /onboarding when only access token exists', () async {
      final route = await getTargetRoute(accessToken: 'access-only');
      expect(route, '/onboarding');
    });
  });
}
