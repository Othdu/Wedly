import 'package:flutter/material.dart';

/// WEDLY App Colors - Exact match to web application
/// Golden luxury theme with Arabic RTL support
class AppColors {
  // Primary Golden Colors (EXACT MATCH)
  static const Color primaryGolden = Color(0xFFD6B45A); // hsl(43, 56%, 58%)
  static const Color goldenLight = Color(0xFFF3DE96); // hsl(43, 56%, 90%)
  static const Color goldenDark = Color(0xFFA17D3B); // hsl(43, 56%, 35%)
  
  // Golden Gradient Colors
  static const Color goldenGradientStart = Color(0xFFD6B45A);
  static const Color goldenGradientEnd = Color(0xFFE8C878);
  
  // Luxury Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF7F7F7);
  static const Color darkGray = Color(0xFF2E2E2E);
  static const Color black = Color(0xFF1D1D1D);
  
  // Shadow Colors
  static const Color goldenShadow = Color(0x4DD6B45A); // rgba(214, 180, 90, 0.3)
  static const Color cardShadow = Color(0x1A000000); // rgba(0, 0, 0, 0.1)
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF2E2E2E);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textLight = Color(0xFF999999);
  static const Color textOnGolden = Color(0xFFFFFFFF);
  
  // Background Colors
  static const Color backgroundPrimary = Color(0xFFFFFFFF);
  static const Color backgroundSecondary = Color(0xFFF7F7F7);
  static const Color backgroundDark = Color(0xFF1D1D1D);
  
  // Border Colors
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderGolden = Color(0xFFD6B45A);
  static const Color borderDark = Color(0xFF2E2E2E);
  
  // Gradient Definitions
  static const LinearGradient goldenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldenGradientStart, goldenGradientEnd],
  );
  
  static const LinearGradient goldenGradientVertical = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [goldenGradientStart, goldenGradientEnd],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [white, lightGray],
  );
  
  // Box Shadow Definitions
  static const List<BoxShadow> goldenShadowSmall = [
    BoxShadow(
      color: goldenShadow,
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
  
  static const List<BoxShadow> goldenShadowMedium = [
    BoxShadow(
      color: goldenShadow,
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];
  
  static const List<BoxShadow> goldenShadowLarge = [
    BoxShadow(
      color: goldenShadow,
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];
  
  static const List<BoxShadow> cardShadowSmall = [
    BoxShadow(
      color: cardShadow,
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
  
  static const List<BoxShadow> cardShadowMedium = [
    BoxShadow(
      color: cardShadow,
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];
}