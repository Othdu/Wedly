import 'package:flutter/material.dart';
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

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
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
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: AppColors.cardShadowSmall,
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
        style: const TextStyle(
          fontSize: AppConstants.fontSizeMD,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'ابحث عن خدمات الزفاف...',
          hintStyle: const TextStyle(
            color: AppColors.textLight,
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
                  icon: const Icon(
                    Icons.clear,
                    color: AppColors.textSecondary,
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
        },
      ),
    );
  }
}