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
        DropdownMenuItem(value: 'USER', child: Text('يوزر')),
        DropdownMenuItem(value: 'OWNER', child: Text('اونر')),
        DropdownMenuItem(value: 'ADMIN', child: Text('ادمن')),
        DropdownMenuItem(value: 'SERVICE', child: Text('مزود خدمات')),
      ],
      onChanged: onChanged,
    );
  }
}

/// Business Type Dropdown Widget
/// Shows available business categories for service providers
class BusinessTypeDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;

  const BusinessTypeDropdown({
    super.key,
    this.value,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    // Business types matching the backend BusinessType model
    final businessTypes = const [
      DropdownMenuItem(value: 'HALL', child: Text('قاعة أفراح')),
      DropdownMenuItem(value: 'MAKEUP', child: Text('فنان تجميل')),
      DropdownMenuItem(value: 'ATELIER', child: Text('أتيليه')),
      DropdownMenuItem(value: 'PHOTOGRAPHY', child: Text('تصوير وفيديو')),
      DropdownMenuItem(value: 'SUIT', child: Text('تأجير بدل')),
      DropdownMenuItem(value: 'DECOR', child: Text('ديكور وتصميم')),
      DropdownMenuItem(value: 'MUSIC', child: Text('موسيقى وترفيه')),
      DropdownMenuItem(value: 'CARS', child: Text('سيارات أفراح')),
      DropdownMenuItem(value: 'CATERING', child: Text('ضيافة واستقبال')),
      DropdownMenuItem(value: 'VIDEO', child: Text('إنتاج فيديو')),
      // Note: NONE is excluded as it's not a valid business type for registration
    ];

    return ThemedDropdown<String>(
      value: value,
      label: 'نوع النشاط التجاري',
      prefixIcon: Icons.store_outlined,
      validator: validator,
      items: businessTypes,
      onChanged: onChanged,
    );
  }
}