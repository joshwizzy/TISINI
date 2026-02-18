import 'package:flutter/material.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_radii.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.status, super.key});

  final PaymentStatus status;

  Color _statusColor() {
    return switch (status) {
      PaymentStatus.completed => AppColors.success,
      PaymentStatus.pending => AppColors.warning,
      PaymentStatus.processing => AppColors.cyan,
      PaymentStatus.failed => AppColors.error,
      PaymentStatus.reversed => AppColors.grey,
    };
  }

  String _statusLabel() {
    return switch (status) {
      PaymentStatus.completed => 'Completed',
      PaymentStatus.pending => 'Pending',
      PaymentStatus.processing => 'Processing',
      PaymentStatus.failed => 'Failed',
      PaymentStatus.reversed => 'Reversed',
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Text(
        _statusLabel(),
        style: AppTypography.labelSmall.copyWith(color: color),
      ),
    );
  }
}
