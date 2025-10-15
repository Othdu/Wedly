import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitial()) {
    on<HomeInitialized>(_onHomeInitialized);
    on<HomeServiceCategorySelected>(_onServiceCategorySelected);
    on<HomeFeaturedServiceSelected>(_onFeaturedServiceSelected);
    on<HomeSearchRequested>(_onHomeSearchRequested);
    on<HomeSearchCleared>(_onHomeSearchCleared);
  }

  Future<void> _onHomeInitialized(
    HomeInitialized event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());

    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // ✅ جميع الخدمات المتاحة في التطبيق
      final allServices = [
        // قاعات الأفراح
        const FeaturedService(
          id: 'venue_1',
          title: 'قاعة الأفراح الملكية',
          subtitle: 'أفخم قاعات الأفراح في المدينة',
          imageUrl: 'assets/images/logo.png',
          price: 15000,
          rating: 4.8,
        ),
        const FeaturedService(
          id: 'venue_2',
          title: 'قاعة الجوهرة',
          subtitle: 'قاعة أنيقة في قلب المدينة',
          imageUrl: 'assets/images/logo.png',
          price: 12000,
          rating: 4.6,
        ),
        const FeaturedService(
          id: 'venue_3',
          title: 'قاعة النجوم',
          subtitle: 'قاعة حديثة بتقنيات متطورة',
          imageUrl: 'assets/images/logo.png',
          price: 10000,
          rating: 4.5,
        ),
        
        // التصوير والفيديو
        const FeaturedService(
          id: 'photo_1',
          title: 'تصوير فاخر',
          subtitle: 'أفضل مصورين الزفاف',
          imageUrl: 'assets/images/logo.png',
          price: 8000,
          rating: 4.9,
        ),
        const FeaturedService(
          id: 'photo_2',
          title: 'فيديو احترافي',
          subtitle: 'تصوير فيديو عالي الجودة',
          imageUrl: 'assets/images/logo.png',
          price: 6000,
          rating: 4.7,
        ),
        const FeaturedService(
          id: 'photo_3',
          title: 'درون تصوير',
          subtitle: 'تصوير جوي للحفلات',
          imageUrl: 'assets/images/logo.png',
          price: 4000,
          rating: 4.4,
        ),
        
        // فساتين الزفاف
        const FeaturedService(
          id: 'dress_1',
          title: 'فساتين زفاف فاخرة',
          subtitle: 'أجمل فساتين الزفاف',
          imageUrl: 'assets/images/logo.png',
          price: 12000,
          rating: 4.7,
        ),
        const FeaturedService(
          id: 'dress_2',
          title: 'فساتين عروس كلاسيكية',
          subtitle: 'فساتين أنيقة وكلاسيكية',
          imageUrl: 'assets/images/logo.png',
          price: 9000,
          rating: 4.6,
        ),
        const FeaturedService(
          id: 'dress_3',
          title: 'فساتين عروس عصرية',
          subtitle: 'فساتين حديثة ومبتكرة',
          imageUrl: 'assets/images/logo.png',
          price: 11000,
          rating: 4.8,
        ),
        
        // الديكور والزينة
        const FeaturedService(
          id: 'deco_1',
          title: 'ديكور زفاف راقي',
          subtitle: 'أفضل خدمات الديكور والزينة',
          imageUrl: 'assets/images/logo.png',
          price: 9000,
          rating: 4.6,
        ),
        const FeaturedService(
          id: 'deco_2',
          title: 'زهور طبيعية',
          subtitle: 'أجمل الزهور الطبيعية',
          imageUrl: 'assets/images/logo.png',
          price: 5000,
          rating: 4.5,
        ),
        const FeaturedService(
          id: 'deco_3',
          title: 'إضاءة احترافية',
          subtitle: 'إضاءة متطورة للحفلات',
          imageUrl: 'assets/images/logo.png',
          price: 3000,
          rating: 4.4,
        ),
        
        // الضيافة والطعام
        const FeaturedService(
          id: 'food_1',
          title: 'ضيافة مميزة',
          subtitle: 'أشهى الأطباق للحفلات',
          imageUrl: 'assets/images/logo.png',
          price: 7000,
          rating: 4.8,
        ),
        const FeaturedService(
          id: 'food_2',
          title: 'حلويات فاخرة',
          subtitle: 'أشهى الحلويات والحلو',
          imageUrl: 'assets/images/logo.png',
          price: 4000,
          rating: 4.7,
        ),
        const FeaturedService(
          id: 'food_3',
          title: 'مشروبات متنوعة',
          subtitle: 'مشروبات باردة وساخنة',
          imageUrl: 'assets/images/logo.png',
          price: 2000,
          rating: 4.3,
        ),
        
        // الموسيقى والترفيه
        const FeaturedService(
          id: 'music_1',
          title: 'موسيقى وترفيه',
          subtitle: 'أفضل الفرق الموسيقية',
          imageUrl: 'assets/images/logo.png',
          price: 5000,
          rating: 4.5,
        ),
        const FeaturedService(
          id: 'music_2',
          title: 'دي جي محترف',
          subtitle: 'أفضل دي جي للحفلات',
          imageUrl: 'assets/images/logo.png',
          price: 3000,
          rating: 4.4,
        ),
        const FeaturedService(
          id: 'music_3',
          title: 'فرقة موسيقية',
          subtitle: 'فرق موسيقية متنوعة',
          imageUrl: 'assets/images/logo.png',
          price: 6000,
          rating: 4.6,
        ),
        
        // النقل والمواصلات
        const FeaturedService(
          id: 'car_1',
          title: 'عربيات زفاف فاخرة',
          subtitle: 'أفخم السيارات للحفلات',
          imageUrl: 'assets/images/logo.png',
          price: 3000,
          rating: 4.4,
        ),
        const FeaturedService(
          id: 'car_2',
          title: 'ليموزين فاخر',
          subtitle: 'سيارات ليموزين راقية',
          imageUrl: 'assets/images/logo.png',
          price: 2500,
          rating: 4.3,
        ),
        const FeaturedService(
          id: 'car_3',
          title: 'سيارات كلاسيكية',
          subtitle: 'سيارات قديمة أنيقة',
          imageUrl: 'assets/images/logo.png',
          price: 2000,
          rating: 4.2,
        ),
        
        // التجميل والعناية
        const FeaturedService(
          id: 'makeup_1',
          title: 'ميكب ارتست محترف',
          subtitle: 'أفضل فناني التجميل',
          imageUrl: 'assets/images/logo.png',
          price: 2500,
          rating: 4.9,
        ),
        const FeaturedService(
          id: 'makeup_2',
          title: 'تسريحة شعر',
          subtitle: 'أفضل مصففي الشعر',
          imageUrl: 'assets/images/logo.png',
          price: 1500,
          rating: 4.7,
        ),
        const FeaturedService(
          id: 'makeup_3',
          title: 'عناية بالبشرة',
          subtitle: 'خدمات العناية بالبشرة',
          imageUrl: 'assets/images/logo.png',
          price: 2000,
          rating: 4.6,
        ),
        
        // خدمات إضافية
        const FeaturedService(
          id: 'extra_1',
          title: 'تخطيط زفاف شامل',
          subtitle: 'خدمات التخطيط الكاملة',
          imageUrl: 'assets/images/logo.png',
          price: 15000,
          rating: 4.8,
        ),
        const FeaturedService(
          id: 'extra_2',
          title: 'إدارة الحفل',
          subtitle: 'إدارة شاملة للحفل',
          imageUrl: 'assets/images/logo.png',
          price: 8000,
          rating: 4.7,
        ),
        const FeaturedService(
          id: 'extra_3',
          title: 'خدمات الضيافة',
          subtitle: 'خدمات ضيافة متكاملة',
          imageUrl: 'assets/images/logo.png',
          price: 6000,
          rating: 4.5,
        ),
      ];

      // ✅ الخدمات المميزة للعرض في الصفحة الرئيسية
      final featuredServices = allServices.take(8).toList();

      // ✅ Mock service categories (images only)
      final serviceCategories = [
        const ServiceCategory(
          id: 'venues',
          name: 'قاعات الأفراح',
          image: 'assets/images/004-wedding-arch.png',
          serviceCount: 25,
        ),
        // سيتم تزويد صورة لاحقاً
        const ServiceCategory(
          id: 'dresses',
          name: 'فساتين الزفاف',
          image: '',
          serviceCount: 18,
        ),
        const ServiceCategory(
          id: 'photography',
          name: 'التصوير والفيديو',
          image: 'assets/images/017-photography.png',
          serviceCount: 32,
        ),
        const ServiceCategory(
          id: 'catering',
          name: 'الضيافة والطعام',
          image: 'assets/images/011-wedding-dinner.png',
          serviceCount: 15,
        ),
        // سيتم تزويد صورة لاحقاً
        const ServiceCategory(
          id: 'decoration',
          name: 'الديكور والزينة',
          image: '',
          serviceCount: 22,
        ),
        // سيتم تزويد صورة لاحقاً
        const ServiceCategory(
          id: 'music',
          name: 'الموسيقى والترفيه',
          image: '',
          serviceCount: 12,
        ),
        const ServiceCategory(
          id: 'transportation',
          name: 'عربيات زفاف',
          image: 'assets/images/008-wedding-car.png',
          serviceCount: 12,
        ),
        // سيتم تزويد صورة لاحقاً
        const ServiceCategory(
          id: 'makeup',
          name: 'ميكب ارتست',
          image: '',
          serviceCount: 12,
        ),
        // سيتم تزويد صورة لاحقاً
        const ServiceCategory(
          id: 'wedding_planner',
          name: 'التوزيعات ',
          image: '',
          serviceCount: 12,
        ),
      ];

      // ✅ Emit HomeLoaded with data
      emit(HomeLoaded(
        featuredServices: featuredServices,
        serviceCategories: serviceCategories,
        allServices: allServices,
      ));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  // ✅ When user taps on a category
  Future<void> _onServiceCategorySelected(
    HomeServiceCategorySelected event,
    Emitter<HomeState> emit,
  ) async {
    // هنا ممكن تفتح صفحة الخدمات الخاصة بالكاتيجوري دي
    print("Category clicked: ${event.categoryId}");
  }

  // ✅ When user taps on a featured service
  Future<void> _onFeaturedServiceSelected(
    HomeFeaturedServiceSelected event,
    Emitter<HomeState> emit,
  ) async {
    // هنا ممكن تفتح صفحة تفاصيل الخدمة
    print("Featured Service clicked: ${event.serviceId}");
  }

  // ✅ When user searches for something
  Future<void> _onHomeSearchRequested(
    HomeSearchRequested event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeLoaded) return;
    
    final currentState = state as HomeLoaded;
    final query = event.query.toLowerCase().trim();
    
    if (query.isEmpty) {
      emit(currentState.copyWith(
        searchResults: [],
        searchQuery: null,
        isSearching: false,
      ));
      return;
    }

    // Simulate search delay
    await Future.delayed(const Duration(milliseconds: 200));

    // البحث في جميع الخدمات والفئات
    final List<FeaturedService> searchResults = [];
    
    // البحث في الخدمات
    for (final service in currentState.allServices) {
      if (service.title.toLowerCase().contains(query) ||
          service.subtitle.toLowerCase().contains(query)) {
        searchResults.add(service);
      }
    }
    
    // البحث في الفئات أيضاً (تحويل الفئات إلى خدمات للعرض)
    for (final category in currentState.serviceCategories) {
      if (category.name.toLowerCase().contains(query)) {
        // إنشاء خدمة وهمية من الفئة للعرض
        final categoryService = FeaturedService(
          id: 'category_${category.id}',
          title: category.name,
          subtitle: '${category.serviceCount} خدمة متاحة',
          imageUrl: 'assets/images/logo.png',
          price: 0, // سعر افتراضي للفئات
          rating: 4.5, // تقييم افتراضي للفئات
        );
        searchResults.add(categoryService);
      }
    }

    emit(currentState.copyWith(
      searchResults: searchResults,
      searchQuery: query,
      isSearching: true,
    ));
  }

  // ✅ When user clears search
  Future<void> _onHomeSearchCleared(
    HomeSearchCleared event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeLoaded) return;
    
    final currentState = state as HomeLoaded;
    emit(currentState.copyWith(
      searchResults: [],
      searchQuery: null,
      isSearching: false,
    ));
  }
}
