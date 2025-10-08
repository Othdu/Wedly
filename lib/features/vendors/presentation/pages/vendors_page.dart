import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_header.dart';

class VendorsPage extends StatelessWidget {
  const VendorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: CustomScrollView(
        slivers: [
          // Header Section
          SliverToBoxAdapter(
            child: AppHeader(
              welcomeText: '',
              subtitleText: '',
              featureTitle: 'المتجر',
              logo: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'W',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content Section
          SliverToBoxAdapter(
            child: Container(
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
                          'أفضل المنتجات والخدمات',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingSM),
                        Text(
                          'اكتشف أفضل موردي خدمات الزفاف في مصر',
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
                            'أكثر من 200+ مورد',
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
                      Icons.store,
                      size: 48,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Coming Soon Message
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(AppConstants.spacingLG),
              padding: const EdgeInsets.all(AppConstants.spacingXXL),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                boxShadow: AppColors.cardShadowMedium,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingLG),
                    decoration: BoxDecoration(
                      gradient: AppColors.goldenGradient,
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                    ),
                    child: const Icon(
                      Icons.construction,
                      size: 64,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingLG),
                  Text(
                    'قريباً',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.primaryGolden,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingMD),
                  Text(
                    'نعمل على تطوير صفحة المتجر لتشمل جميع خدمات ومنتجات الزفاف في مصر',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.spacingLG),
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingMD),
                    decoration: BoxDecoration(
                      color: AppColors.lightGray,
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: AppColors.primaryGolden,
                        ),
                        const SizedBox(width: AppConstants.spacingSM),
                        Text(
                          'ستشمل: قاعات، مصورين، مطاعم، ديكور، موسيقى',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: AppConstants.spacingXXL),
          ),
        ],
      ),
    );
  }
}
