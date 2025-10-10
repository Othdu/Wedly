import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final double iconSize;
  final double fontSize;
  final double spacing;

  const BottomNavItem({
    super.key,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.iconSize = 30,
    this.fontSize = 12,
    this.spacing = 6,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGolden.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: iconSize,
              color: isSelected
                  ? AppColors.primaryGolden
                  : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
            ),
            SizedBox(height: spacing),
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected 
                    ? AppColors.primaryGolden 
                    : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
