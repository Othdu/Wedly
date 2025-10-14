import 'package:flutter/material.dart';

/// Responsive helpers built on top of MediaQuery
class Responsive {
  const Responsive._();

  // Screen sizes
  static Size screenSize(BuildContext context) => MediaQuery.of(context).size;
  static double screenWidth(BuildContext context) => screenSize(context).width;
  static double screenHeight(BuildContext context) => screenSize(context).height;

  // Percentage width/height
  static double wp(BuildContext context, double percent) => screenWidth(context) * percent;
  static double hp(BuildContext context, double percent) => screenHeight(context) * percent;

  // Breakpoints (tweak as needed)
  static bool isSmall(BuildContext context) => screenWidth(context) < 360;
  static bool isCompact(BuildContext context) => screenWidth(context) < 480;
  static bool isMedium(BuildContext context) => screenWidth(context) >= 480 && screenWidth(context) < 900;
  static bool isLarge(BuildContext context) => screenWidth(context) >= 900 && screenWidth(context) < 1200;
  static bool isXLarge(BuildContext context) => screenWidth(context) >= 1200;

  // Dynamic grid columns
  static int gridColumns(BuildContext context, {int small = 2, int medium = 3, int large = 4, int xlarge = 5}) {
    final double w = screenWidth(context);
    if (w >= 1200) return xlarge;
    if (w >= 900) return large;
    if (w >= 600) return medium;
    return small;
  }

  // Aspect ratio helper for grid items
  static double gridAspect(BuildContext context, {double small = 0.85, double medium = 0.9, double large = 0.95}) {
    final double w = screenWidth(context);
    if (w >= 1200) return large;
    if (w >= 900) return medium;
    return small;
  }

  // Responsive padding scale (baseSpacing in pixels)
  static EdgeInsets symmetricPadding(BuildContext context, {double base = 16}) {
    final double w = screenWidth(context);
    final double factor = w >= 1200 ? 1.5 : w >= 900 ? 1.25 : w >= 600 ? 1.0 : 0.85;
    final double value = base * factor;
    return EdgeInsets.symmetric(horizontal: value, vertical: value * 0.75);
  }

  // Responsive font scaling around a base size
  static double font(BuildContext context, double base) {
    final double w = screenWidth(context);
    final double factor = w >= 1200 ? 1.2 : w >= 900 ? 1.1 : w >= 600 ? 1.0 : 0.95;
    return base * factor;
  }
}


