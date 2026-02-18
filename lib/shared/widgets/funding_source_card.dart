import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/funding_source.dart';

class FundingSourceCard extends StatelessWidget {
  const FundingSourceCard({
    required this.source,
    super.key,
    this.isSelected = false,
    this.onTap,
  });

  final FundingSource source;
  final bool isSelected;
  final VoidCallback? onTap;

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
    final borderColor = isSelected ? AppColors.darkBlue : AppColors.cardBorder;
    final opacity = source.isAvailable ? 1.0 : 0.5;

    return Opacity(
      opacity: opacity,
      child: ListTile(
        onTap: source.isAvailable ? onTap : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.darkBlue.withValues(alpha: 0.1),
          child: Icon(
            _railIcon(source.rail),
            color: AppColors.darkBlue,
            size: 20,
          ),
        ),
        title: Text(
          source.label,
          style: AppTypography.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            Icon(_railIcon(source.rail), size: 12, color: AppColors.grey),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                source.identifier,
                style: AppTypography.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        trailing: isSelected
            ? const Icon(
                PhosphorIconsBold.checkCircle,
                color: AppColors.darkBlue,
                size: 24,
              )
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderColor),
        ),
      ),
    );
  }
}
