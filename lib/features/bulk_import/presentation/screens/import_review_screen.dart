import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_state.dart';
import 'package:tisini/features/bulk_import/providers/import_controller.dart';

class ImportReviewScreen extends ConsumerWidget {
  const ImportReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(importControllerProvider, (prev, next) {
      final val = next.valueOrNull;
      if (val is ImportProcessing) {
        context.goNamed(RouteNames.importProgress);
      }
    });

    final stateAsync = ref.watch(importControllerProvider);
    final reviewing = stateAsync.valueOrNull;

    if (reviewing is! ImportReviewing) {
      return Scaffold(
        appBar: AppBar(title: const Text('Review Import')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Review Import'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          const Text('Import summary', style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          _StatRow(label: 'Total rows', value: '${reviewing.totalRows}'),
          _StatRow(
            label: 'Auto-categorised',
            value: '${reviewing.autoCategorised}',
            valueColor: AppColors.success,
          ),
          _StatRow(
            label: 'Uncategorised',
            value: '${reviewing.uncategorised}',
            valueColor: AppColors.warning,
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text('Column mapping', style: AppTypography.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          _MappingRow(label: 'Date', column: reviewing.mapping.dateColumn),
          _MappingRow(label: 'Amount', column: reviewing.mapping.amountColumn),
          _MappingRow(
            label: 'Merchant',
            column: reviewing.mapping.merchantColumn,
          ),
          _MappingRow(
            label: 'Reference',
            column: reviewing.mapping.referenceColumn,
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: FilledButton(
            onPressed: () {
              ref.read(importControllerProvider.notifier).startProcessing();
            },
            child: const Text('Import'),
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMedium),
          Text(
            value,
            style: AppTypography.titleMedium.copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}

class _MappingRow extends StatelessWidget {
  const _MappingRow({required this.label, required this.column});

  final String label;
  final String column;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
          ),
          Text(column, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}
