import 'package:flutter/material.dart';
import '../../../core/theme/app_theme_constants.dart';

/// Custom Dropdown Widget with Enhanced Theme Support
class ThemedDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final IconData? prefixIcon;
  final String? Function(T?)? validator;
  final bool isExpanded;
  final String? hint;

  const ThemedDropdown({
    super.key,
    required this.value,
    required this.items,
    this.onChanged,
    this.label,
    this.prefixIcon,
    this.validator,
    this.isExpanded = true,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusMD),
        boxShadow: AppThemeConstants.cardShadow,
      ),
      child: DropdownButtonFormField<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        validator: validator,
        isExpanded: isExpanded,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  color: Theme.of(context).colorScheme.primary,
                  size: AppThemeConstants.iconSizeMD,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppThemeConstants.spacingMD,
            vertical: AppThemeConstants.spacingSM,
          ),
          labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6),
          ),
        ),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        dropdownColor: Theme.of(context).colorScheme.surface,
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Theme.of(context).colorScheme.primary,
          size: AppThemeConstants.iconSizeMD,
        ),
        menuMaxHeight: 200.0,
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusMD),
        elevation: AppThemeConstants.elevationMD.toInt(),
      ),
    );
  }
}

/// Gender Dropdown Widget
class GenderDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;

  const GenderDropdown({
    super.key,
    this.value,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return ThemedDropdown<String>(
      value: value,
      label: 'الجنس',
      prefixIcon: Icons.person_outline,
      validator: validator,
      items: const [
        DropdownMenuItem(value: 'MALE', child: Text('ذكر')),
        DropdownMenuItem(value: 'FEMALE', child: Text('أنثى')),
      ],
      onChanged: onChanged,
    );
  }
}

/// Role Dropdown Widget
class RoleDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;

  const RoleDropdown({
    super.key,
    this.value,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return ThemedDropdown<String>(
      value: value,
      label: 'نوع الحساب',
      prefixIcon: Icons.work_outline,
      validator: validator,
      items: const [
        DropdownMenuItem(value: 'User', child: Text('يوزر')),
        DropdownMenuItem(value: 'Owner', child: Text('اونر')),
        DropdownMenuItem(value: 'Admin', child: Text('ادمن')),
        DropdownMenuItem(value: 'Service provider', child: Text('سيرفس بروفايدر')),
      ],
      onChanged: onChanged,
    );
  }
}