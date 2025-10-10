import 'package:flutter/material.dart';
import 'dart:async';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearch;
  final String? hintText;

  const SearchBarWidget({
    super.key,
    required this.onSearch,
    this.hintText,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _handleSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      widget.onSearch(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppConstants.spacingMD),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkCardShadowSmall
            : AppColors.cardShadowSmall,
        border: Border.all(
          color: AppColors.primaryGolden.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => _handleSearch(),
        style: TextStyle(
          fontSize: AppConstants.fontSizeMD,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'ابحث عن خدمات الزفاف...',
          hintStyle: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkTextTertiary
                : AppColors.textLight,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.primaryGolden,
            size: AppConstants.iconSizeMD,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.clear,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                    size: AppConstants.iconSizeSM,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingMD,
            vertical: AppConstants.spacingMD,
          ),
        ),
        onChanged: (value) {
          setState(() {});
          
          // إلغاء البحث السابق
          _debounceTimer?.cancel();
          
          // البحث الفوري أثناء الكتابة مع debounce
          _debounceTimer = Timer(const Duration(milliseconds: 300), () {
            if (value.trim().isNotEmpty) {
              widget.onSearch(value.trim());
            } else {
              // إذا كان النص فارغ، مسح البحث
              widget.onSearch('');
            }
          });
        },
      ),
    );
  }
}