import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_radii.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_state.dart';
import 'package:tisini/features/bulk_import/providers/import_controller.dart';

class ImportSourceScreen extends ConsumerWidget {
  const ImportSourceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(importControllerProvider, (prev, next) {
      final val = next.valueOrNull;
      if (val is ImportMapping_) {
        context.goNamed(RouteNames.importUpload);
      } else if (val is ImportFailed) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(val.message)));
      }
    });

    final stateAsync = ref.watch(importControllerProvider);
    final isUploading = stateAsync.valueOrNull is ImportUploading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Import Statements'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select source', style: AppTypography.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Choose the type of statement to import.',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
            ),
            const SizedBox(height: AppSpacing.lg),
            _SourceCard(
              icon: PhosphorIconsBold.bank,
              title: 'Bank Statement (CSV)',
              subtitle:
                  'Import from Stanbic, DFCU, '
                  'Equity, or Centenary',
              isLoading: isUploading,
              onTap: isUploading
                  ? null
                  : () => ref
                        .read(importControllerProvider.notifier)
                        .selectSource(ImportSource.bank),
            ),
            const SizedBox(height: AppSpacing.md),
            _SourceCard(
              icon: PhosphorIconsBold.deviceMobile,
              title: 'Mobile Money Statement',
              subtitle:
                  'Import from MTN MoMo '
                  'or Airtel Money',
              isLoading: isUploading,
              onTap: isUploading
                  ? null
                  : () => ref
                        .read(importControllerProvider.notifier)
                        .selectSource(ImportSource.mobileMoney),
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceCard extends StatelessWidget {
  const _SourceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isLoading,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isLoading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: AppRadii.cardBorder,
          border: Border.all(color: AppColors.darkBlue.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.darkBlue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.darkBlue, size: 28),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              const Icon(PhosphorIconsBold.caretRight, color: AppColors.grey),
          ],
        ),
      ),
    );
  }
}
