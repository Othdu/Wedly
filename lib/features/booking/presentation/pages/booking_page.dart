import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class BookingPage extends StatelessWidget {
  final String? serviceId;

  const BookingPage({
    super.key,
    this.serviceId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حجز سريع'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.white,
              AppColors.lightGray,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingLG),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // WEDLY Logo
                Container(
                  padding: const EdgeInsets.all(AppConstants.spacingLG),
                  decoration: BoxDecoration(
                    gradient: AppColors.goldenGradient,
                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                    boxShadow: AppColors.goldenShadowMedium,
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.event_available,
                        size: 64,
                        color: AppColors.white,
                      ),
                      const SizedBox(height: AppConstants.spacingMD),
                      Text(
                        'حجز سريع',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingSM),
                      Text(
                        'احجز خدمات الزفاف بسهولة وسرعة',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppConstants.spacingXXL),
                
                // Coming Soon Message
                Container(
                  padding: const EdgeInsets.all(AppConstants.spacingLG),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                    boxShadow: AppColors.cardShadowMedium,
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.construction,
                        size: 48,
                        color: AppColors.primaryGolden,
                      ),
                      const SizedBox(height: AppConstants.spacingMD),
                      Text(
                        'قريباً',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.primaryGolden,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingSM),
                      Text(
                        'نعمل على تطوير نظام الحجز السريع ليكون جاهزاً قريباً',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const Spacer(),
                
                // Service ID Display (if provided)
                if (serviceId != null)
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingMD),
                    decoration: BoxDecoration(
                      color: AppColors.lightGray,
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                    ),
                    child: Text(
                      'معرف الخدمة: $serviceId',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
