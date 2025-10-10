import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/storage_service.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../data/models/onboarding_model.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  late AnimationController _backgroundController;
  late AnimationController _illustrationController;
  late AnimationController _textController;
  late AnimationController _particlesController;
  
  late Animation<double> _backgroundOpacityAnimation;
  late Animation<double> _illustrationScaleAnimation;
  late Animation<double> _illustrationRotationAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _textOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _illustrationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _particlesController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _backgroundOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeOut,
    ));

    _illustrationScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _illustrationController,
      curve: Curves.elasticOut,
    ));

    _illustrationRotationAnimation = Tween<double>(
      begin: -0.3,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _illustrationController,
      curve: Curves.elasticOut,
    ));

    _textSlideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    ));

    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));
  }

  void _startAnimations() {
    _backgroundController.forward();
    _particlesController.repeat();
    
    Future.delayed(const Duration(milliseconds: 300), () {
      _illustrationController.forward();
    });
    
    Future.delayed(const Duration(milliseconds: 600), () {
      _textController.forward();
    });
  }

  void _resetAnimations() {
    _illustrationController.reset();
    _textController.reset();
    _startAnimations();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _backgroundController.dispose();
    _illustrationController.dispose();
    _textController.dispose();
    _particlesController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < OnboardingData.slides.length - 1) {
      _pageController.nextPage(
        duration: AppConstants.mediumAnimationDuration,
        curve: Curves.easeInOut,
      );
      _resetAnimations();
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    try {
      final storageService = await StorageService.getInstance();
      await storageService.setOnboardingCompleted();

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    } catch (e) {
      // Fallback navigation
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _backgroundController,
          _illustrationController,
          _textController,
          _particlesController,
        ]),
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: AppColors.goldenGradientVertical,
            ),
            child: Stack(
              children: [
                // Animated background particles
                _buildBackgroundParticles(),
                
                // Main content
                SafeArea(
                  child: Column(
                    children: [
                      // Skip button with fade animation
                      Padding(
                        padding: const EdgeInsets.all(AppConstants.spacingLG),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AnimatedOpacity(
                              opacity: _backgroundOpacityAnimation.value,
                              duration: const Duration(milliseconds: 500),
                              child: TextButton(
                                onPressed: _skipOnboarding,
                                child: Text(
                                  'تخطي',
                                  style: TextStyle(
                                    color: AppColors.white.withOpacity(0.8),
                                    fontSize: AppConstants.fontSizeMD,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // PageView with romantic transitions
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                            _resetAnimations();
                          },
                          itemCount: OnboardingData.slides.length,
                          itemBuilder: (context, index) {
                            final slide = OnboardingData.slides[index];
                            return _buildAnimatedSlide(slide);
                          },
                        ),
                      ),

                      // Enhanced page indicators
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.spacingLG,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            OnboardingData.slides.length,
                            (index) => _buildEnhancedPageIndicator(index),
                          ),
                        ),
                      ),

                      // Enhanced navigation buttons
                      Padding(
                        padding: const EdgeInsets.all(AppConstants.spacingLG),
                        child: Row(
                          children: [
                            // Previous button
                            if (_currentPage > 0)
                              Expanded(
                                child: AnimatedOpacity(
                                  opacity: _backgroundOpacityAnimation.value,
                                  duration: const Duration(milliseconds: 300),
                                  child: OutlinedButton(
                                    onPressed: () {
                                      _pageController.previousPage(
                                        duration: AppConstants.mediumAnimationDuration,
                                        curve: Curves.easeInOut,
                                      );
                                      _resetAnimations();
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: AppColors.white),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: AppConstants.spacingMD,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppConstants.borderRadius,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'السابق',
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            
                            if (_currentPage > 0) const SizedBox(width: AppConstants.spacingMD),

                            // Next/Get Started button
                            Expanded(
                              flex: _currentPage > 0 ? 1 : 2,
                              child: AnimatedOpacity(
                                opacity: _backgroundOpacityAnimation.value,
                                duration: const Duration(milliseconds: 300),
                                child: ElevatedButton(
                                  onPressed: _nextPage,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.white,
                                    foregroundColor: AppColors.primaryGolden,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: AppConstants.spacingMD,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppConstants.borderRadius,
                                      ),
                                    ),
                                    elevation: 8,
                                    shadowColor: AppColors.white.withOpacity(0.3),
                                  ),
                                  child: Text(
                                    _currentPage == OnboardingData.slides.length - 1
                                        ? 'ابدأ الآن'
                                        : 'التالي',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: AppConstants.fontSizeMD,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackgroundParticles() {
    return CustomPaint(
      painter: OnboardingParticlesPainter(_particlesController.value),
      size: Size.infinite,
    );
  }

  Widget _buildAnimatedSlide(OnboardingModel slide) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingXL,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Illustration
          _buildAnimatedIllustration(slide),
          
          const SizedBox(height: AppConstants.spacingXXL),
          
          // Animated Title
          Transform.translate(
            offset: Offset(0, _textSlideAnimation.value),
            child: Opacity(
              opacity: _textOpacityAnimation.value,
              child: Text(
                slide.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: AppConstants.fontSizeXXL + 4,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      color: AppColors.white.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          
          const SizedBox(height: AppConstants.spacingLG),
          
          // Animated Description
          Transform.translate(
            offset: Offset(0, _textSlideAnimation.value * 0.5),
            child: Opacity(
              opacity: _textOpacityAnimation.value,
              child: Text(
                slide.description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.white.withOpacity(0.9),
                  height: 1.6,
                  fontSize: AppConstants.fontSizeMD + 2,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedIllustration(OnboardingModel slide) {
    return AnimatedBuilder(
      animation: _illustrationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _illustrationScaleAnimation.value,
          child: Transform.rotate(
            angle: _illustrationRotationAnimation.value,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppColors.white.withOpacity(0.2),
                    AppColors.white.withOpacity(0.1),
                    Colors.transparent,
                  ],
                  radius: 1.0,
                ),
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.white.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Background decorative elements
                  ..._buildDecorativeElements(slide),
                  
                  // Main icon
                  Center(
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.white.withOpacity(0.4),
                            blurRadius: 15,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: Icon(
                        slide.icon,
                        size: 70,
                        color: AppColors.primaryGolden,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildDecorativeElements(OnboardingModel slide) {
    final elements = <Widget>[];
    
    // Add floating hearts
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi * 2 / 6) + (_particlesController.value * math.pi * 2);
      final radius = 90.0;
      final x = math.cos(angle) * radius;
      final y = math.sin(angle) * radius;
      
      elements.add(
        Positioned(
          left: 110 + x,
          top: 110 + y,
          child: Transform.scale(
            scale: 0.8 + (math.sin(_particlesController.value * math.pi * 2 + i) * 0.2),
            child: Icon(
              Icons.favorite,
              color: AppColors.white.withOpacity(0.6),
              size: 12,
            ),
          ),
        ),
      );
    }
    
    // Add sparkles
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi * 2 / 8) + (_particlesController.value * math.pi * 4);
      final radius = 70.0;
      final x = math.cos(angle) * radius;
      final y = math.sin(angle) * radius;
      
      elements.add(
        Positioned(
          left: 110 + x,
          top: 110 + y,
          child: Transform.scale(
            scale: 0.5 + (math.sin(_particlesController.value * math.pi * 3 + i) * 0.3),
            child: Icon(
              Icons.star,
              color: AppColors.white.withOpacity(0.7),
              size: 8,
            ),
          ),
        ),
      );
    }
    
    return elements;
  }

  Widget _buildEnhancedPageIndicator(int index) {
    final isActive = index == _currentPage;
    
    return AnimatedContainer(
      duration: AppConstants.shortAnimationDuration,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      height: 10,
      width: isActive ? 32 : 10,
      decoration: BoxDecoration(
        color: isActive 
            ? AppColors.white 
            : AppColors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(5),
        boxShadow: isActive ? [
          BoxShadow(
            color: AppColors.white.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ] : null,
      ),
    );
  }
}

class OnboardingParticlesPainter extends CustomPainter {
  final double animationValue;
  
  OnboardingParticlesPainter(this.animationValue);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;
    
    // Draw floating rose petals
    for (int i = 0; i < 20; i++) {
      final progress = (animationValue + i * 0.1) % 1.0;
      final x = (size.width * 0.1) + (i * size.width * 0.04);
      final y = size.height - (progress * size.height * 1.2);
      
      if (y > 0 && y < size.height) {
        final petalSize = 4.0 + (math.sin(progress * math.pi) * 2);
        final rotation = progress * math.pi * 2;
        _drawRosePetal(canvas, Offset(x, y), petalSize, rotation, paint);
      }
    }
    
    // Draw romantic hearts
    for (int i = 0; i < 15; i++) {
      final progress = (animationValue + i * 0.08) % 1.0;
      final x = (size.width * 0.05) + (i * size.width * 0.06);
      final y = size.height - (progress * size.height * 1.0);
      
      if (y > 0 && y < size.height) {
        final heartSize = 6.0 + (math.sin(progress * math.pi) * 3);
        _drawHeart(canvas, Offset(x, y), heartSize, paint);
      }
    }
    
    // Draw sparkles
    for (int i = 0; i < 25; i++) {
      final progress = (animationValue + i * 0.04) % 1.0;
      final x = (size.width * 0.02) + (i * size.width * 0.04);
      final y = size.height - (progress * size.height * 0.8);
      
      if (y > 0 && y < size.height) {
        final sparkleSize = 2.0 + (math.sin(progress * math.pi * 2) * 1);
        _drawSparkle(canvas, Offset(x, y), sparkleSize, paint);
      }
    }
  }
  
  void _drawRosePetal(Canvas canvas, Offset center, double size, double rotation, Paint paint) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    
    final path = Path();
    path.moveTo(0, -size);
    path.quadraticBezierTo(size * 0.7, -size * 0.3, size * 0.5, size * 0.5);
    path.quadraticBezierTo(0, size * 0.8, -size * 0.5, size * 0.5);
    path.quadraticBezierTo(-size * 0.7, -size * 0.3, 0, -size);
    
    canvas.drawPath(path, paint);
    canvas.restore();
  }
  
  void _drawHeart(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    final width = size;
    final height = size * 0.9;
    
    path.moveTo(center.dx, center.dy + height * 0.3);
    path.cubicTo(
      center.dx - width * 0.5, center.dy - height * 0.2,
      center.dx - width * 0.5, center.dy + height * 0.1,
      center.dx, center.dy + height * 0.3,
    );
    path.cubicTo(
      center.dx + width * 0.5, center.dy + height * 0.1,
      center.dx + width * 0.5, center.dy - height * 0.2,
      center.dx, center.dy + height * 0.3,
    );
    
    canvas.drawPath(path, paint);
  }
  
  void _drawSparkle(Canvas canvas, Offset center, double size, Paint paint) {
    canvas.drawCircle(center, size, paint);
    canvas.drawLine(
      Offset(center.dx - size * 1.5, center.dy),
      Offset(center.dx + size * 1.5, center.dy),
      paint..strokeWidth = 1,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - size * 1.5),
      Offset(center.dx, center.dy + size * 1.5),
      paint..strokeWidth = 1,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

