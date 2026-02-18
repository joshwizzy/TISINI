import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/activity/domain/entities/export_state.dart';
import 'package:tisini/features/activity/providers/export_controller.dart';

class ExportSuccessScreen extends ConsumerWidget {
  const ExportSuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exportAsync = ref.watch(exportControllerProvider);

    return Scaffold(
      body: exportAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (state) {
          if (state is! ExportSuccess) {
            return const Center(child: Text('No export data'));
          }
          return _buildContent(context, ref, state);
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    ExportSuccess success,
  ) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                PhosphorIconsBold.check,
                size: 40,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text('Export ready', style: AppTypography.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Your CSV export has been generated.',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  // TODO(tisini): Implement download
                },
                icon: const Icon(PhosphorIconsBold.downloadSimple),
                label: const Text('Download'),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO(tisini): Implement share
                },
                icon: const Icon(PhosphorIconsBold.shareFat),
                label: const Text('Share'),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  ref.read(exportControllerProvider.notifier).reset();
                  context.goNamed(RouteNames.activityList);
                },
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
