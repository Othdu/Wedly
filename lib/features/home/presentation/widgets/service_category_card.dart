import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/hall_model.dart'; // Import the models from data layer

class ServiceCategoryCard extends StatelessWidget {
  final ServiceCategory category;
  final VoidCallback onTap;

  const ServiceCategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  // Icon fallback removed: categories should provide images only

  Widget _buildCategoryImage(BuildContext context, String assetPath) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // For simple black icons on transparent background, we can colorize to white in dark mode
    // using ColorFiltered. This works well for mono-tone glyph PNGs/SVGs.
    final image = Image.asset(
      assetPath,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
    if (!isDark) return image;
    return ColorFiltered(
      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      child: image,
    );
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
            // Category Image only (no icon fallback, no golden highlight)
            if (category.image.isNotEmpty)
              Container(
                height: 48,
                width: 48,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                ),
                child: _buildCategoryImage(context, category.image),
              )
            else
              const SizedBox(height: 48, width: 48),
            
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
            Text(
              '${category.serviceCount} خدمة',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                    fontSize: AppConstants.fontSizeXS,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}