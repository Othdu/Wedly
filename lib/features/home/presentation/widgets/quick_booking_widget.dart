import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../booking/presentation/pages/booking_page.dart';

class QuickBookingWidget extends StatelessWidget {
  const QuickBookingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingLG,
        vertical: AppConstants.spacingMD,
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              const Icon(
                Icons.event_available,
                color: AppColors.primaryGolden,
                size: 24,
              ),
              const SizedBox(width: AppConstants.spacingSM),
              Text(
                'حجز سريع',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.primaryGolden,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingMD),

          // Quick booking options
          Row(
            children: [
              Expanded(
                child: _QuickBookingCard(
                  icon: Icons.event_seat,
                  title: 'قاعة أفراح',
                  subtitle: 'احجز قاعة',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const BookingPage(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: AppConstants.spacingMD),
              Expanded(
                child: _QuickBookingCard(
                  icon: Icons.camera_alt,
                  title: 'تصوير',
                  subtitle: 'احجز مصور',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const BookingPage(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: AppConstants.spacingMD),
              Expanded(
                child: _QuickBookingCard(
                  icon: Icons.restaurant,
                  title: 'ضيافة',
                  subtitle: 'احجز طعام',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const BookingPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickBookingCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickBookingCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingMD),
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
          children: [
            Icon(
              icon,
              color: AppColors.primaryGolden,
              size: 28,
            ),
            const SizedBox(height: AppConstants.spacingSM),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
