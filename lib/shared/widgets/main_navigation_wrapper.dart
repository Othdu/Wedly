import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

/// Main Navigation Wrapper
/// Provides bottom navigation for the main app screens
class MainNavigationWrapper extends StatefulWidget {
  final Widget child;

  const MainNavigationWrapper({
    super.key,
    required this.child,
  });

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'الرئيسية',
      route: AppConstants.routeHome,
    ),
    NavigationItem(
      icon: Icons.store_outlined,
      activeIcon: Icons.store,
      label: 'المتجر',
      route: AppConstants.routeVendors,
    ),
    NavigationItem(
      icon: Icons.event_available_outlined,
      activeIcon: Icons.event_available,
      label: 'حجز سريع',
      route: AppConstants.routeQuickBook,
    ),
    NavigationItem(
      icon: Icons.feedback_outlined,
      activeIcon: Icons.feedback,
      label: 'آراء العملاء',
      route: AppConstants.routeFeedback,
    ),
    NavigationItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'الملف الشخصي',
      route: AppConstants.routeProfile,
    ),
  ];

  int _getCurrentIndex(BuildContext context) {
    final GoRouter router = GoRouter.of(context);
    final String currentLocation =
        router.routerDelegate.currentConfiguration.uri.path;
    final int index = _navigationItems
        .indexWhere((item) => currentLocation.startsWith(item.route));
    return index != -1 ? index : 0;
  }

  void _onItemTapped(int index) {
    context.go(_navigationItems[index].route);
  }

  @override
  Widget build(BuildContext context) {
    final int currentIndex = _getCurrentIndex(context);

    // ⬆️ زودنا الارتفاع علشان الشريط يكون أوضح وأكبر
    const double newNavHeight = 105.0;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: AppColors.goldenShadow,
              blurRadius: 15, // ظل أنعم
              offset: Offset(0, -5), // ظل أعلى
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Container(
            height: newNavHeight,
            decoration: const BoxDecoration(
              color: AppColors.darkGray,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _navigationItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isSelected = index == currentIndex;

                return _NavigationItemWidget(
                  item: item,
                  isSelected: isSelected,
                  onTap: () => _onItemTapped(index),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

// --- Navigation Item Widget ---

class _NavigationItemWidget extends StatelessWidget {
  final NavigationItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavigationItemWidget({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // ⬆️ كبرنا الأيقونات والخط والمسافات
    const double newIconSize = 36.0;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: isSelected
                ? AppColors.primaryGolden.withOpacity(0.18)
                : Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isSelected ? item.activeIcon : item.icon,
                  size: newIconSize,
                  color: isSelected
                      ? AppColors.primaryGolden
                      : AppColors.white.withOpacity(0.9),
                ),
                const SizedBox(height: 10),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.primaryGolden
                        : AppColors.white,
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

// --- Navigation Item Model ---

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}
