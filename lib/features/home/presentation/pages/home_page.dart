import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';
import '../bloc/home_event.dart';
import '../widgets/featured_service_card.dart';
import '../widgets/service_category_card.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/welcome_header.dart';
import '../../../quick_access/presentation/pages/quick_access_page.dart';
import '../../../vendors/presentation/pages/vendors_page.dart';
import '../../../feedback/feedback_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../../shared/widgets/bottom_nav/bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const VendorsPage(),
    const QuickAccessPage(),
    const FeedbackPage(),
    const ProfilePage(),
  ];

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.primaryGolden),
              ),
            );
          }

          if (state is HomeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 64, color: AppColors.error),
                  const SizedBox(height: AppConstants.spacingMD),
                  Text(
                    'حدث خطأ في تحميل البيانات',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppConstants.spacingSM),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.spacingLG),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeBloc>().add(const HomeInitialized());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGolden,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppConstants.borderRadius),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'إعادة المحاولة',
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is HomeLoaded) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // App Bar
                SliverAppBar(
                  backgroundColor: AppColors.white,
                  elevation: 0,
                  pinned: true,
                  expandedHeight: 100,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    titlePadding:
                        const EdgeInsets.only(bottom: AppConstants.spacingSM),
                    title: Text(
                      AppConstants.appName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGolden,
                        fontSize: AppConstants.fontSizeXL,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.person_outline,
                          color: AppColors.primaryGolden),
                    ),
                    const SizedBox(width: AppConstants.spacingSM),
                  ],
                ),

                // Welcome Header
                const SliverToBoxAdapter(child: WelcomeHeader()),
                const SliverToBoxAdapter(
                    child: SizedBox(height: AppConstants.spacingLG)),

                // Search Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingLG),
                    child: SearchBarWidget(
                      onSearch: (query) {
                        context
                            .read<HomeBloc>()
                            .add(HomeSearchRequested(query: query));
                      },
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                    child: SizedBox(height: AppConstants.spacingXL)),

                // Main Feature Cards
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingLG),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'خدماتنا الرئيسية',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: AppConstants.spacingMD),
                        Row(
                          children: [
                            Expanded(
                              child: _buildMainFeatureCard(
                                context,
                                'حجز القاعات',
                                'أفضل قاعات الأفراح',
                                Icons.event_seat,
                                () => _showServiceDialog(context, 'حجز القاعات',
                                    'قاعات الأفراح الفاخرة'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildMainFeatureCard(
                                context,
                                'التخطيطات',
                                'خدمات التخطيط الشاملة',
                                Icons.event_note,
                                () => _showServiceDialog(
                                    context,
                                    'تخطيط الزفاف',
                                    'خدمات التخطيط الشاملة'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildMainFeatureCard(
                                context,
                                'المتجر',
                                'جميع خدمات الزفاف',
                                Icons.store,
                                () => _showServiceDialog(context, 'المتجر',
                                    'جميع خدمات ومنتجات الزفاف'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                    child: SizedBox(height: AppConstants.spacingXL)),

                // Featured Services Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingLG),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'الخدمات المميزة',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'عرض الكل',
                            style: TextStyle(
                              color: AppColors.primaryGolden,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                    child: SizedBox(height: AppConstants.spacingSM)),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 240,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: AppConstants.spacingSM),
                      itemCount: state.featuredServices.length,
                      itemBuilder: (context, index) {
                        final service = state.featuredServices[index];
                        return SizedBox(
                          width: 250,
                          child: FeaturedServiceCard(
                            service: service,
                            onTap: () {
                              context.read<HomeBloc>().add(
                                  HomeFeaturedServiceSelected(
                                      serviceId: service.id));
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                    child: SizedBox(height: AppConstants.spacingXL)),

                // Service Categories Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingLG),
                    child: Text(
                      'فئات الخدمات',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                    child: SizedBox(height: AppConstants.spacingMD)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingLG),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (state.serviceCategories.isEmpty ||
                            index >= state.serviceCategories.length) {
                          return const SizedBox.shrink();
                        }
                        final category = state.serviceCategories[index];
                        return ServiceCategoryCard(
                          category: category,
                          onTap: () => context.read<HomeBloc>().add(
                                HomeServiceCategorySelected(
                                    categoryId: category.id),
                              ),
                        );
                      },
                      childCount: state.serviceCategories.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                    child: SizedBox(height: AppConstants.spacingXXL + 20)),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildMainFeatureCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingMD),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius:
              BorderRadius.circular(AppConstants.borderRadiusLarge),
          border: Border.all(
            color: AppColors.primaryGolden.withOpacity(0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingLG),
              decoration: BoxDecoration(
                gradient: AppColors.goldenGradient,
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusLarge),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: AppConstants.iconSizeXL,
              ),
            ),
            const SizedBox(height: AppConstants.spacingMD),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingSM),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppConstants.spacingSM),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingSM,
                vertical: AppConstants.spacingXS,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryGolden.withOpacity(0.08),
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusSmall),
              ),
              child: const Text(
                'اضغط للاستكشاف',
                style: TextStyle(
                  color: AppColors.primaryGolden,
                  fontSize: AppConstants.fontSizeXS,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showServiceDialog(
      BuildContext context, String title, String description) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(AppConstants.borderRadiusLarge),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingSM),
              decoration: BoxDecoration(
                gradient: AppColors.goldenGradient,
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadius),
              ),
              child: const Icon(Icons.info,
                  color: AppColors.white, size: AppConstants.iconSizeMD),
            ),
            const SizedBox(width: AppConstants.spacingMD),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.primaryGolden,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إغلاق'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGolden,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusSmall),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('استكشاف'),
          ),
        ],
      ),
    );
  }
}
