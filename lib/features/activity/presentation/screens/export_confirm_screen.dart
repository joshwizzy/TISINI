import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_radii.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/activity/domain/entities/export_state.dart';
import 'package:tisini/features/activity/providers/export_controller.dart';

class ExportConfirmScreen extends ConsumerStatefulWidget {
  const ExportConfirmScreen({super.key});

  @override
  ConsumerState<ExportConfirmScreen> createState() =>
      _ExportConfirmScreenState();
}

class _ExportConfirmScreenState extends ConsumerState<ExportConfirmScreen> {
  @override
  void initState() {
    super.initState();
    ref.listenManual(exportControllerProvider, (_, next) {
      final state = next.valueOrNull;
      if (state is ExportSuccess && mounted) {
        context.pushNamed(RouteNames.exportSuccess);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final exportAsync = ref.watch(exportControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Export')),
      body: exportAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (state) {
          if (state is ExportExporting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is! ExportConfirming) {
            return const Center(child: Text('No export data'));
          }
          return _buildContent(state);
        },
      ),
    );
  }

  Widget _buildContent(ExportConfirming confirming) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final start = dateFormat.format(confirming.startDate);
    final end = dateFormat.format(confirming.endDate);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: AppRadii.cardBorder,
              boxShadow: AppShadows.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Export Summary', style: AppTypography.titleMedium),
                const SizedBox(height: AppSpacing.md),
                _summaryRow('Period', '$start - $end'),
                _summaryRow('Estimated rows', '${confirming.estimatedRows}'),
                _summaryRow('Format', 'CSV'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const Icon(
                PhosphorIconsBold.info,
                size: 16,
                color: AppColors.cyan,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Your export will be ready to download '
                  'shortly.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                ref
                    .read(exportControllerProvider.notifier)
                    .confirmExport(
                      startDate: confirming.startDate,
                      endDate: confirming.endDate,
                    );
              },
              child: const Text('Export'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMedium),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
