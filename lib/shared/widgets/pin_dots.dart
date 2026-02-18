import 'package:flutter/material.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';

class PinDots extends StatelessWidget {
  const PinDots({required this.filledCount, this.hasError = false, super.key});

  final int filledCount;
  final bool hasError;

  static const _totalDots = 4;
  static const _dotSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_totalDots, (index) {
        final isFilled = index < filledCount;
        final isLast = index == _totalDots - 1;
        return Padding(
          padding: EdgeInsets.only(right: isLast ? 0 : AppSpacing.md),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: _dotSize,
            height: _dotSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _dotColor(isFilled),
              border: isFilled
                  ? null
                  : Border.all(
                      color: hasError ? AppColors.red : AppColors.grey,
                      width: 2,
                    ),
            ),
          ),
        );
      }),
    );
  }

  Color _dotColor(bool isFilled) {
    if (!isFilled) return Colors.transparent;
    if (hasError) return AppColors.red;
    return AppColors.darkBlue;
  }
}
