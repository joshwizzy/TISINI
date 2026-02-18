import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tisini/core/providers/core_providers.dart';
import 'package:tisini/core/router/app_router.dart';
import 'package:tisini/core/storage/preferences.dart';
import 'package:tisini/core/storage/secure_storage.dart';

class MockSecureStorage extends Mock implements SecureStorage {}

void main() {
  group('routerProvider', () {
    late ProviderContainer container;
    late MockSecureStorage mockStorage;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final preferences = Preferences(prefs: prefs);
      mockStorage = MockSecureStorage();

      container = ProviderContainer(
        overrides: [
          preferencesProvider.overrideWithValue(preferences),
          secureStorageProvider.overrideWithValue(mockStorage),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('creates GoRouter instance', () {
      final router = container.read(routerProvider);
      expect(router, isA<GoRouter>());
    });

    test('initial location is /', () {
      final router = container.read(routerProvider);
      expect(router.routeInformationProvider.value.uri.path, '/');
    });

    test('has pre-auth routes registered', () {
      final router = container.read(routerProvider);
      final config = router.configuration;
      final paths = <String>[];

      for (final route in config.routes) {
        if (route is GoRoute) {
          paths.add(route.path);
        }
      }

      expect(paths, contains('/'));
      expect(paths, contains('/onboarding'));
      expect(paths, contains('/login'));
      expect(paths, contains('/otp'));
      expect(paths, contains('/create-pin'));
      expect(paths, contains('/permissions'));
    });

    test('has shell route with 5 branches', () {
      final router = container.read(routerProvider);
      final config = router.configuration;

      final shellRoutes = config.routes
          .whereType<StatefulShellRoute>()
          .toList();

      expect(shellRoutes, hasLength(1));

      // The StatefulShellRoute's branches contain the
      // 5 tabs
      final branches = shellRoutes.first.branches;
      expect(branches, hasLength(5));
    });
  });
}
