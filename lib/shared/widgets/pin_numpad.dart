import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';

class PinNumpad extends StatelessWidget {
  const PinNumpad({
    required this.onDigit,
    required this.onBackspace,
    this.isEnabled = true,
    super.key,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRow(['1', '2', '3']),
        const SizedBox(height: AppSpacing.md),
        _buildRow(['4', '5', '6']),
        const SizedBox(height: AppSpacing.md),
        _buildRow(['7', '8', '9']),
        const SizedBox(height: AppSpacing.md),
        _buildRow(['', '0', 'backspace']),
      ],
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map(_buildKey).toList(),
    );
  }

  Widget _buildKey(String key) {
    if (key.isEmpty) {
      return const SizedBox(width: 72, height: 72);
    }

    if (key == 'backspace') {
      return SizedBox(
        width: 72,
        height: 72,
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: isEnabled ? onBackspace : null,
            child: Center(
              child: Icon(
                PhosphorIconsBold.backspace,
                size: 24,
                color: isEnabled ? AppColors.darkBlue : AppColors.grey,
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: 72,
      height: 72,
      child: Material(
        color: AppColors.background,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isEnabled ? () => onDigit(key) : null,
          child: Center(
            child: Text(
              key,
              style: AppTypography.headlineLarge.copyWith(
                color: isEnabled ? AppColors.darkBlue : AppColors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
