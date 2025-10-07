import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_constants.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/home/presentation/bloc/home_event.dart';
import 'features/home/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  
  runApp(const WEDLYApp());
}

class WEDLYApp extends StatelessWidget {
  const WEDLYApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => HomeBloc()..add(const HomeInitialized()),
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        
        // Theme Configuration
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryGolden,
            brightness: Brightness.light,
            primary: AppColors.primaryGolden,
            secondary: AppColors.goldenLight,
            surface: AppColors.white,
            error: AppColors.error,
          ),
        ),
        
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
        
        // Home Page
        home: const HomePage(),
        
        // Builder for additional configurations
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl, // RTL for Arabic
            child: child!,
          );
        },
      ),
    );
  }
}
