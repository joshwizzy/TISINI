import 'package:flutter/material.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_radii.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pia/domain/entities/pia_action.dart';
import 'package:tisini/features/pia/domain/entities/pia_card.dart';

class PiaCardWidget extends StatelessWidget {
  const PiaCardWidget({
    required this.card,
    super.key,
    this.isExpanded = false,
    this.onTap,
    this.onAction,
    this.onDismiss,
    this.onPin,
  });

  final PiaCard card;
  final bool isExpanded;
  final VoidCallback? onTap;
  final void Function(PiaAction action)? onAction;
  final VoidCallback? onDismiss;
  final VoidCallback? onPin;

  Color get _priorityColor => switch (card.priority) {
    PiaCardPriority.high => AppColors.zoneRed,
    PiaCardPriority.medium => AppColors.cyan,
    PiaCardPriority.low => AppColors.grey,
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: AppRadii.cardBorder,
          border: Border(left: BorderSide(color: _priorityColor, width: 4)),
          boxShadow: AppShadows.cardShadow,
        ),
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(card.title, style: AppTypography.titleMedium),
            const SizedBox(height: 4),
            Text(card.what, style: AppTypography.bodyMedium),
            if (isExpanded) ...[
              const SizedBox(height: 8),
              Text(
                card.why,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.darkBlue50,
                ),
              ),
              const SizedBox(height: 8),
              Text(card.details, style: AppTypography.bodySmall),
            ],
            if (card.actions.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: card.actions
                    .map(
                      (action) => _ActionButton(
                        action: action,
                        onTap: () => onAction?.call(action),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.action, this.onTap});

  final PiaAction action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        action.label,
        style: AppTypography.labelMedium.copyWith(color: AppColors.cyan),
      ),
    );
  }
}
