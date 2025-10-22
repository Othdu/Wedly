import 'package:flutter/material.dart';

/// Enhanced Theme Constants for WEDLY App
/// Provides comprehensive theme management with better organization
class AppThemeConstants {
  // Private constructor to prevent instantiation
  AppThemeConstants._();

  // ============================================================================
  // COLOR PALETTE
  // ============================================================================
  
  /// Primary Golden Colors
  static const Color primaryGolden = Color(0xFFD4AF37);
  static const Color primaryGoldenDark = Color(0xFFB8860B);
  static const Color primaryGoldenLight = Color(0xFFF4E4BC);
  
  /// Secondary Colors
  static const Color secondaryGold = Color(0xFFFFD700);
  static const Color accentGold = Color(0xFFFFA500);
  
  /// Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color mediumGray = Color(0xFFE0E0E0);
  static const Color darkGray = Color(0xFF757575);
  
  /// Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  
  /// Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  
  /// Background Colors
  static const Color backgroundPrimary = Color(0xFFFAFAFA);
  static const Color backgroundSecondary = Color(0xFFF0F0F0);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF8F8F8);
  
  /// Border Colors
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderMedium = Color(0xFFBDBDBD);
  static const Color borderDark = Color(0xFF757575);
  
  /// Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);
  static const Color goldenShadow = Color(0x33D4AF37);

  // ============================================================================
  // DIMENSIONS
  // ============================================================================
  
  /// Border Radius
  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;
  
  /// Spacing
  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  static const double spacingXXXL = 64.0;
  
  /// Font Sizes
  static const double fontSizeXS = 12.0;
  static const double fontSizeSM = 14.0;
  static const double fontSizeMD = 16.0;
  static const double fontSizeLG = 18.0;
  static const double fontSizeXL = 20.0;
  static const double fontSizeXXL = 24.0;
  static const double fontSizeXXXL = 32.0;
  
  /// Icon Sizes
  static const double iconSizeXS = 16.0;
  static const double iconSizeSM = 20.0;
  static const double iconSizeMD = 24.0;
  static const double iconSizeLG = 32.0;
  static const double iconSizeXL = 48.0;
  
  /// Elevation
  static const double elevationNone = 0.0;
  static const double elevationSM = 2.0;
  static const double elevationMD = 4.0;
  static const double elevationLG = 8.0;
  static const double elevationXL = 16.0;

  // ============================================================================
  // GRADIENTS
  // ============================================================================
  
  /// Primary Golden Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGoldenDark, primaryGolden],
  );
  
  /// Light Golden Gradient
  static const LinearGradient lightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryGoldenLight, white],
  );
  
  /// Background Gradient
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [surface, backgroundPrimary],
  );

  // ============================================================================
  // SHADOWS
  // ============================================================================
  
  /// Card Shadow
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: shadowLight,
      blurRadius: 8.0,
      offset: Offset(0, 2),
    ),
  ];
  
  /// Card Shadow Medium
  static const List<BoxShadow> cardShadowMedium = [
    BoxShadow(
      color: shadowMedium,
      blurRadius: 12.0,
      offset: Offset(0, 4),
    ),
  ];
  
  /// Card Shadow Large
  static const List<BoxShadow> cardShadowLarge = [
    BoxShadow(
      color: shadowDark,
      blurRadius: 16.0,
      offset: Offset(0, 8),
    ),
  ];
  
  /// Golden Shadow
  static const List<BoxShadow> goldenShadowEffect = [
    BoxShadow(
      color: goldenShadow,
      blurRadius: 12.0,
      offset: Offset(0, 4),
    ),
  ];

  // ============================================================================
  // TEXT STYLES
  // ============================================================================
  
  /// Display Text Styles
  static const TextStyle displayLarge = TextStyle(
    fontSize: fontSizeXXXL,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.2,
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontSize: fontSizeXXL,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.3,
  );
  
  static const TextStyle displaySmall = TextStyle(
    fontSize: fontSizeXL,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.4,
  );
  
  /// Headline Text Styles
  static const TextStyle headlineLarge = TextStyle(
    fontSize: fontSizeXXL,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.3,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontSize: fontSizeXL,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
  );
  
  static const TextStyle headlineSmall = TextStyle(
    fontSize: fontSizeLG,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
  );
  
  /// Title Text Styles
  static const TextStyle titleLarge = TextStyle(
    fontSize: fontSizeLG,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontSize: fontSizeMD,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
  );
  
  static const TextStyle titleSmall = TextStyle(
    fontSize: fontSizeSM,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
  );
  
  /// Body Text Styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: fontSizeMD,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: fontSizeSM,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: fontSizeXS,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.5,
  );
  
  /// Label Text Styles
  static const TextStyle labelLarge = TextStyle(
    fontSize: fontSizeMD,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    height: 1.4,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontSize: fontSizeSM,
    fontWeight: FontWeight.w500,
    color: textSecondary,
    height: 1.4,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontSize: fontSizeXS,
    fontWeight: FontWeight.w500,
    color: textSecondary,
    height: 1.4,
  );

  // ============================================================================
  // BUTTON STYLES
  // ============================================================================
  
  /// Primary Button Style
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: primaryGolden,
    foregroundColor: textOnPrimary,
    elevation: elevationSM,
    shadowColor: goldenShadow,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMD),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: spacingLG,
      vertical: spacingMD,
    ),
    textStyle: titleMedium,
  );
  
  /// Secondary Button Style
  static ButtonStyle get secondaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: surface,
    foregroundColor: primaryGolden,
    elevation: elevationSM,
    shadowColor: shadowLight,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMD),
      side: const BorderSide(color: primaryGolden),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: spacingLG,
      vertical: spacingMD,
    ),
    textStyle: titleMedium,
  );
  
  /// Text Button Style
  static ButtonStyle get textButtonStyle => TextButton.styleFrom(
    foregroundColor: primaryGolden,
    padding: const EdgeInsets.symmetric(
      horizontal: spacingMD,
      vertical: spacingSM,
    ),
    textStyle: labelLarge,
  );

  // ============================================================================
  // INPUT DECORATION STYLES
  // ============================================================================
  
  /// Primary Input Decoration
  static InputDecorationTheme get primaryInputDecoration => InputDecorationTheme(
    filled: true,
    fillColor: surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMD),
      borderSide: const BorderSide(color: borderLight),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMD),
      borderSide: const BorderSide(color: borderLight),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMD),
      borderSide: const BorderSide(color: primaryGolden, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMD),
      borderSide: const BorderSide(color: error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMD),
      borderSide: const BorderSide(color: error, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: spacingMD,
      vertical: spacingMD,
    ),
    labelStyle: labelMedium,
    hintStyle: bodyMedium.copyWith(color: textHint),
  );

  // ============================================================================
  // CARD STYLES
  // ============================================================================
  
  /// Primary Card Style
  static CardTheme get primaryCardTheme => CardTheme(
    color: surface,
    elevation: elevationSM,
    shadowColor: shadowLight,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusLG),
    ),
    margin: const EdgeInsets.all(spacingSM),
  );
  
  /// Elevated Card Style
  static CardTheme get elevatedCardTheme => CardTheme(
    color: surface,
    elevation: elevationMD,
    shadowColor: shadowMedium,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusLG),
    ),
    margin: const EdgeInsets.all(spacingSM),
  );

  // ============================================================================
  // APP BAR STYLES
  // ============================================================================
  
  /// Primary App Bar Theme
  static AppBarTheme get primaryAppBarTheme => const AppBarTheme(
    backgroundColor: primaryGolden,
    foregroundColor: textOnPrimary,
    elevation: elevationNone,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: textOnPrimary,
      fontSize: fontSizeXL,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: textOnPrimary,
      size: iconSizeMD,
    ),
  );

  // ============================================================================
  // DROPDOWN STYLES
  // ============================================================================
  
  /// Primary Dropdown Style
  static BoxDecoration get primaryDropdownDecoration => BoxDecoration(
    color: surfaceVariant,
    borderRadius: BorderRadius.circular(radiusMD),
    border: Border.all(color: borderLight),
  );
}
