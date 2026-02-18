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

    test('home branch has dashboard sub-route', () {
      final router = container.read(routerProvider);
      final config = router.configuration;

      final shellRoutes = config.routes
          .whereType<StatefulShellRoute>()
          .toList();
      final homeBranch = shellRoutes.first.branches.first;
      final homeRoute = homeBranch.routes.first as GoRoute;
      final subPaths = homeRoute.routes.whereType<GoRoute>().map((r) => r.path);

      expect(subPaths, contains('dashboard'));
      expect(subPaths, contains('attention'));
      expect(subPaths, contains('insight/:id'));
    });

    test('pay branch has 6 send sub-routes', () {
      final router = container.read(routerProvider);
      final config = router.configuration;

      final shellRoutes = config.routes
          .whereType<StatefulShellRoute>()
          .toList();
      final payBranch = shellRoutes.first.branches[1];
      final payRoute = payBranch.routes.first as GoRoute;
      final subPaths = payRoute.routes.whereType<GoRoute>().map((r) => r.path);

      expect(subPaths, contains('send/recipient'));
      expect(subPaths, contains('send/details'));
      expect(subPaths, contains('send/amount'));
      expect(subPaths, contains('send/confirm'));
      expect(subPaths, contains('send/receipt/:txId'));
      expect(subPaths, contains('send/failed'));
    });

    test('pay branch has exactly 6 sub-routes', () {
      final router = container.read(routerProvider);
      final config = router.configuration;

      final shellRoutes = config.routes
          .whereType<StatefulShellRoute>()
          .toList();
      final payBranch = shellRoutes.first.branches[1];
      final payRoute = payBranch.routes.first as GoRoute;

      expect(payRoute.routes.whereType<GoRoute>(), hasLength(6));
    });
  });
}
