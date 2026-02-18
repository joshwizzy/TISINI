import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tisini/core/storage/preferences.dart';
import 'package:tisini/features/onboarding/domain/entities/onboarding_page.dart';
import 'package:tisini/features/onboarding/providers/onboarding_provider.dart';

void main() {
  group('OnboardingNotifier', () {
    late Preferences preferences;
    late OnboardingNotifier notifier;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      preferences = Preferences(prefs: prefs);
      notifier = OnboardingNotifier(preferences: preferences);
    });

    test('initial state starts at page 0', () {
      expect(notifier.state.currentPage, 0);
      expect(notifier.state.totalPages, OnboardingPage.pages.length);
    });

    test('nextPage advances to next page', () {
      notifier.nextPage();
      expect(notifier.state.currentPage, 1);
    });

    test('nextPage does not go past last page', () {
      for (var i = 0; i < 10; i++) {
        notifier.nextPage();
      }
      expect(notifier.state.currentPage, OnboardingPage.pages.length - 1);
    });

    test('previousPage goes back', () {
      notifier
        ..nextPage()
        ..nextPage()
        ..previousPage();
      expect(notifier.state.currentPage, 1);
    });

    test('previousPage does not go before 0', () {
      notifier.previousPage();
      expect(notifier.state.currentPage, 0);
    });

    test('goToPage navigates to specific page', () {
      notifier.goToPage(2);
      expect(notifier.state.currentPage, 2);
    });

    test('goToPage ignores out of range index', () {
      notifier.goToPage(-1);
      expect(notifier.state.currentPage, 0);
      notifier.goToPage(10);
      expect(notifier.state.currentPage, 0);
    });

    test('isLastPage returns true on last page', () {
      expect(notifier.state.isLastPage, isFalse);
      for (var i = 0; i < OnboardingPage.pages.length - 1; i++) {
        notifier.nextPage();
      }
      expect(notifier.state.isLastPage, isTrue);
    });

    test('isFirstPage returns true on first page', () {
      expect(notifier.state.isFirstPage, isTrue);
      notifier.nextPage();
      expect(notifier.state.isFirstPage, isFalse);
    });

    test('completeOnboarding persists flag', () async {
      expect(preferences.hasSeenOnboarding, isFalse);
      await notifier.completeOnboarding();
      expect(preferences.hasSeenOnboarding, isTrue);
    });

    test('skipOnboarding persists flag', () async {
      expect(preferences.hasSeenOnboarding, isFalse);
      await notifier.skipOnboarding();
      expect(preferences.hasSeenOnboarding, isTrue);
    });
  });

  group('OnboardingPage', () {
    test('has 4 pages', () {
      expect(OnboardingPage.pages.length, 4);
    });

    test('all pages have non-empty title and body', () {
      for (final page in OnboardingPage.pages) {
        expect(page.title, isNotEmpty);
        expect(page.body, isNotEmpty);
        expect(page.assetPath, isNotEmpty);
      }
    });
  });
}
