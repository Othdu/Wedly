import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'bottom_nav_item.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final navigationItems = [
      {
        'icon': Icons.home_outlined,
        'activeIcon': Icons.home,
        'label': 'الرئيسية',
      },
      {
        'icon': Icons.store_outlined,
        'activeIcon': Icons.store,
        'label': 'المتجر',
      },
      {
        'icon': Icons.event_available_outlined,
        'activeIcon': Icons.event_available,
        'label': 'حجز سريع',
      },
      {
        'icon': Icons.feedback_outlined,
        'activeIcon': Icons.feedback,
        'label': 'اراء العملاء',
      },
      {
        'icon': Icons.person_outline,
        'activeIcon': Icons.person,
        'label': 'الملف الشخصي',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.darkGray,
            AppColors.black,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldenShadow.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          // ⬇️ قللنا الارتفاع إلى النصف تقريبا (من 100 إلى 50)
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: navigationItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return Expanded(
                child: BottomNavItem(
                  icon: item['icon'] as IconData,
                  activeIcon: item['activeIcon'] as IconData,
                  label: item['label'] as String,
                  isSelected: isSelected,
                  onTap: () => onTap(index),
                  // ⬇️ صغّرنا الأيقونة والخط والفراغات
                  iconSize: 22,
                  fontSize: 10,
                  spacing: 4,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
