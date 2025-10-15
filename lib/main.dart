import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/utils/storage_service.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/home/presentation/bloc/home_event.dart';
import 'features/onboarding/presentation/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Google Mobile Ads
  await MobileAds.instance.initialize();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize storage service
  final storageService = await StorageService.getInstance();
  
  runApp(WEDLYApp(storageService: storageService));
}

class WEDLYApp extends StatelessWidget {
  final StorageService storageService;
  
  const WEDLYApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc()..add(const HomeInitialized()),
        ),
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(storageService)..initialize(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            
            // Theme Configuration
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.themeMode == AppThemeMode.system
                ? ThemeMode.system
                : themeState.themeMode == AppThemeMode.dark
                    ? ThemeMode.dark
                    : ThemeMode.light,
            
            // Localization Configuration
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ar', 'SA'), // Arabic (Saudi Arabia)
              Locale('en', 'US'), // English (United States)
            ],
            locale: const Locale('ar', 'SA'), // Default to Arabic
            
            // Splash Screen
            home: const SplashScreen(),
            
            // Builder for additional configurations
            builder: (context, child) {
              return Directionality(
                textDirection: TextDirection.rtl, // RTL for Arabic
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
