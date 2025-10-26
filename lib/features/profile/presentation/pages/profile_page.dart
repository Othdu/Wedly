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
import 'edit_profile_page.dart';
import '../../../booking/presentation/pages/booking_list_page.dart';
import '../bloc/profile_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Load profile data when page initializes
    context.read<ProfileBloc>().add(const ProfileLoadRequested());
  }

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
              child: Builder(
                builder: (context) {
                  String greeting = 'مرحباً بك';
                  bool isAuthed = false;
                  try {
                    final authState = context.read<AuthBloc>().state;
                    if (authState is AuthAuthenticated || authState is AuthRegistered) {
                      isAuthed = true;
                      if (authState is AuthAuthenticated) {
                        greeting = 'مرحباً ${authState.user.displayName}';
                      } else if (authState is AuthRegistered) {
                        greeting = 'مرحباً، ${authState.user.displayName}';
                      }
                    }
                  } catch (e) {
                    print('Profile - Error reading auth state: $e');
                  }

                  return InkWell(
                    onTap: isAuthed
                        ? () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const EditProfilePage(),
                              ),
                            );
                          }
                        : null,
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
                              Column(
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
                                  ] else ...[
                                    const SizedBox(height: AppConstants.spacingSM),
                                    Text(
                                      'اضغط للتعديل',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: AppColors.white.withOpacity(0.8),
                                          ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
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
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
                  int bookingsCount = 0;

                  if (state is ProfileLoaded) {
                    bookingsCount = state.bookingsCount;
                  }

              return SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(AppConstants.spacingLG),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          bookingsCount.toString(),
                          'حجوزات',
                          Icons.event,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const BookingListPage(),
                        ),
                      );
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