import 'package:json_annotation/json_annotation.dart';

part 'hall_model.g.dart';

/// Hall model from backend API
@JsonSerializable()
class HallModel {
  final int id;
  final String name;
  final String description;
  final String location;
  final String address;
  final int capacity;
  final double price;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final List<String> features;
  final String? contactPhone;
  final String? contactEmail;
  final Map<String, dynamic>? amenities;
  final bool isAvailable;
  final bool isFeatured;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const HallModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.address,
    required this.capacity,
    required this.price,
    required this.images,
    required this.rating,
    required this.reviewCount,
    required this.features,
    this.contactPhone,
    this.contactEmail,
    this.amenities,
    this.isAvailable = true,
    this.isFeatured = false,
    this.createdAt,
    this.updatedAt,
  });

  factory HallModel.fromJson(Map<String, dynamic> json) =>
      _$HallModelFromJson(json);

  Map<String, dynamic> toJson() => _$HallModelToJson(this);

  /// Convert to domain FeaturedService entity
  FeaturedService toFeaturedService() {
    return FeaturedService(
      id: id.toString(),
      title: name,
      subtitle: description,
      imageUrl: images.isNotEmpty ? images.first : 'assets/images/logo.png',
      price: price.toInt(),
      rating: rating,
    );
  }

  /// Get formatted price
  String get formattedPrice => '${price.toStringAsFixed(0)} جنيه';

  /// Get formatted capacity
  String get formattedCapacity => '$capacity شخص';

  /// Get main image URL
  String get mainImageUrl => images.isNotEmpty ? images.first : 'assets/images/logo.png';

  /// Get all images as list
  List<String> get allImages => images.isNotEmpty ? images : ['assets/images/logo.png'];
}

/// Service model from backend API
@JsonSerializable()
class ServiceModel {
  final int id;
  final String name;
  final String description;
  final String category;
  final String provider;
  final double price;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final List<String> features;
  final String? contactPhone;
  final String? contactEmail;
  final Map<String, dynamic>? details;
  final bool isAvailable;
  final bool isFeatured;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.provider,
    required this.price,
    required this.images,
    required this.rating,
    required this.reviewCount,
    required this.features,
    this.contactPhone,
    this.contactEmail,
    this.details,
    this.isAvailable = true,
    this.isFeatured = false,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceModelToJson(this);

  /// Convert to domain FeaturedService entity
  FeaturedService toFeaturedService() {
    return FeaturedService(
      id: id.toString(),
      title: name,
      subtitle: description,
      imageUrl: images.isNotEmpty ? images.first : 'assets/images/logo.png',
      price: price.toInt(),
      rating: rating,
    );
  }

  /// Get formatted price
  String get formattedPrice => '${price.toStringAsFixed(0)} جنيه';

  /// Get main image URL
  String get mainImageUrl => images.isNotEmpty ? images.first : 'assets/images/logo.png';

  /// Get all images as list
  List<String> get allImages => images.isNotEmpty ? images : ['assets/images/logo.png'];
}

/// Service category model
@JsonSerializable()
class ServiceCategoryModel {
  final int id;
  final String name;
  final String nameAr;
  final String? description;
  final String? icon;
  final String? image;
  final int serviceCount;
  final bool isActive;
  final DateTime? createdAt;

  const ServiceCategoryModel({
    required this.id,
    required this.name,
    required this.nameAr,
    this.description,
    this.icon,
    this.image,
    required this.serviceCount,
    this.isActive = true,
    this.createdAt,
  });

  factory ServiceCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceCategoryModelToJson(this);

  /// Convert to domain ServiceCategory entity
  ServiceCategory toServiceCategory() {
    return ServiceCategory(
      id: id.toString(),
      name: nameAr, // Use Arabic name
      image: image ?? 'assets/images/logo.png',
      serviceCount: serviceCount,
    );
  }
}

/// Domain entities (matching existing home state)
class FeaturedService {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final int price;
  final double rating;

  const FeaturedService({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.price,
    required this.rating,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FeaturedService && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class ServiceCategory {
  final String id;
  final String name;
  final String image;
  final int serviceCount;

  const ServiceCategory({
    required this.id,
    required this.name,
    required this.image,
    required this.serviceCount,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServiceCategory && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
