import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/hall_model.dart';

class HallCard extends StatelessWidget {
  final HallModel hall;
  final VoidCallback onTap;
  final VoidCallback? onBookNow;

  const HallCard({
    super.key,
    required this.hall,
    required this.onTap,
    this.onBookNow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          boxShadow: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkCardShadowMedium
              : AppColors.cardShadowMedium,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Hall Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppConstants.borderRadius),
                topRight: Radius.circular(AppConstants.borderRadius),
              ),
              child: AspectRatio(
                aspectRatio: 2.0,
                child: Container(
                  width: double.infinity,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkSurfaceVariant
                      : AppColors.lightGray,
                  child: hall.mainImageUrl.startsWith('http')
                      ? Image.network(
                          hall.mainImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? AppColors.darkSurfaceVariant
                                : AppColors.lightGray,
                            child: const Center(
                              child: Icon(
                                Icons.broken_image_outlined,
                                size: 40,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? AppColors.darkSurfaceVariant
                                  : AppColors.lightGray,
                              child: const Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          },
                        )
                      : Image.asset(
                          hall.mainImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? AppColors.darkSurfaceVariant
                                : AppColors.lightGray,
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                size: 40,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),

            // Hall Info
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingSM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Hall Name
                  Text(
                    hall.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 2),

                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          hall.location,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Capacity and Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Capacity
                      Row(
                        children: [
                          const Icon(
                            Icons.people,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            hall.formattedCapacity,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),

                      // Rating
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            hall.rating.toString(),
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: AppConstants.fontSizeSM,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: AppConstants.spacingSM),

                  // Price and Book Button Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingSM,
                          vertical: AppConstants.spacingXS,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.goldenGradient,
                          borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                        ),
                        child: Text(
                          hall.formattedPrice,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: AppConstants.fontSizeSM,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Book Now Button
                      if (onBookNow != null)
                        ElevatedButton(
                          onPressed: onBookNow,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGolden,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.spacingMD,
                              vertical: AppConstants.spacingXS,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                            ),
                          ),
                          child: const Text(
                            'احجز',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeSM,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
