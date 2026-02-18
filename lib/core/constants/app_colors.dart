import 'dart:ui';

abstract final class AppColors {
  // Brand Primary
  static const darkBlue = Color(0xFF243452);
  static const green = Color(0xFF0AF5B4);
  static const cyan = Color(0xFF0098FF);
  static const red = Color(0xFFFF005C);

  // Neutrals
  static const grey = Color(0xFFA3AAB6);
  static const background = Color(0xFFF7F8FA);
  static const cardWhite = Color(0xFFFFFFFF);
  static const black = Color(0xFF1A1A1A);
  static const white = Color(0xFFFFFFFF);

  // Semantic
  static const success = green;
  static const error = red;
  static const info = cyan;
  static const warning = Color(0xFFFFA726);

  // Card border
  static const cardBorder = Color(0xFFE8EAED);

  // tisini index zones
  static const zoneRed = red;
  static const zoneAmber = Color(0xFFFFA726);
  static const zoneGreen = green;

  // Opacity variants
  static final darkBlue10 = darkBlue.withValues(alpha: 0.1);
  static final darkBlue50 = darkBlue.withValues(alpha: 0.5);
  static final grey40 = grey.withValues(alpha: 0.4);
}
