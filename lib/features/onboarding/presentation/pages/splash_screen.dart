import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/utils/storage_service.dart';
import 'onboarding_page.dart';
import '../../../home/presentation/pages/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _bgGlowController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startSequence();
  }

  void _initAnimations() {
    _bgGlowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );

    _textOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();
    await Future.delayed(const Duration(seconds: 3));
    await _navigateNext();
  }

  Future<void> _navigateNext() async {
    final storageService = await StorageService.getInstance();
    final isOnboardingCompleted =
        await storageService.isOnboardingCompleted();

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, a, __) => FadeTransition(
          opacity: a,
          child: ScaleTransition(
            scale: Tween<double>(begin: 1.1, end: 1.0).animate(a),
            child: isOnboardingCompleted
                ? const HomePage()
                : const OnboardingPage(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bgGlowController.dispose();
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final isDarkMode = context.read<ThemeCubit>().shouldUseDarkMode(context);
        
        return Scaffold(
          body: AnimatedBuilder(
            animation: _bgGlowController,
            builder: (context, _) {
              return Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.black : Colors.white,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildMovingBackground(isDarkMode),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLogo(isDarkMode),
                        const SizedBox(height: 32),
                        _buildText(isDarkMode),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMovingBackground(bool isDarkMode) {
    return CustomPaint(
      painter: isDarkMode 
          ? _GlowPainter(_bgGlowController.value)
          : _WhiteGlowPainter(_bgGlowController.value),
      size: MediaQuery.of(context).size,
    );
  }

  Widget _buildLogo(bool isDarkMode) {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, _) {
        return Transform.scale(
          scale: _logoScale.value,
          child: Opacity(
            opacity: _logoOpacity.value,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode 
                        ? Colors.amberAccent.withOpacity(0.4)
                        : Colors.amber.withOpacity(0.25),
                    blurRadius: isDarkMode ? 40 : 25,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildText(bool isDarkMode) {
    return FadeTransition(
      opacity: _textOpacity,
      child: Column(
        children: [
          Text(
            AppConstants.appName,
            style: TextStyle(
              fontSize: 36,
              color: isDarkMode ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: isDarkMode
                  ? [
                      Colors.amberAccent,
                      Colors.white,
                      Colors.amberAccent,
                    ]
                  : [
                      Colors.amber,
                      Colors.brown,
                      Colors.amber,
                    ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds),
            child: Text(
              AppConstants.appTagline,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode 
                    ? Colors.white.withOpacity(0.8)
                    : Colors.black.withOpacity(0.8),
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowPainter extends CustomPainter {
  final double value;
  _GlowPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..blendMode = BlendMode.plus;

    for (int i = 0; i < 3; i++) {
      final radius = 250.0 + 100 * sin(value * pi + i);
      final dx = size.width * (0.3 + 0.4 * sin(value * 2 * pi + i));
      final dy = size.height * (0.4 + 0.3 * cos(value * 2 * pi + i));

      paint.shader = RadialGradient(
        colors: [
          Colors.amberAccent.withOpacity(0.15),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset(dx, dy), radius: radius));

      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(_GlowPainter oldDelegate) => true;
}

class _WhiteGlowPainter extends CustomPainter {
  final double value;
  _WhiteGlowPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..blendMode = BlendMode.srcOver;

    for (int i = 0; i < 3; i++) {
      final radius = 220.0 + 60 * sin(value * pi + i);
      final dx = size.width * (0.4 + 0.3 * sin(value * 2 * pi + i));
      final dy = size.height * (0.4 + 0.3 * cos(value * 2 * pi + i));

      paint.shader = RadialGradient(
        colors: [
          Colors.amber.withOpacity(0.12),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset(dx, dy), radius: radius));

      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(_WhiteGlowPainter oldDelegate) => true;
}
