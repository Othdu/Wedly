import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/app_header.dart';
import '../widgets/quick_service_card.dart';

class QuickAccessPage extends StatelessWidget {
  const QuickAccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = Responsive.screenWidth(context);
    final int gridCount = Responsive.gridColumns(context, small: 2, medium: 3, large: 4, xlarge: 4);
    final double gridAspect = Responsive.gridAspect(context, small: 0.8, medium: 0.9, large: 1.0);

    final List<Map<String, dynamic>> fastServices = [
      {
        'id': '1',
        'title': 'حجز قاعة فورية',
        'subtitle': 'احجز قاعة الأفراح خلال 24 ساعة',
        'icon': Icons.church,
        'price': 12000,
        'gradient': const LinearGradient(
          colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
      {
        'id': '2',
        'title': 'تصوير سريع',
        'subtitle': 'جلسة تصوير احترافية في نفس اليوم',
        'icon': Icons.camera_enhance_outlined,
        'price': 5000,
        'gradient': const LinearGradient(
          colors: [Color(0xFF64B5F6), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
      {
        'id': '3',
        'title': 'تجميل عاجل',
        'subtitle': 'خدمات التجميل والعناية السريعة',
        'icon': Icons.brush_outlined,
        'price': 3000,
        'gradient': const LinearGradient(
          colors: [Color(0xFFF48FB1), Color(0xFFD81B60)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
      {
        'id': '4',
        'title': 'ديكور سريع',
        'subtitle': 'تزيين القاعة في وقت قياسي',
        'icon': Icons.auto_awesome,
        'price': 8000,
        'gradient': const LinearGradient(
          colors: [Color(0xFF81C784), Color(0xFF388E3C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
      {
        'id': '5',
        'title': 'ضيافة عاجلة',
        'subtitle': 'خدمات الطعام والشراب السريعة',
        'icon': Icons.local_dining_outlined,
        'price': 6000,
        'gradient': const LinearGradient(
          colors: [Color(0xFFFFE082), Color(0xFFFF9800)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
      {
        'id': '6',
        'title': 'موسيقى مباشرة',
        'subtitle': 'فرق موسيقية متاحة فوراً',
        'icon': Icons.mic_none_outlined,
        'price': 4000,
        'gradient': const LinearGradient(
          colors: [Color(0xFFD1C4E9), Color(0xFF8E24AA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: AppHeader(
                welcomeText: '',
                subtitleText: '',
                featureTitle: 'حجز سريع',
                logo: Container(
                  height: Responsive.hp(context, 0.05).clamp(32.0, 48.0),
                  width: Responsive.hp(context, 0.05).clamp(32.0, 48.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
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

            // Top section (search, filters)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(AppConstants.spacingLG),
                padding: const EdgeInsets.all(AppConstants.spacingLG),
                decoration: BoxDecoration(
                  gradient: AppColors.goldenGradient,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                  boxShadow: AppColors.goldenShadowMedium,
                ),
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
                      child: const Text(
                        'متاح خلال 24 ساعة',
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingMD),
                    // Search
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: AppConstants.spacingMD),
                            child: Icon(Icons.search, color: AppColors.white),
                          ),
                          Expanded(
                            child: TextField(
                              style: const TextStyle(color: AppColors.white),
                              cursorColor: AppColors.white,
                              decoration: InputDecoration(
                                hintText: 'ابحث عن خدمة سريعة...',
                                hintStyle: TextStyle(color: AppColors.white.withOpacity(0.8)),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingMD),
                  ],
                ),
              ),
            ),

            // Grid title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLG),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الخدمات المتاحة',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingMD,
                        vertical: AppConstants.spacingXS,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: 'recommended',
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          items: const [
                            DropdownMenuItem(value: 'recommended', child: Text('الأفضل')),
                            DropdownMenuItem(value: 'price_low', child: Text('السعر (من الأقل)')),
                            DropdownMenuItem(value: 'price_high', child: Text('السعر (من الأعلى)')),
                          ],
                          onChanged: (_) {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Grid
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth >= 900 ? AppConstants.spacingXL : AppConstants.spacingLG,
              ),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridCount,
                  childAspectRatio: gridAspect,
                  crossAxisSpacing: AppConstants.spacingMD,
                  mainAxisSpacing: AppConstants.spacingMD,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final service = fastServices[index];
                    return QuickServiceCard(
                      service: service,
                      onTap: () => _showBookingDialog(context, service),
                    );
                  },
                  childCount: fastServices.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppConstants.spacingXXL)),
          ],
        ),
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
            },
            child: const Text('احجز الآن'),
          ),
        ],
      ),
    );
  }
}
