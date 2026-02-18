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

    test('pay branch has send sub-routes', () {
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

    test('pay branch has request sub-routes', () {
      final router = container.read(routerProvider);
      final config = router.configuration;

      final shellRoutes = config.routes
          .whereType<StatefulShellRoute>()
          .toList();
      final payBranch = shellRoutes.first.branches[1];
      final payRoute = payBranch.routes.first as GoRoute;
      final subPaths = payRoute.routes.whereType<GoRoute>().map((r) => r.path);

      expect(subPaths, contains('request/create'));
      expect(subPaths, contains('request/share/:id'));
      expect(subPaths, contains('request/status/:id'));
    });

    test('pay branch has scan sub-routes', () {
      final router = container.read(routerProvider);
      final config = router.configuration;

      final shellRoutes = config.routes
          .whereType<StatefulShellRoute>()
          .toList();
      final payBranch = shellRoutes.first.branches[1];
      final payRoute = payBranch.routes.first as GoRoute;
      final subPaths = payRoute.routes.whereType<GoRoute>().map((r) => r.path);

      expect(subPaths, contains('scan'));
      expect(subPaths, contains('scan/manual'));
      expect(subPaths, contains('scan/confirm'));
      expect(subPaths, contains('scan/receipt/:txId'));
    });

    test('pay branch has business pay sub-routes', () {
      final router = container.read(routerProvider);
      final config = router.configuration;

      final shellRoutes = config.routes
          .whereType<StatefulShellRoute>()
          .toList();
      final payBranch = shellRoutes.first.branches[1];
      final payRoute = payBranch.routes.first as GoRoute;
      final subPaths = payRoute.routes.whereType<GoRoute>().map((r) => r.path);

      expect(subPaths, contains('business/category'));
      expect(subPaths, contains('business/payee'));
      expect(subPaths, contains('business/confirm'));
      expect(subPaths, contains('business/receipt/:txId'));
    });

    test('pay branch has top up sub-routes', () {
      final router = container.read(routerProvider);
      final config = router.configuration;

      final shellRoutes = config.routes
          .whereType<StatefulShellRoute>()
          .toList();
      final payBranch = shellRoutes.first.branches[1];
      final payRoute = payBranch.routes.first as GoRoute;
      final subPaths = payRoute.routes.whereType<GoRoute>().map((r) => r.path);

      expect(subPaths, contains('topup/source'));
      expect(subPaths, contains('topup/amount'));
      expect(subPaths, contains('topup/confirm'));
      expect(subPaths, contains('topup/receipt/:txId'));
    });

    test('pay branch has exactly 21 sub-routes', () {
      final router = container.read(routerProvider);
      final config = router.configuration;

      final shellRoutes = config.routes
          .whereType<StatefulShellRoute>()
          .toList();
      final payBranch = shellRoutes.first.branches[1];
      final payRoute = payBranch.routes.first as GoRoute;

      // 6 send + 3 request + 4 scan + 4 business + 4 topup = 21
      expect(payRoute.routes.whereType<GoRoute>(), hasLength(21));
    });
  });
}
