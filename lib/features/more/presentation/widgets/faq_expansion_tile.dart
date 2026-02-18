import 'package:flutter/material.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/features/more/domain/entities/faq_item.dart';

class FaqExpansionTile extends StatelessWidget {
  const FaqExpansionTile({required this.faq, super.key});

  final FaqItem faq;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(faq.question, style: AppTypography.bodyMedium),
      tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      childrenPadding: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: AppSpacing.md,
      ),
      iconColor: AppColors.darkBlue,
      collapsedIconColor: AppColors.grey,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            faq.answer,
            style: AppTypography.bodySmall.copyWith(color: AppColors.grey),
          ),
        ),
      ],
    );
  }
}
