import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/features/auth/domain/entities/kyc_status.dart';

class KycStatusBanner extends StatelessWidget {
  const KycStatusBanner({
    required this.status,
    this.rejectionReason,
    super.key,
  });

  final KycStatus status;
  final String? rejectionReason;

  Color _backgroundColor(KycStatus status) {
    return switch (status) {
      KycStatus.approved => AppColors.success.withValues(alpha: 0.08),
      KycStatus.pending ||
      KycStatus.inProgress => AppColors.warning.withValues(alpha: 0.08),
      KycStatus.failed => AppColors.error.withValues(alpha: 0.08),
      KycStatus.notStarted => AppColors.darkBlue.withValues(alpha: 0.04),
    };
  }

  Color _foregroundColor(KycStatus status) {
    return switch (status) {
      KycStatus.approved => AppColors.success,
      KycStatus.pending || KycStatus.inProgress => AppColors.warning,
      KycStatus.failed => AppColors.error,
      KycStatus.notStarted => AppColors.grey,
    };
  }

  IconData _icon(KycStatus status) {
    return switch (status) {
      KycStatus.approved => PhosphorIconsBold.checkCircle,
      KycStatus.pending || KycStatus.inProgress => PhosphorIconsBold.clock,
      KycStatus.failed => PhosphorIconsBold.xCircle,
      KycStatus.notStarted => PhosphorIconsBold.info,
    };
  }

  String _label(KycStatus status) {
    return switch (status) {
      KycStatus.approved => 'Verified',
      KycStatus.pending => 'Pending review',
      KycStatus.inProgress => 'In progress',
      KycStatus.failed => 'Verification failed',
      KycStatus.notStarted => 'Not started',
    };
  }

  @override
  Widget build(BuildContext context) {
    final fg = _foregroundColor(status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: _backgroundColor(status),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(_icon(status), color: fg, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _label(status),
                  style: AppTypography.labelLarge.copyWith(color: fg),
                ),
                if (rejectionReason != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    rejectionReason!,
                    style: AppTypography.bodySmall.copyWith(
                      color: fg.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
