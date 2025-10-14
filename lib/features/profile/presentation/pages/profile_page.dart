import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../shared/widgets/app_header.dart';
import '../../../favorites/presentation/pages/favorites_list_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // Header Section
          SliverToBoxAdapter(
            child: AppHeader(
              welcomeText: '',
              subtitleText: '',
              featureTitle: 'الملف الشخصي ',
              logo: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
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
          const SliverToBoxAdapter(
            child: SizedBox(height: AppConstants.spacingMD),
          ),

            SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLG),
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
                        Builder(
                          builder: (context) {
                            String greeting = 'مرحباً بك';
                            bool isAuthed = false;
                            try {
                              final authState = context.read<AuthBloc>().state;
                              if (authState is AuthAuthenticated) {
                                final name = authState.user.fullName?.trim();
                                greeting = name != null && name.isNotEmpty
                                    ? 'مرحباً، $name'
                                    : 'مرحباً، ${authState.user.email}';
                                isAuthed = true;
                              } else if (authState is AuthRegistered) {
                                final name = authState.user.fullName?.trim();
                                greeting = name != null && name.isNotEmpty
                                    ? 'مرحباً، $name'
                                    : 'مرحباً، ${authState.user.email}';
                                isAuthed = true;
                              }
                            } catch (_) {
                              // AuthBloc not provided; keep defaults
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  greeting,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                if (!isAuthed) ...[
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
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: AppConstants.spacingMD),
          ),

          // Dark Mode Toggle
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLG),
              padding: const EdgeInsets.all(AppConstants.spacingMD),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                boxShadow: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkCardShadowSmall
                    : AppColors.cardShadowSmall,
              ),
              child: BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, state) {
                  final bool effectiveDark = context.read<ThemeCubit>().shouldUseDarkMode(context);
                  return Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppConstants.spacingMD),
                        decoration: BoxDecoration(
                          gradient: AppColors.goldenGradient,
                          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                        ),
                        child: Icon(
                          effectiveDark ? Icons.dark_mode : Icons.light_mode,
                          color: AppColors.white,
                          size: AppConstants.iconSizeMD,
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacingMD),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'المظهر الداكن',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              effectiveDark ? 'مفعل' : 'معطل',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: effectiveDark,
                        onChanged: (value) {
                          // When toggled, set an explicit theme so the switch reflects the app appearance
                          // even if the previous mode was following the system.
                          context.read<ThemeCubit>().setThemeMode(
                                value ? AppThemeMode.dark : AppThemeMode.light,
                              );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Statistics Cards
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(AppConstants.spacingLG),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      '12',
                      'حجوزات',
                      Icons.event,
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingMD),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      '8',
                      'مفضلة',
                      Icons.favorite,
                    ),
                  ),
                  
                ],
              ),
            ),
          ),

          // Profile Header
    
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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SettingsPage(),
                        ),
                      );
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

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMD),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkCardShadowSmall
            : AppColors.cardShadowSmall,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingSM),
            decoration: BoxDecoration(
              gradient: AppColors.goldenGradient,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            child: Icon(
              icon,
              color: AppColors.white,
              size: AppConstants.iconSizeSM,
            ),
          ),
          const SizedBox(height: AppConstants.spacingSM),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGolden,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
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
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkCardShadowSmall
            : AppColors.cardShadowSmall,
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
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkTextSecondary
              : AppColors.textSecondary,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}