import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_radii.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';

class DocumentThumbnail extends StatelessWidget {
  const DocumentThumbnail({
    required this.type,
    required this.isCaptured,
    super.key,
  });

  final KycDocumentType type;
  final bool isCaptured;

  String _label(KycDocumentType type) {
    return switch (type) {
      KycDocumentType.idFront => 'ID Front',
      KycDocumentType.idBack => 'ID Back',
      KycDocumentType.selfie => 'Selfie',
      KycDocumentType.businessRegistration => 'Business Reg.',
      KycDocumentType.licence => 'Licence',
      KycDocumentType.tin => 'TIN',
    };
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 140,
      child: Container(
        decoration: BoxDecoration(
          color: isCaptured
              ? AppColors.success.withValues(alpha: 0.08)
              : AppColors.darkBlue.withValues(alpha: 0.04),
          borderRadius: AppRadii.cardBorder,
          border: Border.all(
            color: isCaptured
                ? AppColors.success.withValues(alpha: 0.3)
                : AppColors.grey.withValues(alpha: 0.3),
            style: isCaptured ? BorderStyle.solid : BorderStyle.none,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCaptured
                  ? PhosphorIconsBold.checkCircle
                  : PhosphorIconsBold.camera,
              size: 32,
              color: isCaptured ? AppColors.success : AppColors.grey,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              _label(type),
              style: AppTypography.labelSmall.copyWith(
                color: isCaptured ? AppColors.success : AppColors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
