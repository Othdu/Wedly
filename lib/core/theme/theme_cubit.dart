import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../utils/storage_service.dart';

enum AppThemeMode { system, light, dark }

class ThemeState extends Equatable {
  final AppThemeMode themeMode;
  final bool isDarkMode;

  const ThemeState({
    required this.themeMode,
    required this.isDarkMode,
  });

  ThemeState copyWith({
    AppThemeMode? themeMode,
    bool? isDarkMode,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
  
  @override
  List<Object?> get props => [themeMode, isDarkMode];
}

class ThemeCubit extends Cubit<ThemeState> {
  final StorageService _storageService;

  ThemeCubit(this._storageService) : super(const ThemeState(
    themeMode: AppThemeMode.system,
    isDarkMode: false,
  ));

  Future<void> initialize() async {
    final savedThemeMode = await _getSavedThemeMode();
    final isDarkMode = _calculateIsDarkMode(savedThemeMode);
    
    emit(ThemeState(
      themeMode: savedThemeMode,
      isDarkMode: isDarkMode,
    ));
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    await _storageService.setThemeMode(mode.name);
    final isDarkMode = _calculateIsDarkMode(mode);
    
    emit(state.copyWith(
      themeMode: mode,
      isDarkMode: isDarkMode,
    ));
  }

  Future<void> toggleDarkMode() async {
    final newMode = state.isDarkMode ? AppThemeMode.light : AppThemeMode.dark;
    await setThemeMode(newMode);
  }

  Future<AppThemeMode> _getSavedThemeMode() async {
    final savedMode = await _storageService.getThemeMode();
    switch (savedMode) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      case 'system':
      default:
        return AppThemeMode.system;
    }
  }

  bool _calculateIsDarkMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return false;
      case AppThemeMode.dark:
        return true;
      case AppThemeMode.system:
        // This will be handled by the main app based on system brightness
        return false;
    }
  }

  bool shouldUseDarkMode(BuildContext context) {
    switch (state.themeMode) {
      case AppThemeMode.light:
        return false;
      case AppThemeMode.dark:
        return true;
      case AppThemeMode.system:
        return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
  }
}
