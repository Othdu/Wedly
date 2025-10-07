import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/minimal_headline.dart';
import '../widgets/quick_service_card.dart';

class QuickAccessPage extends StatelessWidget {
  const QuickAccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final quickServices = [
      {
        'id': '1',
        'title': 'حجز قاعة فورية',
        'subtitle': 'احجز قاعة الأفراح خلال 24 ساعة',
        'icon': Icons.event_seat,
        'price': 12000,
        'color': AppColors.primaryGolden,
        'gradient': AppColors.goldenGradient,
      },
      {
        'id': '2',
        'title': 'تصوير سريع',
        'subtitle': 'جلسة تصوير احترافية في نفس اليوم',
        'icon': Icons.camera_alt,
        'price': 5000,
        'color': const Color(0xFF2196F3),
        'gradient': const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
        ),
      },
      {
        'id': '3',
        'title': 'تجميل عاجل',
        'subtitle': 'خدمات التجميل والعناية السريعة',
        'icon': Icons.face,
        'price': 3000,
        'color': const Color(0xFFE91E63),
        'gradient': const LinearGradient(
          colors: [Color(0xFFE91E63), Color(0xFFF48FB1)],
        ),
      },
      {
        'id': '4',
        'title': 'ديكور سريع',
        'subtitle': 'تزيين القاعة في وقت قياسي',
        'icon': Icons.local_florist,
        'price': 8000,
        'color': const Color(0xFF4CAF50),
        'gradient': const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
        ),
      },
      {
        'id': '5',
        'title': 'ضيافة عاجلة',
        'subtitle': 'خدمات الطعام والشراب السريعة',
        'icon': Icons.restaurant,
        'price': 6000,
        'color': const Color(0xFFFF9800),
        'gradient': const LinearGradient(
          colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
        ),
      },
      {
        'id': '6',
        'title': 'موسيقى مباشرة',
        'subtitle': 'فرق موسيقية متاحة فوراً',
        'icon': Icons.music_note,
        'price': 4000,
        'color': const Color(0xFF9C27B0),
        'gradient': const LinearGradient(
          colors: [Color(0xFF9C27B0), Color(0xFFBA68C8)],
        ),
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.white,
            elevation: 0,
            flexibleSpace: const FlexibleSpaceBar(
              title: MinimalHeadline(title: 'حجز سريع'),
              titlePadding: const EdgeInsets.only(
                left: AppConstants.spacingLG,
                bottom: AppConstants.spacingMD,
              ),
            ),
          ),

          // Header Section
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
                          'خدمات سريعة',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingSM),
                        Text(
                          'احجز خدمات الزفاف في أسرع وقت ممكن',
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
                            'متاح خلال 24 ساعة',
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
                      Icons.flash_on,
                      size: 48,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Services Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLG),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: AppConstants.spacingMD,
                mainAxisSpacing: AppConstants.spacingMD,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final service = quickServices[index];
                  return QuickServiceCard(
                    service: service,
                    onTap: () {
                      // Handle service selection
                      _showBookingDialog(context, service);
                    },
                  );
                },
                childCount: quickServices.length,
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

  void _showBookingDialog(BuildContext context, Map<String, dynamic> service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        ),
        title: Text(
          service['title'] as String,
          style: const TextStyle(
            color: AppColors.primaryGolden,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(service['subtitle'] as String),
            const SizedBox(height: AppConstants.spacingMD),
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingMD),
              decoration: BoxDecoration(
                gradient: AppColors.goldenGradient,
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              child: Text(
                'السعر: ${service['price']} ج.م',
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Handle booking
            },
            child: const Text('احجز الآن'),
          ),
        ],
      ),
    );
  }
}
