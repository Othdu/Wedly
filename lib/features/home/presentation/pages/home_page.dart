import 'package:flutter/material.dart';
import 'dart:async';
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
import '../../../favorites/presentation/pages/favorites_page.dart';
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
      backgroundColor: AppColors.backgroundPrimary,
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
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: AppConstants.spacingMD),
                  Text(
                    'حدث خطأ في تحميل البيانات',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppConstants.spacingSM),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.spacingLG),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeBloc>().add(const HomeInitialized());
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (state is HomeLoaded) {
            return CustomScrollView(
              slivers: [
                // --- App Bar ---
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
                        borderRadius:
                            BorderRadius.circular(AppConstants.borderRadius),
                        boxShadow: AppColors.goldenShadowSmall,
                      ),
                      child: Text(
                        AppConstants.appName,
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
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.person_outline,
                        color: AppColors.primaryGolden,
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingSM),
                  ],
                ),

                // --- Welcome Header ---
                const SliverToBoxAdapter(child: WelcomeHeader()),

                // --- Search Bar ---
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingLG,
                    ),
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
                  child: SizedBox(height: AppConstants.spacingLG),
                ),

                // --- Main Feature Cards ---
               // --- Main Feature Cards ---
SliverToBoxAdapter(
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLG),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'خدماتنا الرئيسية',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppConstants.spacingMD),

        // ✅ Scrollable Animated Cards with indicators
        SizedBox(
          height: 240,
          child: _MainFeatureCarousel(
            onSelect: (title, subtitle) =>
                _showServiceDialog(context, title, subtitle),
          ),
        ),
      ],
    ),
  ),
),


                const SliverToBoxAdapter(
                  child: SizedBox(height: AppConstants.spacingLG),
                ),

                // --- Featured Services ---
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingLG,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'الخدمات المميزة',
                          style:
                              Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
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

                SliverToBoxAdapter(
                  child: Container(
                    height: 240,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: state.featuredServices.isNotEmpty
                            ? state.featuredServices.map((service) {
                                return Container(
                                  width: 250,
                                  margin: const EdgeInsets.only(right: 8),
                                  child: FeaturedServiceCard(
                                    service: service,
                                    onTap: () {
                                      context.read<HomeBloc>().add(
                                            HomeFeaturedServiceSelected(
                                              serviceId: service.id,
                                            ),
                                          );
                                    },
                                  ),
                                );
                              }).toList()
                            : [const SizedBox.shrink()],
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppConstants.spacingLG),
                ),

                // --- Service Categories ---
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingLG,
                    ),
                    child: Text(
                      'فئات الخدمات',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppConstants.spacingMD),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingLG,
                  ),
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
                        if (index >= state.serviceCategories.length ||
                            state.serviceCategories.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        final category = state.serviceCategories[index];
                        return ServiceCategoryCard(
                          category: category,
                          onTap: () {
                            context.read<HomeBloc>().add(
                                  HomeServiceCategorySelected(
                                    categoryId: category.id,
                                  ),
                                );
                          },
                        );
                      },
                      childCount: state.serviceCategories.isNotEmpty
                          ? state.serviceCategories.length
                          : 0,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppConstants.spacingXXL + 20),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  // --- Main Feature Card ---
  Widget _buildMainFeatureCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.mediumAnimationDuration,
        padding: const EdgeInsets.all(AppConstants.spacingMD),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius:
              BorderRadius.circular(AppConstants.borderRadiusLarge),
          border: Border.all(
            color: AppColors.primaryGolden.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGolden.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
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
                boxShadow: AppColors.goldenShadowSmall,
              ),
              child: Icon(
                icon,
                color: AppColors.white,
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
                color: AppColors.primaryGolden.withOpacity(0.1),
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusSmall),
              ),
              child: Text(
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

  // --- Dialog ---
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
              child: const Icon(
                Icons.info,
                color: AppColors.white,
                size: AppConstants.iconSizeMD,
              ),
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
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('استكشاف'),
          ),
        ],
      ),
    );
  }
}
class _MainFeatureCarousel extends StatefulWidget {
  final Function(String, String) onSelect;
  const _MainFeatureCarousel({required this.onSelect});

  @override
  State<_MainFeatureCarousel> createState() => _MainFeatureCarouselState();
}

class _MainFeatureCarouselState extends State<_MainFeatureCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.5);
  int _currentPage = 0;
  Timer? _autoPlayTimer;

  final List<Map<String, dynamic>> _services = [
    {
      'title': 'الحجز',
      'subtitle': 'أفضل قاعات الأفراح',
      'icon': Icons.event_seat,
    },
    {
      'title': 'التخطيطات',
      'subtitle': 'خدمات التخطيط الشاملة',
      'icon': Icons.event_note,
    },
    {
      'title': 'المتجر',
      'subtitle': 'جميع خدمات الزفاف',
      'icon': Icons.store,
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      final next = (_currentPage + 1) % _services.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    });
  }

  void _onScroll() {
    final page = _controller.page?.round() ?? 0;
    if (page != _currentPage) {
      setState(() {
        _currentPage = page;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    _autoPlayTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _controller,
            itemCount: _services.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  double value = 1.0;
                  if (_controller.position.haveDimensions) {
                    value = (_controller.page! - index).abs();
                    value = (1 - (value * 0.25)).clamp(0.85, 1.15);
                  }
                  return Center(
                    child: Transform.scale(
                      scale: value,
                      child: child,
                    ),
                  );
                },
                child: _buildCard(
                  context,
                  _services[index]['title']!,
                  _services[index]['subtitle']!,
                  _services[index]['icon']!,
                  () => widget.onSelect(
                    _services[index]['title']!,
                    _services[index]['subtitle']!,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_services.length, (i) {
            final isActive = i == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 6,
              width: isActive ? 18 : 6,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primaryGolden : AppColors.textSecondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius:
              BorderRadius.circular(AppConstants.borderRadiusLarge),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGolden.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMD),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: AppColors.primaryGolden),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
