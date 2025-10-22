import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../data/datasources/home_remote_datasource.dart';
import '../../data/models/hall_model.dart'; // Import the models
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exceptions.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  HomeBloc({HomeRepository? homeRepository})
      : _homeRepository = homeRepository ?? HomeRepositoryImpl(
            remoteDataSource: HomeRemoteDataSourceImpl(
              apiClient: apiClient,
            ),
          ),
        super(const HomeInitial()) {
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
      // Fetch data from backend APIs
      final featuredServices = await _homeRepository.getFeaturedServices();
      final serviceCategories = await _homeRepository.getServiceCategories();
      final allServices = await _homeRepository.getAllServices();
      final featuredHalls = await _homeRepository.getFeaturedHalls();

      // Emit HomeLoaded with real data
      emit(HomeLoaded(
        featuredServices: featuredServices,
        serviceCategories: serviceCategories,
        allServices: allServices,
        featuredHalls: featuredHalls,
      ));
    } on NetworkException catch (e) {
      emit(HomeError(message: e.message));
    } on ServerException catch (e) {
      emit(HomeError(message: e.message));
    } catch (e) {
      emit(HomeError(message: 'حدث خطأ غير متوقع'));
    }
  }

  // ✅ When user taps on a category
  Future<void> _onServiceCategorySelected(
    HomeServiceCategorySelected event,
    Emitter<HomeState> emit,
  ) async {
    try {
      // Fetch services for the selected category
      final categoryServices = await _homeRepository.getServicesByCategory(event.categoryId);
      
      // Update state with category services
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        emit(currentState.copyWith(
          searchResults: categoryServices,
          searchQuery: event.categoryId,
          isSearching: true,
        ));
      }
    } catch (e) {
      // Handle error silently or show a snackbar
      // Error is handled by the UI layer
    }
  }

  // ✅ When user taps on a featured service
  Future<void> _onFeaturedServiceSelected(
    HomeFeaturedServiceSelected event,
    Emitter<HomeState> emit,
  ) async {
    // Navigate to service details page
    // This will be handled by the UI layer
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

    try {
      // Search services using the API
      final searchResults = await _homeRepository.searchServices(query);

      emit(currentState.copyWith(
        searchResults: searchResults,
        searchQuery: query,
        isSearching: true,
      ));
    } catch (e) {
      // Fallback to local search if API fails
    final List<FeaturedService> searchResults = [];
    
      // Search in all services
    for (final service in currentState.allServices) {
      if (service.title.toLowerCase().contains(query) ||
          service.subtitle.toLowerCase().contains(query)) {
        searchResults.add(service);
      }
    }
    
      // Search in categories
    for (final category in currentState.serviceCategories) {
      if (category.name.toLowerCase().contains(query)) {
          final categoryService = FeaturedService(
            id: 'category_${category.id}',
            title: category.name,
            subtitle: '${category.serviceCount} خدمة متاحة',
            imageUrl: category.image,
            price: 0,
            rating: 4.5,
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
