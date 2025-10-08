import 'package:flutter/material.dart';
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
    // Determine if we have welcome content
    final hasWelcomeContent = welcomeText.isNotEmpty || subtitleText.isNotEmpty;
    final headerHeight = hasWelcomeContent ? 200.0 : 120.0;
    
    return Container(
      height: headerHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.primaryGolden,
            AppColors.primaryGolden.withOpacity(0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLG,
            vertical: AppConstants.spacingMD,
          ),
          child: hasWelcomeContent 
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo and App Name Row
                  Row(
                    children: [
                      logo ??
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text(
                                'ف',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
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
                            ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Welcome Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              welcomeText,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            if (subtitleText.isNotEmpty) ...[
                              const SizedBox(height: AppConstants.spacingXS),
                              Text(
                                subtitleText,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Text(
                        featureTitle,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo and App Name Row
                  Row(
                    children: [
                      logo ??
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text(
                                'ف',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
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
                            ),
                      ),
                    ],
                  ),
                  // Feature Title
                  Text(
                    featureTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
