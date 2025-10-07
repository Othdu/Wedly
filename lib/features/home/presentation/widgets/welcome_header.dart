import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppConstants.spacingLG),
      padding: const EdgeInsets.all(AppConstants.spacingLG),
      decoration: BoxDecoration(
        gradient: AppColors.goldenGradient,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        boxShadow: AppColors.goldenShadowMedium,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحباً بك في WEDLY',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingSM),
                Text(
                  'احجز أفضل خدمات الزفاف بسهولة وفخامة',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingMD),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingMD,
                    vertical: AppConstants.spacingSM,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  ),
                  child: Text(
                    'أكثر من 100+ خدمة متاحة',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppConstants.spacingLG),
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMD),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
            ),
            child: const Icon(
              Icons.favorite,
              size: 48,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}