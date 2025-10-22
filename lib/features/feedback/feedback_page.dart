import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/app_header.dart';
import '../reviews/presentation/bloc/reviews_bloc.dart';
import '../reviews/data/models/reviews_model.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int _selectedStars = 0; // 0 = all

  @override
  void initState() {
    super.initState();
    // Load reviews when page initializes
    context.read<ReviewsBloc>().add(const ReviewsLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to add review page
        },
        backgroundColor: AppColors.primaryGolden,
        icon: const Icon(Icons.edit, color: AppColors.white),
        label: const Text(
          'إضافة رأي',
          style: TextStyle(color: AppColors.white),
        ),
      ),
      body: BlocConsumer<ReviewsBloc, ReviewsState>(
        listener: (context, state) {
          if (state is ReviewsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorRed,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ReviewsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReviewsLoaded) {
            return _buildReviewsContent(state.reviews, state.averageRating, state.ratingCounts);
          } else if (state is ReviewsError) {
            return _buildErrorState(state.message);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildReviewsContent(List<Review> reviews, double averageRating, Map<int, int> ratingCounts) {
    final filtered = _selectedStars == 0
        ? reviews
        : reviews.where((r) => r.rating == _selectedStars).toList();

    return CustomScrollView(
      slivers: [
        // Header Section
        SliverToBoxAdapter(
          child: AppHeader(
            welcomeText: '',
            subtitleText: '',
            featureTitle: 'آراء العملاء',
            logo: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
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

        // Summary Header
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(AppConstants.spacingLG),
            padding: const EdgeInsets.all(AppConstants.spacingLG),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
              boxShadow: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkCardShadowMedium
                  : AppColors.cardShadowMedium,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            averageRating.toStringAsFixed(1),
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGolden,
                            ),
                          ),
                          _buildStarsRow(averageRating.round()),
                          Text(
                            'متوسط التقييم',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            reviews.length.toString(),
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGolden,
                            ),
                          ),
                          Text(
                            'إجمالي التقييمات',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingLG),
                // Rating breakdown
                ...List.generate(5, (index) {
                  final stars = 5 - index;
                  final count = ratingCounts[stars] ?? 0;
                  final percentage = reviews.isEmpty ? 0.0 : count / reviews.length;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Text('$stars'),
                        const SizedBox(width: 4),
                        const Icon(Icons.star, size: 16, color: AppColors.primaryGolden),
                        const SizedBox(width: 8),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: percentage,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGolden),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('$count'),
                      ],
                    ),
                  );
                }),
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
                final review = filtered[index];
                return _buildReviewCard(
                  context,
                  name: review.userName,
                  rating: review.rating,
                  date: review.formattedDate,
                  comment: review.comment,
                );
              },
              childCount: filtered.length,
            ),
          ),

        const SliverToBoxAdapter(
          child: SizedBox(height: AppConstants.spacingXXL + 20),
        ),
      ],
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingLG),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.errorRed,
            ),
            const SizedBox(height: AppConstants.spacingLG),
            Text(
              'حدث خطأ',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.spacingMD),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingLG),
            ElevatedButton(
              onPressed: () {
                context.read<ReviewsBloc>().add(const ReviewsLoadRequested());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGolden,
                foregroundColor: AppColors.white,
              ),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarsRow(int stars) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Icon(
          index < stars ? Icons.star : Icons.star_border,
          color: AppColors.primaryGolden,
          size: 20,
        );
      }),
    );
  }

  Widget _buildFilterChip(String label, int value) {
    final bool selected = _selectedStars == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedStars = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected 
              ? AppColors.primaryGolden.withOpacity(0.14) 
              : Theme.of(context).cardColor,
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
                color: selected 
                ? AppColors.primaryGolden 
                : Theme.of(context).textTheme.bodyMedium?.color,
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
      padding: const EdgeInsets.all(AppConstants.spacingLG),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkCardShadowSmall
            : AppColors.cardShadowSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppColors.goldenGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: AppColors.primaryGolden,
                            size: 16,
                          );
                        }),
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
            ],
          ),
          if (comment.isNotEmpty) ...[
            const SizedBox(height: AppConstants.spacingMD),
            Text(
              comment,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppConstants.spacingLG),
      padding: const EdgeInsets.all(AppConstants.spacingXXL),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        boxShadow: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkCardShadowMedium
            : AppColors.cardShadowMedium,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingLG),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.lightGray,
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
            ),
            child: const Icon(
              Icons.star_border,
              size: 64,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingLG),
          Text(
            'لا توجد تقييمات بعد',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMD),
          Text(
            'كن أول من يقيّم خدماتنا',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}