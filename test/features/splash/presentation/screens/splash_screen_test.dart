import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/features/splash/presentation/screens/splash_screen.dart';
import 'package:tisini/features/splash/providers/splash_provider.dart';
import 'package:tisini/shared/widgets/tisini_logo.dart';

void main() {
  group('SplashScreen', () {
    testWidgets('displays TisiniLogo centered', (tester) async {
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
          GoRoute(path: '/home', builder: (_, __) => const Scaffold()),
          GoRoute(path: '/onboarding', builder: (_, __) => const Scaffold()),
          GoRoute(path: '/login', builder: (_, __) => const Scaffold()),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            splashTargetRouteProvider.overrideWith((ref) async => '/home'),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );

      // Verify logo is shown initially
      expect(find.byType(TisiniLogo), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);

      // Pump through the 1.5s delay and navigation
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
    });
  });
}
