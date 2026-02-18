import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_state.dart';
import 'package:tisini/features/bulk_import/presentation/widgets/import_summary_card.dart';
import 'package:tisini/features/bulk_import/providers/import_controller.dart';

class ImportResultScreen extends ConsumerWidget {
  const ImportResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(importControllerProvider);
    final completed = stateAsync.valueOrNull;

    if (completed is! ImportCompleted) {
      return Scaffold(
        appBar: AppBar(title: const Text('Import Result')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final result = completed.result;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Import Complete'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          const SizedBox(height: AppSpacing.lg),
          const Icon(
            PhosphorIconsBold.checkCircle,
            size: 64,
            color: AppColors.success,
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Import complete',
            style: AppTypography.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          ImportSummaryCard(result: result),
          if (result.errors.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            const Text('Errors', style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            ...result.errors.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      PhosphorIconsBold.warningCircle,
                      size: 16,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        e,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.goNamed(RouteNames.activityList),
                  child: const Text('Review transactions'),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(importControllerProvider.notifier).reset();
                    context.goNamed(RouteNames.moreHub);
                  },
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
