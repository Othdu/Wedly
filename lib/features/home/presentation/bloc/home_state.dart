import 'package:equatable/equatable.dart';

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
  final List<FeaturedService> searchResults;
  final String? searchQuery;
  final bool isSearching;

  const HomeLoaded({
    required this.featuredServices,
    required this.serviceCategories,
    required this.allServices,
    this.searchResults = const [],
    this.searchQuery,
    this.isSearching = false,
  });

  HomeLoaded copyWith({
    List<FeaturedService>? featuredServices,
    List<ServiceCategory>? serviceCategories,
    List<FeaturedService>? allServices,
    List<FeaturedService>? searchResults,
    String? searchQuery,
    bool? isSearching,
  }) {
    return HomeLoaded(
      featuredServices: featuredServices ?? this.featuredServices,
      serviceCategories: serviceCategories ?? this.serviceCategories,
      allServices: allServices ?? this.allServices,
      searchResults: searchResults ?? this.searchResults,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  @override
  List<Object?> get props => [featuredServices, serviceCategories, allServices, searchResults, searchQuery, isSearching];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object> get props => [message];
}

// Models
class FeaturedService {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final double price;
  final double rating;

  const FeaturedService({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.price,
    required this.rating,
  });
}

class ServiceCategory {
  final String id;
  final String name;
  final String icon;
  final int serviceCount;

  const ServiceCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.serviceCount,
  });
}