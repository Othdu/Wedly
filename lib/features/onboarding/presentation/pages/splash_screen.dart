import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

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
    if (!mounted) return;
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    _textController.forward();
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    await _requestPermissions();
    if (!mounted) return;
    await _navigateNext();
  }

  Future<void> _requestPermissions() async {
    if (!mounted) return;
    // Request location permissions if not granted
    final statusFine = await Permission.locationWhenInUse.status;
    if (!mounted) return;
    if (!statusFine.isGranted && !statusFine.isPermanentlyDenied) {
      await Permission.locationWhenInUse.request();
    }
  }

  Future<void> _navigateNext() async {
    if (!mounted) return;
    
    final authBloc = context.read<AuthBloc>();

    // Initialize auth state
    authBloc.add(const AuthInitialized());

    // Wait for auth state to update
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Check authentication status
    final currentAuthState = authBloc.state;
    
    if (!mounted) return;
    
    if (currentAuthState is AuthAuthenticated) {
      // User is logged in - go directly to home
      if (mounted && context.mounted) {
        context.go(AppConstants.routeHome);
      }
    } else {
      // User is not logged in - always show login first
      // Onboarding will be shown after login if it's first time
      if (mounted && context.mounted) {
        context.go(AppConstants.routeLogin);
      }
    }
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
                  gradient: isDarkMode 
                      ? AppColors.darkCinematicGradient
                      : const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.white, Color(0xFFF5F5F5)],
                        ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildMovingBackground(isDarkMode),
                    // Soft golden dust settling into name
                    Positioned.fill(child: _GoldDustLayer(value: _bgGlowController.value)),
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
                        ? AppColors.primaryGolden.withOpacity(0.35)
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
              color: isDarkMode ? AppColors.champagneGold : Colors.black87,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: isDarkMode
                  ? [
                      AppColors.goldenLight,
                      Colors.white,
                      AppColors.primaryGolden,
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
                    ? Colors.white.withOpacity(0.85)
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

class _GoldDustLayer extends StatelessWidget {
  final double value;
  const _GoldDustLayer({required this.value});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _GoldDustPainter(value),
        size: Size.infinite,
      ),
    );
  }
}

class _GoldDustPainter extends CustomPainter {
  final double value;
  _GoldDustPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.primaryGolden.withOpacity(0.18);
    for (int i = 0; i < 60; i++) {
      final t = (value + i * 0.013) % 1.0;
      final dx = size.width * (0.1 + 0.8 * (i % 10) / 10) + (t * 15);
      final dy = size.height * (0.15 + 0.7 * (i / 60));
      final r = 0.8 + (i % 3) * 0.6;
      canvas.drawCircle(Offset(dx, dy), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GoldDustPainter oldDelegate) => true;
}
