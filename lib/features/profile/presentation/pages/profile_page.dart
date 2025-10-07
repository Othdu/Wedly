import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../favorites/presentation/pages/favorites_list_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  'الملف الشخصي',
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

          // Profile Header
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
                  // Profile Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: AppColors.cardShadowMedium,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 48,
                      color: AppColors.primaryGolden,
                    ),
                  ),
                  
                  const SizedBox(width: AppConstants.spacingLG),
                  
                  // User Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مرحباً بك',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingSM),
                        Text(
                          'سجل دخولك للوصول إلى جميع الميزات',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.white.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingMD),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to login
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.white,
                            foregroundColor: AppColors.primaryGolden,
                          ),
                          child: const Text('تسجيل الدخول'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Profile Options
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLG),
              child: Column(
                children: [
                  _buildProfileOption(
                    context,
                    'طلباتي',
                    'عرض جميع طلباتك وحجوزاتك',
                    Icons.shopping_bag,
                    () {
                      // Navigate to orders
                    },
                  ),
                  // Favorites under orders
                  _buildProfileOption(
                    context,
                    'المفضلة',
                    'قائمة خدماتك المفضلة',
                    Icons.favorite,
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const FavoritesListPage(),
                        ),
                      );
                    },
                  ),
                  _buildProfileOption(
                    context,
                    'الإشعارات',
                    'إدارة إشعاراتك وتفضيلاتك',
                    Icons.notifications,
                    () {
                      // Navigate to notifications
                    },
                  ),
                  _buildProfileOption(
                    context,
                    'الإعدادات',
                    'تخصيص إعدادات التطبيق',
                    Icons.settings,
                    () {
                      // Navigate to settings
                    },
                  ),
                  _buildProfileOption(
                    context,
                    'المساعدة والدعم',
                    'تواصل معنا للحصول على المساعدة',
                    Icons.help,
                    () {
                      // Navigate to help
                    },
                  ),
                  _buildProfileOption(
                    context,
                    'حول التطبيق',
                    'معلومات عن WEDLY',
                    Icons.info,
                    () {
                      // Navigate to about
                    },
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

  Widget _buildProfileOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMD),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: AppColors.cardShadowSmall,
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(AppConstants.spacingMD),
          decoration: BoxDecoration(
            gradient: AppColors.goldenGradient,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          child: Icon(
            icon,
            color: AppColors.white,
            size: AppConstants.iconSizeMD,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.textSecondary,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}