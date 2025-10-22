import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import 'app_theme_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppThemeConstants.primaryGolden,
        secondary: AppThemeConstants.secondaryGold,
        surface: AppThemeConstants.surface,
        background: AppThemeConstants.backgroundPrimary,
        error: AppThemeConstants.error,
        onPrimary: AppThemeConstants.textOnPrimary,
        onSecondary: AppThemeConstants.textPrimary,
        onSurface: AppThemeConstants.textPrimary,
        onBackground: AppThemeConstants.textPrimary,
        onError: AppThemeConstants.textOnPrimary,
        outline: AppThemeConstants.borderLight,
        surfaceVariant: AppThemeConstants.surfaceVariant,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: AppThemeConstants.backgroundPrimary,
      
      // App Bar
      appBarTheme: AppThemeConstants.primaryAppBarTheme,
      
      // Card
      cardTheme: AppThemeConstants.primaryCardTheme,
      
      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: AppThemeConstants.primaryButtonStyle,
      ),
      
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: AppThemeConstants.textButtonStyle,
      ),
      
      // Input Decoration
      inputDecorationTheme: AppThemeConstants.primaryInputDecoration,
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: AppThemeConstants.displayLarge,
        displayMedium: AppThemeConstants.displayMedium,
        displaySmall: AppThemeConstants.displaySmall,
        headlineLarge: AppThemeConstants.headlineLarge,
        headlineMedium: AppThemeConstants.headlineMedium,
        headlineSmall: AppThemeConstants.headlineSmall,
        titleLarge: AppThemeConstants.titleLarge,
        titleMedium: AppThemeConstants.titleMedium,
        titleSmall: AppThemeConstants.titleSmall,
        bodyLarge: AppThemeConstants.bodyLarge,
        bodyMedium: AppThemeConstants.bodyMedium,
        bodySmall: AppThemeConstants.bodySmall,
        labelLarge: AppThemeConstants.labelLarge,
        labelMedium: AppThemeConstants.labelMedium,
        labelSmall: AppThemeConstants.labelSmall,
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppThemeConstants.surface,
        selectedItemColor: AppThemeConstants.primaryGolden,
        unselectedItemColor: AppThemeConstants.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: AppThemeConstants.elevationLG,
      ),
      
      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppThemeConstants.primaryGolden;
          }
          return AppThemeConstants.textSecondary;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppThemeConstants.primaryGolden.withOpacity(0.3);
          }
          return AppThemeConstants.surfaceVariant;
        }),
      ),
      
      // Dropdown Theme
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: MaterialStateProperty.all(AppThemeConstants.surface),
          elevation: MaterialStateProperty.all(AppThemeConstants.elevationMD),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppThemeConstants.radiusMD),
            ),
          ),
        ),
        textStyle: AppThemeConstants.bodyMedium,
      ),
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryGolden,
        secondary: AppColors.goldenLight,
        surface: AppColors.darkSurface,
        background: AppColors.darkBackground,
        error: AppColors.error,
        onPrimary: AppColors.darkTextPrimary,
        onSecondary: AppColors.darkTextPrimary,
        onSurface: AppColors.darkTextPrimary,
        onBackground: AppColors.darkTextPrimary,
        onError: AppColors.darkTextPrimary,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: AppColors.darkBackground,
      
      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: AppConstants.fontSizeXL,
          fontWeight: FontWeight.bold,
        ),
      ),
      
      // Card
      cardTheme: CardTheme(
        color: AppColors.darkCard,
        elevation: 2,
        shadowColor: AppColors.darkShadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
      ),
      
      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGolden,
          foregroundColor: AppColors.darkTextPrimary,
          elevation: 2,
          shadowColor: AppColors.darkGoldenShadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.fontSizeMD,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryGolden,
          textStyle: const TextStyle(
            fontSize: AppConstants.fontSizeMD,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(color: AppColors.primaryGolden, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: AppConstants.fontSizeXXXL,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: AppConstants.fontSizeXXL,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: AppConstants.fontSizeXL,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: AppConstants.fontSizeXXL,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: AppConstants.fontSizeXL,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: AppConstants.fontSizeLG,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: AppConstants.fontSizeLG,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: AppConstants.fontSizeMD,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: AppConstants.fontSizeSM,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: AppConstants.fontSizeMD,
        ),
        bodyMedium: TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: AppConstants.fontSizeSM,
        ),
        bodySmall: TextStyle(
          color: AppColors.darkTextSecondary,
          fontSize: AppConstants.fontSizeXS,
        ),
        labelLarge: TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: AppConstants.fontSizeMD,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          color: AppColors.darkTextSecondary,
          fontSize: AppConstants.fontSizeSM,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: AppColors.darkTextSecondary,
          fontSize: AppConstants.fontSizeXS,
          fontWeight: FontWeight.w500,
        ),
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.primaryGolden,
        unselectedItemColor: AppColors.darkTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primaryGolden;
          }
          return AppColors.darkTextSecondary;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primaryGolden.withOpacity(0.3);
          }
          return AppColors.darkSurfaceVariant;
        }),
      ),
    );
  }
}

