import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_flow_state.dart';
import 'package:tisini/features/kyc/presentation/widgets/kyc_status_banner.dart';
import 'package:tisini/features/kyc/providers/kyc_flow_controller.dart';
import 'package:tisini/features/kyc/providers/kyc_provider.dart';

class KycEntryScreen extends ConsumerWidget {
  const KycEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flowState = ref.watch(kycFlowControllerProvider);
    final submissionAsync = ref.watch(kycSubmissionStatusProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('KYC Verification'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          const Icon(
            PhosphorIconsBold.identificationCard,
            size: 64,
            color: AppColors.darkBlue,
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Verify your identity',
            style: AppTypography.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Complete identity verification to unlock '
            'all features including higher transaction '
            'limits and business payments.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          submissionAsync.when(
            data: (submission) {
              if (submission == null) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: KycStatusBanner(
                  status: submission.status,
                  rejectionReason: submission.rejectionReason,
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Verification powered by Tisini',
            style: AppTypography.bodySmall.copyWith(color: AppColors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: flowState.when(
            data: (state) => switch (state) {
              KycSuccess() => FilledButton(
                onPressed: () => context.goNamed(RouteNames.kycApproved),
                child: const Text('View status'),
              ),
              KycFailed() => FilledButton(
                onPressed: () {
                  ref.read(kycFlowControllerProvider.notifier).retry();
                  context.goNamed(RouteNames.kycAccountType);
                },
                child: const Text('Try again'),
              ),
              KycReviewing() => FilledButton(
                onPressed: () => context.goNamed(RouteNames.kycPending),
                child: const Text('View status'),
              ),
              _ => FilledButton(
                onPressed: () => context.goNamed(RouteNames.kycAccountType),
                child: const Text('Get started'),
              ),
            },
            loading: () =>
                const FilledButton(onPressed: null, child: Text('Loading...')),
            error: (_, __) => FilledButton(
              onPressed: () => context.goNamed(RouteNames.kycAccountType),
              child: const Text('Get started'),
            ),
          ),
        ),
      ),
    );
  }
}
