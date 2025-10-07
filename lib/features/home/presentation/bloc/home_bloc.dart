import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitial()) {
    on<HomeInitialized>(_onHomeInitialized);
    on<HomeServiceCategorySelected>(_onServiceCategorySelected);
    on<HomeFeaturedServiceSelected>(_onFeaturedServiceSelected);
    on<HomeSearchRequested>(_onHomeSearchRequested);
  }

  Future<void> _onHomeInitialized(
    HomeInitialized event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());

    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // ✅ Mock featured services (أصغر 8px لما تتعرض في UI)
      final featuredServices = [
        const FeaturedService(
          id: '1',
          title: 'قاعة الأفراح الملكية',
          subtitle: 'أفخم قاعات الأفراح في المدينة',
          imageUrl:
              'https://static.sayidaty.net/styles/900_scale/public/2018/04/01/3533171-1883136246.jpg.webp',
          price: 15000,
          rating: 4.8,
        ),
        const FeaturedService(
          id: '2',
          title: 'تصوير فاخر',
          subtitle: 'أفضل مصورين الزفاف',
          imageUrl:
              'https://www.arabiaweddings.com/sites/default/files/styles/max980/public/listing/2021/07/24/wedding_photographer.jpg?itok=kRnPULAO=800',
          price: 8000,
          rating: 4.9,
        ),
      ];

      // ✅ Mock service categories (كليكابل)
      final serviceCategories = [
        const ServiceCategory(
          id: 'venues',
          name: 'قاعات الأفراح',
          icon: 'venue',
          serviceCount: 25,
        ),
        const ServiceCategory(
          id: 'dresses',
          name: 'فساتين الزفاف',
          icon: 'dress',
          serviceCount: 18,
        ),
        const ServiceCategory(
          id: 'photography',
          name: 'التصوير والفيديو',
          icon: 'camera',
          serviceCount: 32,
        ),
        const ServiceCategory(
          id: 'catering',
          name: 'الضيافة والطعام',
          icon: 'food',
          serviceCount: 15,
        ),
        const ServiceCategory(
          id: 'decoration',
          name: 'الديكور والزينة',
          icon: 'flower',
          serviceCount: 22,
        ),
        const ServiceCategory(
          id: 'music',
          name: 'الموسيقى والترفيه',
          icon: 'music',
          serviceCount: 12,
        ),
      ];

      // ✅ Emit HomeLoaded with data
      emit(HomeLoaded(
        featuredServices: featuredServices,
        serviceCategories: serviceCategories,
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
    // Handle search
    print("Search requested for: ${event.query}");
  }
}
