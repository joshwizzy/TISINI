import 'package:flutter/material.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_radii.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pensions/domain/entities/pension_status.dart';

class PensionStatusCard extends StatelessWidget {
  const PensionStatusCard({required this.status, super.key, this.onConnect});

  final PensionStatus status;
  final VoidCallback? onConnect;

  Color _badgeColor(PensionLinkStatus linkStatus) {
    return switch (linkStatus) {
      PensionLinkStatus.linked => AppColors.success,
      PensionLinkStatus.verifying => AppColors.warning,
      PensionLinkStatus.notLinked => AppColors.error,
    };
  }

  String _badgeLabel(PensionLinkStatus linkStatus) {
    return switch (linkStatus) {
      PensionLinkStatus.linked => 'Linked',
      PensionLinkStatus.verifying => 'Verifying',
      PensionLinkStatus.notLinked => 'Not Linked',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('NSSF Account', style: AppTypography.titleMedium),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: _badgeColor(status.linkStatus).withValues(alpha: 0.1),
                  borderRadius: AppRadii.pillBorder,
                ),
                child: Text(
                  _badgeLabel(status.linkStatus),
                  style: AppTypography.labelSmall.copyWith(
                    color: _badgeColor(status.linkStatus),
                  ),
                ),
              ),
            ],
          ),
          if (status.nssfNumber != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              status.nssfNumber!,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
            ),
          ],
          if (status.linkStatus == PensionLinkStatus.notLinked &&
              onConnect != null) ...[
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onConnect,
                child: const Text('Connect NSSF'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
