import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_state.dart';
import 'package:tisini/features/bulk_import/presentation/widgets/import_progress_bar.dart';
import 'package:tisini/features/bulk_import/providers/import_controller.dart';

class ImportProgressScreen extends ConsumerWidget {
  const ImportProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(importControllerProvider, (prev, next) {
      final val = next.valueOrNull;
      if (val is ImportCompleted) {
        context.goNamed(RouteNames.importResult);
      } else if (val is ImportFailed) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(val.message)));
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Importing'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_upload_outlined,
              size: 64,
              color: AppColors.darkBlue,
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Processing your import',
              style: AppTypography.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'This may take a moment...',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
            ),
            const SizedBox(height: AppSpacing.xl),
            const ImportProgressBar(
              processedRows: 0,
              totalRows: 142,
              statusLabel: 'Processing',
            ),
          ],
        ),
      ),
    );
  }
}
