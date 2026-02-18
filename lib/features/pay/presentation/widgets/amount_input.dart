import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';

class AmountInput extends StatelessWidget {
  const AmountInput({
    required this.controller,
    required this.currency,
    super.key,
    this.onChanged,
  });

  final TextEditingController controller;
  final String currency;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          currency,
          style: AppTypography.bodySmall.copyWith(color: AppColors.grey),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: AppTypography.amountLarge.copyWith(fontSize: 40),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: '0',
            hintStyle: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: AppColors.grey,
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
