import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';

class DocumentChecklistItem extends StatelessWidget {
  const DocumentChecklistItem({
    required this.type,
    required this.isCaptured,
    this.onTap,
    super.key,
  });

  final KycDocumentType type;
  final bool isCaptured;
  final VoidCallback? onTap;

  String _label(KycDocumentType type) {
    return switch (type) {
      KycDocumentType.idFront => 'ID Card (Front)',
      KycDocumentType.idBack => 'ID Card (Back)',
      KycDocumentType.selfie => 'Selfie',
      KycDocumentType.businessRegistration => 'Business Registration',
      KycDocumentType.licence => 'Licence',
      KycDocumentType.tin => 'TIN Certificate',
    };
  }

  IconData _icon(KycDocumentType type) {
    return switch (type) {
      KycDocumentType.idFront ||
      KycDocumentType.idBack => PhosphorIconsBold.identificationCard,
      KycDocumentType.selfie => PhosphorIconsBold.userCircle,
      KycDocumentType.businessRegistration => PhosphorIconsBold.buildings,
      KycDocumentType.licence => PhosphorIconsBold.certificate,
      KycDocumentType.tin => PhosphorIconsBold.fileText,
    };
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(_icon(type), color: AppColors.darkBlue, size: 24),
      title: Text(_label(type), style: AppTypography.bodyMedium),
      trailing: Icon(
        isCaptured ? PhosphorIconsBold.checkCircle : PhosphorIconsBold.circle,
        color: isCaptured ? AppColors.success : AppColors.grey,
        size: 24,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
    );
  }
}
