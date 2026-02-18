import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/core/providers/core_providers.dart';
import 'package:tisini/core/storage/preferences.dart';
import 'package:tisini/features/onboarding/domain/entities/onboarding_page.dart';

class OnboardingState {
  const OnboardingState({this.currentPage = 0, this.totalPages = 4});

  final int currentPage;
  final int totalPages;

  bool get isLastPage => currentPage == totalPages - 1;
  bool get isFirstPage => currentPage == 0;

  OnboardingState copyWith({int? currentPage}) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier({required Preferences preferences})
    : _preferences = preferences,
      super(OnboardingState(totalPages: OnboardingPage.pages.length));

  final Preferences _preferences;

  void nextPage() {
    if (!state.isLastPage) {
      state = state.copyWith(currentPage: state.currentPage + 1);
    }
  }

  void previousPage() {
    if (!state.isFirstPage) {
      state = state.copyWith(currentPage: state.currentPage - 1);
    }
  }

  void goToPage(int index) {
    if (index >= 0 && index < state.totalPages) {
      state = state.copyWith(currentPage: index);
    }
  }

  Future<void> completeOnboarding() async {
    await _preferences.setHasSeenOnboarding(value: true);
  }

  Future<void> skipOnboarding() async {
    await _preferences.setHasSeenOnboarding(value: true);
  }
}

final onboardingProvider =
    AutoDisposeStateNotifierProvider<OnboardingNotifier, OnboardingState>((
      ref,
    ) {
      final preferences = ref.watch(preferencesProvider);
      return OnboardingNotifier(preferences: preferences);
    });
