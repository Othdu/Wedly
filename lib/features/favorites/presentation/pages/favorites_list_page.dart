import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class FavoritesListPage extends StatelessWidget {
  const FavoritesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingMD,
                  vertical: AppConstants.spacingSM,
                ),
                decoration: BoxDecoration(
                  gradient: AppColors.goldenGradient,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  boxShadow: AppColors.goldenShadowSmall,
                ),
                child: Text(
                  'المفضلة',
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeXL,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
              titlePadding: const EdgeInsets.only(
                left: AppConstants.spacingLG,
                bottom: AppConstants.spacingMD,
              ),
            ),
          ),

          // Empty State
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
                      color: AppColors.lightGray,
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingLG),
                  Text(
                    'لا توجد خدمات مفضلة',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingMD),
                  Text(
                    'ابدأ بحفظ خدماتك المفضلة للوصول السريع إليها',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
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


