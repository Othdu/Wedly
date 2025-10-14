import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/theme_cubit.dart';
// import '../../../../shared/widgets/minimal_headline.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // Minimal title like Featured Services
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: SizedBox(
                height: 56,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      'الإعدادات',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                    )
                  ],
                ),
              ),
            ),          
          ),
          

          // Settings Options
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLG),
              child: Column(
                children: [
                  _buildSectionHeader(context, 'المظهر'),
                  _buildThemeSelector(context),
                  const SizedBox(height: AppConstants.spacingLG),
                  
                  // _buildSectionHeader(context, 'اللغة'),
                  // _buildLanguageSelector(context),
                  // const SizedBox(height: AppConstants.spacingLG),
                  
                  _buildSectionHeader(context, 'الإشعارات'),
                  _buildNotificationSettings(context),
                  const SizedBox(height: AppConstants.spacingLG),
                  
                  _buildSectionHeader(context, 'الخصوصية'),
                  _buildPrivacySettings(context),
                  const SizedBox(height: AppConstants.spacingLG),
                  
                  _buildSectionHeader(context, 'حول التطبيق'),
                  _buildAboutSection(context),
                  
                  const SizedBox(height: AppConstants.spacingXXL),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppConstants.spacingLG,
        bottom: AppConstants.spacingMD,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: AppColors.primaryGolden,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            boxShadow: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkCardShadowSmall
                : AppColors.cardShadowSmall,
          ),
          child: Column(
            children: [
              _buildThemeOption(
                context,
                'النظام',
                'يتبع إعدادات الجهاز',
                Icons.phone_android,
                state.themeMode == AppThemeMode.system,
                () => context.read<ThemeCubit>().setThemeMode(AppThemeMode.system),
              ),
              _buildDivider(context),
              _buildThemeOption(
                context,
                'فاتح',
                'المظهر الفاتح دائماً',
                Icons.light_mode,
                state.themeMode == AppThemeMode.light,
                () => context.read<ThemeCubit>().setThemeMode(AppThemeMode.light),
              ),
              _buildDivider(context),
              _buildThemeOption(
                context,
                'داكن',
                'المظهر الداكن دائماً',
                Icons.dark_mode,
                state.themeMode == AppThemeMode.dark,
                () => context.read<ThemeCubit>().setThemeMode(AppThemeMode.dark),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return ListTile(
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
      trailing: isSelected
          ? Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.primaryGolden,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: AppColors.white,
                size: 16,
              ),
            )
          : null,
      onTap: onTap,
    );
  }

  // Widget _buildLanguageSelector(BuildContext context) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Theme.of(context).cardColor,
  //       borderRadius: BorderRadius.circular(AppConstants.borderRadius),
  //       boxShadow: Theme.of(context).brightness == Brightness.dark
  //           ? AppColors.darkCardShadowSmall
  //           : AppColors.cardShadowSmall,
  //     ),
  //     child: Column(
  //       children: [
         
        
          
  //       ],
  //     ),
  //   );
  // }

  Widget _buildLanguageOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return ListTile(
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
      trailing: isSelected
          ? Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.primaryGolden,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: AppColors.white,
                size: 16,
              ),
            )
          : null,
      onTap: onTap,
    );
  }

  Widget _buildNotificationSettings(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkCardShadowSmall
            : AppColors.cardShadowSmall,
      ),
      child: Column(
        children: [
          _buildSwitchOption(
            context,
            'الإشعارات العامة',
            'تلقي إشعارات عامة من التطبيق',
            Icons.notifications,
            true,
            (value) {},
          ),
          _buildDivider(context),
          _buildSwitchOption(
            context,
            'إشعارات الحجوزات',
            'إشعارات حول حالة حجوزاتك',
            Icons.event,
            true,
            (value) {},
          ),
          _buildDivider(context),
          _buildSwitchOption(
            context,
            'العروض والخصومات',
            'إشعارات حول العروض الجديدة',
            Icons.local_offer,
            false,
            (value) {},
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
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
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildPrivacySettings(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkCardShadowSmall
            : AppColors.cardShadowSmall,
      ),
      child: Column(
        children: [
          _buildSettingsOption(
            context,
            'سياسة الخصوصية',
            'اقرأ سياسة الخصوصية الخاصة بنا',
            Icons.privacy_tip,
            () {},
          ),
          _buildDivider(context),
          _buildSettingsOption(
            context,
            'شروط الاستخدام',
            'اقرأ شروط وأحكام الاستخدام',
            Icons.description,
            () {},
          ),
          _buildDivider(context),
          _buildSettingsOption(
            context,
            'حذف الحساب',
            'حذف حسابك نهائياً',
            Icons.delete_forever,
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkCardShadowSmall
            : AppColors.cardShadowSmall,
      ),
      child: Column(
        children: [
          _buildSettingsOption(
            context,
            'إصدار التطبيق',
            'الإصدار ${AppConstants.appVersion}',
            Icons.info,
            () {},
          ),
          _buildDivider(context),
          _buildSettingsOption(
            context,
            'تواصل معنا',
            'أرسل لنا ملاحظاتك واقتراحاتك',
            Icons.contact_support,
            () {},
          ),
          _buildDivider(context),
          _buildSettingsOption(
            context,
            'تقييم التطبيق',
            'ساعدنا بتحسين التطبيق',
            Icons.star,
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
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
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: AppColors.textSecondary,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkBorder
          : AppColors.borderLight,
      indent: 80,
      endIndent: 20,
    );
  }
}
  