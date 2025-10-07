import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int _selectedStars = 0; // 0 = all

  final List<Map<String, dynamic>> _reviews = [
    {
      'name': 'أحمد علي',
      'rating': 5,
      'date': '2025-09-21',
      'comment': 'تجربة رائعة! التنظيم ممتاز والخدمة سريعة والموظفون محترفون جداً.',
    },
    {
      'name': 'سارة محمد',
      'rating': 4,
      'date': '2025-09-15',
      'comment': 'كل شيء جميل، فقط التأخير البسيط في الرد على الاستفسارات.',
    },
    {
      'name': 'زياد فهد',
      'rating': 3,
      'date': '2025-08-30',
      'comment': 'خدمة متوسطة. ممكن تتحسن تجربة الحجز وخيارات الدفع.',
    },
  ];

  double get _averageRating {
    if (_reviews.isEmpty) return 0;
    final total = _reviews.fold<int>(0, (sum, r) => sum + (r['rating'] as int));
    return total / _reviews.length;
  }

  Map<int, int> get _ratingCounts {
    final Map<int, int> counts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final r in _reviews) {
      final int rating = r['rating'] as int;
      if (counts.containsKey(rating)) counts[rating] = counts[rating]! + 1;
    }
    return counts;
  }

  double _ratingRatioFor(int stars) {
    if (_reviews.isEmpty) return 0.0;
    final counts = _ratingCounts;
    final int count = counts[stars] ?? 0;
    return count / _reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedStars == 0
        ? _reviews
        : _reviews.where((r) => r['rating'] == _selectedStars).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primaryGolden,
        icon: const Icon(Icons.edit, color: AppColors.white),
        label: const Text(
          'إضافة رأي',
          style: TextStyle(color: AppColors.white),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingMD,
                  vertical: AppConstants.spacingSM,
                ),
                decoration: BoxDecoration(
                  gradient: AppColors.goldenGradient,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  boxShadow: AppColors.goldenShadowSmall,
                ),
                child: Text(
                  'آراء العملاء',
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeXL,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
              titlePadding: const EdgeInsets.only(
                left: AppConstants.spacingLG,
                bottom: AppConstants.spacingMD,
              ),
            ),
          ),

          // Summary Header
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(AppConstants.spacingLG),
              padding: const EdgeInsets.all(AppConstants.spacingLG),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                boxShadow: AppColors.cardShadowMedium,
              ),
              child: Row(
                children: [
                  // Average Rating
                  Container(
                    width: 125,
                    padding: const EdgeInsets.all(AppConstants.spacingMD),
                    decoration: BoxDecoration(
                      gradient: AppColors.goldenGradient,
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                      boxShadow: AppColors.goldenShadowSmall,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _averageRating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: AppConstants.fontSizeXXXL,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        _buildStarsRow(_averageRating.round()),
                        const SizedBox(height: 6),
                        Text(
                          '${_reviews.length} تقييم',
                          style: TextStyle(
                            color: AppColors.white.withOpacity(0.9),
                            fontSize: AppConstants.fontSizeSM,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingLG),
                  // Distribution (based on current reviews)
                  Expanded(
                    child: Column(
                      children: [
                        _buildRatingBar(context, 5, _ratingRatioFor(5)),
                        _buildRatingBar(context, 4, _ratingRatioFor(4)),
                        _buildRatingBar(context, 3, _ratingRatioFor(3)),
                        _buildRatingBar(context, 2, _ratingRatioFor(2)),
                        _buildRatingBar(context, 1, _ratingRatioFor(1)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Filters
          SliverToBoxAdapter(
            child: SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLG),
                children: [
                  _buildFilterChip('الكل', 0),
                  const SizedBox(width: 8),
                  _buildFilterChip('5 نجوم', 5),
                  const SizedBox(width: 8),
                  _buildFilterChip('4 نجوم', 4),
                  const SizedBox(width: 8),
                  _buildFilterChip('3 نجوم', 3),
                  const SizedBox(width: 8),
                  _buildFilterChip('2 نجوم', 2),
                  const SizedBox(width: 8),
                  _buildFilterChip('1 نجمة', 1),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppConstants.spacingMD)),

          // Reviews List
          if (filtered.isEmpty)
            SliverToBoxAdapter(
              child: _buildEmptyState(context),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final r = filtered[index];
                  return _buildReviewCard(
                    context,
                    name: r['name'] as String,
                    rating: r['rating'] as int,
                    date: r['date'] as String,
                    comment: r['comment'] as String,
                  );
                },
                childCount: filtered.length,
              ),
            ),

          const SliverToBoxAdapter(
            child: SizedBox(height: AppConstants.spacingXXL + 20),
          ),
        ],
      ),
    );
  }

  Widget _buildStarsRow(int stars) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < stars;
        return Icon(
          filled ? Icons.star : Icons.star_border,
          color: AppColors.white,
          size: 18,
        );
      }),
    );
  }

  Widget _buildRatingBar(BuildContext context, int stars, double ratio) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Row(children: [
              Text('$stars', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(width: 2),
              const Icon(Icons.star, size: 14, color: AppColors.primaryGolden),
            ]),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  Container(height: 10, color: AppColors.lightGray),
                  FractionallySizedBox(
                    widthFactor: ratio.clamp(0.0, 1.0),
                    child: Container(height: 10, color: AppColors.primaryGolden.withOpacity(0.8)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int value) {
    final bool selected = _selectedStars == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedStars = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryGolden.withOpacity(0.14) : AppColors.white,
          border: Border.all(
            color: selected ? AppColors.primaryGolden : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          boxShadow: selected ? AppColors.goldenShadowSmall : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (value > 0) const Icon(Icons.star, size: 16, color: AppColors.primaryGolden),
            if (value > 0) const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.primaryGolden : AppColors.textPrimary,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(
    BuildContext context, {
    required String name,
    required int rating,
    required String date,
    required String comment,
  }) {
    String initials = name.isNotEmpty ? name.trim().split(' ').map((e) => e[0]).take(2).join() : '؟';

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingLG,
        vertical: AppConstants.spacingSM,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        boxShadow: AppColors.cardShadowMedium,
        border: Border.all(color: AppColors.primaryGolden.withOpacity(0.08)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primaryGolden.withOpacity(0.15),
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: AppColors.primaryGolden,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                      ),
                      Row(
                        children: [
                          Row(
                            children: List.generate(5, (i) => Icon(
                                  i < rating ? Icons.star : Icons.star_border,
                                  size: 16,
                                  color: AppColors.primaryGolden,
                                )),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            date,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingMD),
            Text(
              comment,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: AppConstants.spacingSM),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.thumb_up_alt_outlined, size: 18),
                  label: const Text('مفيد'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: BorderSide(color: Colors.grey.shade300),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingSM),
                TextButton(
                  onPressed: () {},
                  child: const Text('الإبلاغ'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppConstants.spacingLG),
      padding: const EdgeInsets.all(AppConstants.spacingXXL),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        boxShadow: AppColors.cardShadowMedium,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingLG),
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
            ),
            child: const Icon(
              Icons.rate_review_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingLG),
          Text(
            'لا توجد آراء بعد',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppConstants.spacingMD),
          Text(
            'كن أول من يشارك رأيه حول خدماتنا وتجربته معنا',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingLG),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined),
            label: const Text('أضف رأيك الآن'),
          ),
        ],
      ),
    );
  }
}
