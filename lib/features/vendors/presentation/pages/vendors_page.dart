import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/app_header.dart';

class VendorsPage extends StatefulWidget {
  const VendorsPage({super.key});

  @override
  State<VendorsPage> createState() => _VendorsPageState();
}

class _VendorsPageState extends State<VendorsPage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedCategoryIndex = 0;

  Future<void> _onRefresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> categories = <String>[
      'الكل',
      'قاعات',
      'تصوير',
      'مطاعم',
      'ديكور',
      'موسيقى',
    ];

    final List<_VendorItem> allVendors = <_VendorItem>[
      const _VendorItem(name: 'قاعة ليالي', category: 'قاعات', city: 'القاهرة', rating: 4.8, priceLabel: 'ابتداءً من 15,000ج'),
      const _VendorItem(name: 'ستوديو لحظة', category: 'تصوير', city: 'الجيزة', rating: 4.6, priceLabel: 'ابتداءً من 3,000ج'),
      const _VendorItem(name: 'مطعم النخيل', category: 'مطاعم', city: 'الإسكندرية', rating: 4.7, priceLabel: 'قوائم متنوعة'),
      const _VendorItem(name: 'لمسة ديكور', category: 'ديكور', city: 'القاهرة', rating: 4.5, priceLabel: 'مجموعات مميزة'),
      const _VendorItem(name: 'فرقة نغم', category: 'موسيقى', city: 'القاهرة', rating: 4.4, priceLabel: 'أغانٍ شرقية وغربية'),
      const _VendorItem(name: 'قاعة أوركيد', category: 'قاعات', city: 'القاهرة', rating: 4.9, priceLabel: 'ابتداءً من 22,000ج'),
    ];

    final String selectedCategory = categories[_selectedCategoryIndex];
    final String query = _searchController.text.trim();

    final List<_VendorItem> filtered = allVendors.where((
      _VendorItem v,
    ) {
      final bool matchesCategory = selectedCategory == 'الكل' || v.category == selectedCategory;
      final bool matchesQuery = query.isEmpty || v.name.contains(query) || v.city.contains(query);
      return matchesCategory && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.primaryGolden,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Header Section
            SliverToBoxAdapter(
              child: AppHeader(
                welcomeText: '',
                subtitleText: '',
                featureTitle: 'المتجر',
                logo: Container(
                  height: Responsive.hp(context, 0.05).clamp(32.0, 48.0),
                  width: Responsive.hp(context, 0.05).clamp(32.0, 48.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
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

            // Hero Section
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(AppConstants.spacingLG),
                padding: const EdgeInsets.all(AppConstants.spacingLG),
                decoration: BoxDecoration(
                  gradient: AppColors.goldenGradient,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                  boxShadow: AppColors.goldenShadowMedium,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'أفضل المنتجات والخدمات',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppConstants.spacingSM),
                          Text(
                            'اكتشف أفضل موردي خدمات الزفاف في مصر',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: AppConstants.spacingMD),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.spacingMD,
                              vertical: AppConstants.spacingSM,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                            ),
                            child: Text(
                              'أكثر من 200+ مورد',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingLG),
                    Container(
                      padding: const EdgeInsets.all(AppConstants.spacingMD),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                      ),
                      child: const Icon(
                        Icons.store,
                        size: 48,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search and Filters
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingLG,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                        boxShadow: AppColors.cardShadowSmall,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingMD,
                        vertical: AppConstants.spacingXS,
                      ),
                      child: TextField(
                        controller: _searchController,
                        textDirection: TextDirection.rtl,
                        textCapitalization: TextCapitalization.none,
                        textInputAction: TextInputAction.search,
                        autocorrect: false,
                        enableSuggestions: false,
                        smartDashesType: SmartDashesType.disabled,
                        smartQuotesType: SmartQuotesType.disabled,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search),
                          hintText: 'ابحث عن مورد أو مدينة...',
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingMD),
                    // Category Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List<Widget>.generate(categories.length, (int index) {
                          final bool selected = index == _selectedCategoryIndex;
                          return Padding(
                            padding: EdgeInsets.only(
                              right: index == 0 ? 0 : AppConstants.spacingSM,
                            ),
                            child: ChoiceChip(
                              label: Text(categories[index]),
                              selected: selected,
                              pressElevation: 0,
                              selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                              labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: selected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurfaceVariant,
                                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                              ),
                              side: BorderSide(
                                color: selected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.outlineVariant,
                              ),
                              onSelected: (_) {
                                setState(() {
                                  _selectedCategoryIndex = index;
                                });
                              },
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingLG),
                  ],
                ),
              ),
            ),

            // Vendors Grid
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.isLarge(context) || Responsive.isXLarge(context)
                    ? AppConstants.spacingXL
                    : AppConstants.spacingLG,
              ),
              sliver: filtered.isEmpty
                  ? SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.all(AppConstants.spacingXL),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                          boxShadow: AppColors.cardShadowMedium,
                        ),
                        child: Center(
                          child: Text(
                            'لا توجد نتائج مطابقة',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                ),
                          ),
                        ),
                      ),
                    )
                  : SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: Responsive.gridColumns(context, small: 2, medium: 3, large: 4, xlarge: 4),
                        mainAxisSpacing: AppConstants.spacingLG,
                        crossAxisSpacing: AppConstants.spacingLG,
                        childAspectRatio: Responsive.gridAspect(context, small: 0.8, medium: 0.9, large: 1.0),
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          final _VendorItem vendor = filtered[index];
                          return _VendorCard(vendor: vendor);
                        },
                        childCount: filtered.length,
                      ),
                    ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppConstants.spacingXXL ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VendorItem {
  const _VendorItem({
    required this.name,
    required this.category,
    required this.city,
    required this.rating,
    required this.priceLabel,
  });

  final String name;
  final String category;
  final String city;
  final double rating;
  final String priceLabel;
}

class _VendorCard extends StatelessWidget {
  const _VendorCard({required this.vendor});

  final _VendorItem vendor;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        boxShadow: AppColors.cardShadowMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 99,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppConstants.borderRadiusLarge),
                topRight: Radius.circular(AppConstants.borderRadiusLarge),
              ),
              gradient: AppColors.goldenGradient,
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      _iconForCategory(vendor.category),
                      color: AppColors.white.withOpacity(0.95),
                      size: 50,
                    ),
                  ),
                ),
                Positioned(
                  left: 8,
                  top: 8,
                  child: _RatingBadge(rating: vendor.rating),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border, color: Colors.white, size: 18),
                      onPressed: () {},
                      splashRadius: 18,
                      padding: const EdgeInsets.all(6),
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.scrim.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      vendor.priceLabel,
                      style: textTheme.labelSmall?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacingSM),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vendor.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                ),
                const SizedBox(height: AppConstants.spacingXS),
                Row(
                  children: [
                    Icon(Icons.place, size: 16, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        vendor.city,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? AppColors.lightGray
                            : colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        vendor.category,
                        style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingMD),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForCategory(String category) {
    switch (category) {
      case 'قاعات':
        return Icons.meeting_room;
      case 'تصوير':
        return Icons.photo_camera;
      case 'مطاعم':
        return Icons.restaurant;
      case 'ديكور':
        return Icons.chair_alt;
      case 'موسيقى':
        return Icons.music_note;
      default:
        return Icons.store;
    }
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 14, color: Colors.amber),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
