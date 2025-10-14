import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class AppHeader extends StatelessWidget {
  final String welcomeText;
  final String subtitleText;
  final String featureTitle;
  final Widget? logo;

  const AppHeader({
    super.key,
    this.welcomeText = 'مرحباً بك!',
    this.subtitleText = 'مستعد ليوم جديد من التخطيط؟',
    this.featureTitle = '',
    this.logo,
  });

  @override
  Widget build(BuildContext context) {
    final hasWelcomeContent = welcomeText.isNotEmpty || subtitleText.isNotEmpty;
    final headerHeight = hasWelcomeContent ? 220.0 : 140.0;

    return Container(
      height: headerHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGolden.withOpacity(0.95),
            AppColors.primaryGolden.withOpacity(0.75),
            Colors.amberAccent.withOpacity(0.4),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLG,
            vertical: AppConstants.spacingMD,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Hero(
                    tag: 'app_logo',
                    child: logo ??
                        Container(
                          height: 44,
                          width: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              'W',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                  ),
                  const SizedBox(width: AppConstants.spacingSM),
                  Text(
                    'WEDLY',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                  ).animate().fadeIn(duration: 500.ms).moveY(begin: 10),
                ],
              ),

              const Spacer(),

              if (hasWelcomeContent) ...[
                Text(
                  welcomeText,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ).animate().fadeIn(duration: 700.ms).moveY(begin: 10),
                const SizedBox(height: AppConstants.spacingXS),
                Text(
                  subtitleText,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                ).animate().fadeIn(duration: 900.ms).moveY(begin: 10),
              ],

              if (featureTitle.isNotEmpty)
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    featureTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ).animate().fadeIn(duration: 800.ms),
                ),
            ],
          ),
        ),
      ),
    ).animate().shimmer(duration: 8.seconds, color: Colors.white.withOpacity(0.1));
  }
}

