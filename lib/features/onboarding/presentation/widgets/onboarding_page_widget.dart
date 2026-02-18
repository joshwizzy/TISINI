import 'package:flutter/material.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/features/onboarding/domain/entities/onboarding_page.dart';

class OnboardingPageWidget extends StatelessWidget {
  const OnboardingPageWidget({required this.page, super.key});

  final OnboardingPage page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        children: [
          // 70% illustration area
          const Expanded(
            flex: 7,
            child: Center(
              // TODO(tisini): Replace with actual illustration
              child: Placeholder(strokeWidth: 1),
            ),
          ),
          // 30% text area
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    page.title,
                    style: AppTypography.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    page.body,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
