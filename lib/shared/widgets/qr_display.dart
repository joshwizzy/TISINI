import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_radii.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';

class QrDisplay extends StatelessWidget {
  const QrDisplay({required this.data, super.key});

  final String data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          decoration: BoxDecoration(
            color: AppColors.cardWhite,
            borderRadius: AppRadii.cardBorder,
            boxShadow: AppShadows.cardShadow,
          ),
          child: QrImageView(
            data: data,
            size: 200,
            backgroundColor: Colors.white,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          data,
          style: AppTypography.bodySmall.copyWith(color: AppColors.grey),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
