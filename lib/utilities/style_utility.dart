import 'package:flutter/material.dart';
import 'package:jnb_mobile/utilities/color_utility.dart';

class AppStyles {
  static const double defaultPadding = 18.0;

  static BorderRadius defaultBorderRadius = BorderRadius.circular(20);

  static ScrollbarThemeData scrollbarTheme =
      const ScrollbarThemeData().copyWith(
    thumbColor: MaterialStateProperty.all(AppColors.defaultYellowColor),
    thumbVisibility: MaterialStateProperty.all(false),
    interactive: true,
  );
}