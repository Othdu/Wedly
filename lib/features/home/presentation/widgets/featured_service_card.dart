import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/home_state.dart';

class FeaturedServiceCard extends StatelessWidget {
  final FeaturedService service;
  final VoidCallback onTap;

  const FeaturedServiceCard({
    super.key,
    required this.service,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          boxShadow: AppColors.cardShadowMedium,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Service Image with fixed aspect ratio to avoid flex overflows
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppConstants.borderRadius),
                topRight: Radius.circular(AppConstants.borderRadius),
              ),
              child: AspectRatio(
                aspectRatio: 2.0,
                child: Container(
                  width: double.infinity,
                  color: AppColors.lightGray,
                  child: Image.network(
                    service.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        size: 40,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Service Info
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingSM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Service Title
                  Text(
                    service.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 2),

                  // Service Subtitle (no Expanded to prevent overflow)
                  Text(
                    service.subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  // Price and Rating Row
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
                          '${service.price.toStringAsFixed(0)} ج.م',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: AppConstants.fontSizeSM,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                            service.rating.toString(),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}