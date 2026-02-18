import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_flow_state.dart';
import 'package:tisini/features/kyc/presentation/widgets/document_thumbnail.dart';
import 'package:tisini/features/kyc/providers/kyc_flow_controller.dart';

class KycReviewScreen extends ConsumerWidget {
  const KycReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(kycFlowControllerProvider, (prev, next) {
      final val = next.valueOrNull;
      if (val is KycSuccess) {
        context.goNamed(RouteNames.kycPending);
      } else if (val is KycFailed) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(val.message)));
      }
    });

    final stateAsync = ref.watch(kycFlowControllerProvider);
    final state = stateAsync.valueOrNull;

    if (state is! KycCapturingDocuments) {
      final isSubmitting = state is KycSubmitting;
      return Scaffold(
        appBar: AppBar(title: const Text('Review')),
        body: Center(
          child: isSubmitting
              ? const CircularProgressIndicator()
              : const Text('Preparing review...'),
        ),
      );
    }

    final accountLabel = state.accountType == KycAccountType.business
        ? 'Business'
        : 'Gig Worker';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Review'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          const Text(
            'Review your submission',
            style: AppTypography.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Account type: $accountLabel', style: AppTypography.bodyMedium),
          const SizedBox(height: AppSpacing.lg),
          const Text('Documents', style: AppTypography.titleMedium),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: state.documents
                .map(
                  (doc) => DocumentThumbnail(type: doc.type, isCaptured: true),
                )
                .toList(),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: FilledButton(
            onPressed: () {
              ref.read(kycFlowControllerProvider.notifier).submitForReview();
            },
            child: const Text('Submit for review'),
          ),
        ),
      ),
    );
  }
}
