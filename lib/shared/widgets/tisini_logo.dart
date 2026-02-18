import 'package:flutter/material.dart';
import 'package:tisini/core/constants/app_colors.dart';

// TODO(tisini): Replace with SVG asset
class TisiniLogo extends StatelessWidget {
  const TisiniLogo({this.size = 48, this.isDark = false, super.key});

  final double size;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Text(
      'tisini',
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: size,
        fontWeight: FontWeight.w700,
        letterSpacing: -1,
        color: isDark ? AppColors.white : AppColors.darkBlue,
      ),
    );
  }
}
