import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_radii.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';

class PayeeCard extends StatelessWidget {
  const PayeeCard({required this.payee, super.key, this.onTap, this.trailing});

  final Payee payee;
  final VoidCallback? onTap;
  final Widget? trailing;

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  IconData _railIcon(PaymentRail rail) {
    return switch (rail) {
      PaymentRail.bank => PhosphorIconsBold.bank,
      PaymentRail.mobileMoney => PhosphorIconsBold.deviceMobile,
      PaymentRail.card => PhosphorIconsBold.creditCard,
      PaymentRail.wallet => PhosphorIconsBold.wallet,
    };
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: AppColors.darkBlue.withValues(alpha: 0.1),
        backgroundImage: payee.avatarUrl != null
            ? NetworkImage(payee.avatarUrl!)
            : null,
        child: payee.avatarUrl == null
            ? Text(
                _initials(payee.name),
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.darkBlue,
                ),
              )
            : null,
      ),
      title: Text(
        payee.name,
        style: AppTypography.titleMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        children: [
          Icon(_railIcon(payee.rail), size: 12, color: AppColors.grey),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              payee.identifier,
              style: AppTypography.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      trailing:
          trailing ??
          (payee.isPinned
              ? Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                  ),
                  child: const Icon(
                    PhosphorIconsBold.pushPin,
                    size: 14,
                    color: AppColors.darkBlue,
                  ),
                )
              : null),
    );
  }
}
