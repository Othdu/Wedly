import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

// --- UI and Service Events ---

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

// --- Ad Events (for Native or Banner Ads) ---

/// Triggered when the user opens the home screen and an ad should load.
class HomeAdRequested extends HomeEvent {
  final String factoryId; // e.g., 'listTile'
  const HomeAdRequested({required this.factoryId});

  @override
  List<Object> get props => [factoryId];
}

/// Triggered when an ad successfully loads.
class HomeAdLoaded extends HomeEvent {
  const HomeAdLoaded();
}

/// Triggered when ad fails to load, can retry or show fallback UI.
class HomeAdFailed extends HomeEvent {
  final String error;
  const HomeAdFailed(this.error);

  @override
  List<Object> get props => [error];
}

/// Triggered when user leaves or ad needs to be disposed.
class HomeAdDisposed extends HomeEvent {
  const HomeAdDisposed();
}
