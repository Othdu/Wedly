import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/hall_model.dart';
import '../../../booking/presentation/pages/booking_page.dart';

class HallsWidget extends StatelessWidget {
  final List<HallModel> halls;
  final VoidCallback? onViewAll;

  const HallsWidget({
    super.key,
    required this.halls,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (halls.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingLG,
        vertical: AppConstants.spacingMD,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and view all button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'قاعات الأفراح',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.primaryGolden,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (onViewAll != null)
                TextButton(
                  onPressed: onViewAll,
                  child: Text(
                    'عرض الكل',
                    style: TextStyle(
                      color: AppColors.primaryGolden,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingMD),

          // Horizontal scrollable halls list
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: halls.length,
              itemBuilder: (context, index) {
                final hall = halls[index];
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: AppConstants.spacingMD),
                  child: _HallCard(
                    hall: hall,
                    onTap: () {
                      // Navigate to hall details
                      // TODO: Implement hall details page
                    },
                    onBookNow: () {
                      // Navigate to booking page
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BookingPage(
                            hallId: hall.id.toString(),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HallCard extends StatelessWidget {
  final HallModel hall;
  final VoidCallback onTap;
  final VoidCallback onBookNow;

  const _HallCard({
    required this.hall,
    required this.onTap,
    required this.onBookNow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          boxShadow: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkCardShadowMedium
              : AppColors.cardShadowMedium,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hall Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppConstants.borderRadius),
                topRight: Radius.circular(AppConstants.borderRadius),
              ),
              child: Container(
                height: 100,
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
                              size: 30,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
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
                              size: 30,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
              ),
            ),

            // Hall Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingSM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hall Name
                    Text(
                      hall.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
                          size: 12,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            hall.location,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Price and Book Button Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.goldenGradient,
                            borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                          ),
                          child: Text(
                            hall.formattedPrice,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Book Now Button
                        GestureDetector(
                          onTap: onBookNow,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGolden,
                              borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                            ),
                            child: const Text(
                              'احجز',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
