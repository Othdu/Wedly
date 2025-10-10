import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/home_state.dart';

class ServiceCategoryCard extends StatelessWidget {
  final ServiceCategory category;
  final VoidCallback onTap;

  const ServiceCategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  IconData _getCategoryIcon(String iconName) {
    switch (iconName) {
      case 'venue':
        return Icons.event_seat;
      case 'dress':
        return Icons.checkroom;
      case 'camera':
        return Icons.camera_alt;
      case 'food':
        return Icons.restaurant;
      case 'flower':
        return Icons.local_florist;
      case 'music':
        return Icons.music_note;
      case 'car':
        return Icons.directions_car;
      case 'makeup':
        return Icons.face;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(
            color: AppColors.primaryGolden.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkCardShadowSmall
              : AppColors.cardShadowSmall,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Category Icon
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingSM),
              decoration: BoxDecoration(
                gradient: AppColors.goldenGradient,
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                boxShadow: AppColors.goldenShadowSmall,
              ),
              child: Icon(
                _getCategoryIcon(category.icon),
                color: AppColors.white,
                size: AppConstants.iconSizeMD,
              ),
            ),
            
            const SizedBox(height: AppConstants.spacingSM),
            
            // Category Name
            Text(
              category.name,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 4),
            
            // Service Count
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingSM,
                vertical: AppConstants.spacingXS,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryGolden.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
              ),
              child: Text(
                '${category.serviceCount} خدمة',
                style: const TextStyle(
                  color: AppColors.primaryGolden,
                  fontSize: AppConstants.fontSizeXS,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}