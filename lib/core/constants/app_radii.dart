import 'package:flutter/material.dart';

abstract final class AppRadii {
  static const double card = 16;
  static const double cardSm = 14;
  static const double cardLg = 18;
  static const double pill = 999;
  static const double input = 12;
  static const double button = 12;
  static const double chip = 999;
  static const double modal = 24;

  static final BorderRadius cardBorder = BorderRadius.circular(card);
  static final BorderRadius pillBorder = BorderRadius.circular(pill);
  static final BorderRadius inputBorder = BorderRadius.circular(input);
  static final BorderRadius buttonBorder = BorderRadius.circular(button);
  static final BorderRadius modalBorder = BorderRadius.circular(modal);
}

abstract final class AppShadows {
  static const cardShadow = [
    BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2)),
  ];
}

abstract final class AppBorders {
  static const cardBorder = BorderSide(color: Color(0xFFE8EAED));
}
