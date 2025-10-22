import 'package:equatable/equatable.dart';
import '../../data/models/hall_model.dart'; // Import the models from data layer

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<FeaturedService> featuredServices;
  final List<ServiceCategory> serviceCategories;
  final List<FeaturedService> allServices;
  final List<HallModel> featuredHalls;
  final List<FeaturedService> searchResults;
  final String? searchQuery;
  final bool isSearching;

  const HomeLoaded({
    required this.featuredServices,
    required this.serviceCategories,
    required this.allServices,
    required this.featuredHalls,
    this.searchResults = const [],
    this.searchQuery,
    this.isSearching = false,
  });

  HomeLoaded copyWith({
    List<FeaturedService>? featuredServices,
    List<ServiceCategory>? serviceCategories,
    List<FeaturedService>? allServices,
    List<HallModel>? featuredHalls,
    List<FeaturedService>? searchResults,
    String? searchQuery,
    bool? isSearching,
  }) {
    return HomeLoaded(
      featuredServices: featuredServices ?? this.featuredServices,
      serviceCategories: serviceCategories ?? this.serviceCategories,
      allServices: allServices ?? this.allServices,
      featuredHalls: featuredHalls ?? this.featuredHalls,
      searchResults: searchResults ?? this.searchResults,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  @override
  List<Object?> get props => [featuredServices, serviceCategories, allServices, featuredHalls, searchResults, searchQuery, isSearching];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object> get props => [message];
}