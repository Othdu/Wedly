import 'package:flutter/material.dart';
import 'dart:async';
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
  Timer? _autoTimer;
  bool _autoStarted = false;
  int _autoDirection = 1; // 1 forward, -1 backward
  Timer? _resumeAutoTimer;
  
  late Animation<double> _backgroundOpacityAnimation;
  // Minimal mode: no per-slide animation values

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    // Start auto-play immediately
    _autoStarted = true;
    _startAutoAdvance();
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

    // No-op: animations removed for minimalist experience
  }

  void _startAnimations() {
    _backgroundController.forward();
    // Minimalist: only a very subtle background stars movement
    _particlesController.repeat();
  }

  void _resetAnimations() {}

  @override
  void dispose() {
    _pageController.dispose();
    _backgroundController.dispose();
    _illustrationController.dispose();
    _textController.dispose();
    _particlesController.dispose();
    _autoTimer?.cancel();
    _resumeAutoTimer?.cancel();
    super.dispose();
  }

  void _nextPage() {
    if (!_autoStarted) {
      _autoStarted = true;
      _startAutoAdvance();
    }
    if (_currentPage == OnboardingData.slides.length - 1) {
      // Final page: finish onboarding instead of ping-pong
      _autoTimer?.cancel();
      _resumeAutoTimer?.cancel();
      _completeOnboarding();
      return;
    }
    _autoDirection = 1;
    _pageController.nextPage(
      duration: AppConstants.mediumAnimationDuration,
      curve: Curves.easeInOut,
    );
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _startAutoAdvance() {
    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final lastIndex = OnboardingData.slides.length - 1;
      var nextIndex = _currentPage + _autoDirection;
      if (nextIndex > lastIndex) {
        _autoDirection = -1;
        nextIndex = _currentPage + _autoDirection;
      } else if (nextIndex < 0) {
        _autoDirection = 1;
        nextIndex = _currentPage + _autoDirection;
      }
      _pageController.animateToPage(
        nextIndex,
        duration: AppConstants.mediumAnimationDuration,
        curve: Curves.easeInOut,
      );
    });
  }

  void _onUserInteraction() {
    if (!_autoStarted) return;
    _autoTimer?.cancel();
    _resumeAutoTimer?.cancel();
    _resumeAutoTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      if (_autoStarted) {
        _startAutoAdvance();
      }
    });
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
            gradient: AppColors.darkCinematicGradient,
          ),
            child: Stack(
              children: [
              // Golden shimmer overlay
              Positioned.fill(child: _buildGoldenShimmer()),
              // Minimal background stars
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
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            // Only pause on real user drags, not programmatic animations
                            if (notification is ScrollStartNotification && notification.dragDetails != null) {
                              _onUserInteraction();
                            } else if (notification is ScrollUpdateNotification && notification.dragDetails != null) {
                              _onUserInteraction();
                            } else if (notification is OverscrollNotification) {
                              _onUserInteraction();
                            }
                            return false;
                          },
                          child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemCount: OnboardingData.slides.length,
                          itemBuilder: (context, index) {
                            final slide = OnboardingData.slides[index];
                            return _buildAnimatedSlide(slide);
                          },
                          ),
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
                                      _onUserInteraction();
                                      _pageController.previousPage(
                                        duration: AppConstants.mediumAnimationDuration,
                                        curve: Curves.easeInOut,
                                      );
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
                                    'التالي',
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
    // Minimalist: remove moving background particles
    return const SizedBox.shrink();
  }

  Widget _buildGoldenShimmer() {
    return IgnorePointer(
      child: AnimatedOpacity(
        opacity: _backgroundOpacityAnimation.value,
        duration: const Duration(milliseconds: 800),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0x10F3DE96), // soft golden glow
                Colors.transparent,
                Color(0x08D6B45A),
              ],
            ),
          ),
        ),
      ),
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
          
          // Minimal Title (static)
          Text(
            slide.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.champagneGold,
              fontWeight: FontWeight.bold,
              fontSize: AppConstants.fontSizeXXL + 4,
              letterSpacing: 1.2,
              shadows: const [
                Shadow(
                  color: Color(0x26000000),
                  blurRadius: 6,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppConstants.spacingLG),
          
          // Minimal Description (static)
          Text(
            slide.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.white.withOpacity(0.9),
              height: 1.6,
              fontSize: AppConstants.fontSizeMD + 2,
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedIllustration(OnboardingModel slide) {
    // Responsive, static hero tile optimized for raster images
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxSide = constraints.maxWidth.isFinite
            ? constraints.maxWidth * 0.6
            : 220;
        final double side = maxSide.clamp(180.0, 260.0);

        return Container(
          width: side,
          height: side,
          decoration: BoxDecoration(
            gradient: const RadialGradient(
              colors: [
                Color(0x14D6B45A), // softer outer glow
                Colors.transparent,
              ],
              radius: 1.0,
            ),
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGolden.withOpacity(0.12),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: side - 40,
              height: side - 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFEDD194), // light champagne
                    Color(0xFFD6B45A), // golden
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGolden.withOpacity(0.18),
                    blurRadius: 14,
                    spreadRadius: 1,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(1.2),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge - 2),
                ),
                padding: const EdgeInsets.all(12),
                child: _buildHeroContent(slide),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroContent(OnboardingModel slide) {
    if (slide.imagePath != null && slide.imagePath!.isNotEmpty) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: AspectRatio(
          key: ValueKey(slide.imagePath),
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            child: Image.asset(
              slide.imagePath!,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              isAntiAlias: true,
              gaplessPlayback: true,
            ),
          ),
        ),
      );
    }
    if (slide.icon != null) {
      return Icon(
        slide.icon,
        size: 64,
        color: AppColors.goldenLight,
      );
    }
    return const SizedBox.shrink();
  }

  List<Widget> _buildDecorativeElements(OnboardingModel slide) {
    // Minimalist: no decorative moving elements
    return const <Widget>[];
  }

  Widget _buildEnhancedPageIndicator(int index) {
    final isActive = index == _currentPage;
    
    return AnimatedContainer(
      duration: AppConstants.shortAnimationDuration,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      height: 8,
      width: isActive ? 20 : 8,
      decoration: BoxDecoration(
        color: isActive 
            ? AppColors.primaryGolden 
            : AppColors.primaryGolden.withOpacity(0.35),
        borderRadius: BorderRadius.circular(4),
        boxShadow: isActive ? [
          BoxShadow(
            color: AppColors.primaryGolden.withOpacity(0.45),
            blurRadius: 10,
            spreadRadius: 1,
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
    final starPaint = Paint()
      ..color = AppColors.goldenLight.withOpacity(0.35)
      ..style = PaintingStyle.fill;

    // Minimal: a few slow-drifting stars
    const int starCount = 10; // few stars only
    for (int i = 0; i < starCount; i++) {
      final t = (animationValue + i * 0.07) % 1.0;
      final dx = (size.width * ((i % 5) + 1) / 6) + math.sin(t * math.pi * 2 + i) * 8;
      final dy = (size.height * ((i ~/ 5) + 1) / 3) + math.cos(t * math.pi * 2 + i) * 6;
      final r = 1.2 + ((i % 3) * 0.6);
      _drawStar(canvas, Offset(dx, dy), r, starPaint);
    }
  }
  
  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    canvas.drawCircle(center, size, paint);
    // tiny soft glow
    final glowPaint = Paint()
      ..color = AppColors.primaryGolden.withOpacity(0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawCircle(center, size * 2.2, glowPaint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

