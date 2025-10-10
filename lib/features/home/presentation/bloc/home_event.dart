import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeInitialized extends HomeEvent {
  const HomeInitialized();
}

class HomeServiceCategorySelected extends HomeEvent {
  final String categoryId;

  const HomeServiceCategorySelected({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}

class HomeFeaturedServiceSelected extends HomeEvent {
  final String serviceId;

  const HomeFeaturedServiceSelected({required this.serviceId});

  @override
  List<Object> get props => [serviceId];
}

class HomeSearchRequested extends HomeEvent {
  final String query;

  const HomeSearchRequested({required this.query});

  @override
  List<Object> get props => [query];
}

class HomeSearchCleared extends HomeEvent {
  const HomeSearchCleared();
}