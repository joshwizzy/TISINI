import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tisini/core/providers/core_providers.dart';
import 'package:tisini/core/storage/preferences.dart';
import 'package:tisini/features/onboarding/domain/entities/onboarding_page.dart';
import 'package:tisini/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:tisini/features/onboarding/presentation/widgets/dot_indicator.dart';
import 'package:tisini/shared/widgets/primary_button.dart';

void main() {
  late Preferences preferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    preferences = Preferences(prefs: prefs);
  });

  Widget buildApp() {
    return ProviderScope(
      overrides: [preferencesProvider.overrideWithValue(preferences)],
      child: const MaterialApp(home: OnboardingScreen()),
    );
  }

  group('OnboardingScreen', () {
    testWidgets('displays first page content', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text(OnboardingPage.pages[0].title), findsOneWidget);
    });

    testWidgets('displays Skip button', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Skip'), findsOneWidget);
    });

    testWidgets('displays Continue button', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('displays dot indicator', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(DotIndicator), findsOneWidget);
    });

    testWidgets('has 4 pages in PageView', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('displays PrimaryButton', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(PrimaryButton), findsOneWidget);
    });
  });
}
