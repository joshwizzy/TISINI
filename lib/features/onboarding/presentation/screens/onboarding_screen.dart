import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/features/onboarding/domain/entities/onboarding_page.dart';
import 'package:tisini/features/onboarding/presentation/widgets/dot_indicator.dart';
import 'package:tisini/features/onboarding/presentation/widgets/onboarding_page_widget.dart';
import 'package:tisini/features/onboarding/providers/onboarding_provider.dart';
import 'package:tisini/shared/widgets/primary_button.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onSkip() {
    ref.read(onboardingProvider.notifier).skipOnboarding();
    context.go('/login');
  }

  void _onContinue() {
    final state = ref.read(onboardingProvider);
    if (state.isLastPage) {
      ref.read(onboardingProvider.notifier).completeOnboarding();
      context.go('/login');
    } else {
      final nextPage = state.currentPage + 1;
      ref.read(onboardingProvider.notifier).goToPage(nextPage);
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: TextButton(
                  onPressed: _onSkip,
                  child: Text(
                    'Skip',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ),
            ),
            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: OnboardingPage.pages.length,
                onPageChanged: (index) {
                  ref.read(onboardingProvider.notifier).goToPage(index);
                },
                itemBuilder: (_, index) =>
                    OnboardingPageWidget(page: OnboardingPage.pages[index]),
              ),
            ),
            // Dot indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: DotIndicator(
                count: state.totalPages,
                currentIndex: state.currentPage,
              ),
            ),
            // Continue button
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                0,
                AppSpacing.screenPadding,
                AppSpacing.lg,
              ),
              child: PrimaryButton(
                label: state.isLastPage ? 'Get started' : 'Continue',
                onPressed: _onContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
