// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hall_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HallModel _$HallModelFromJson(Map<String, dynamic> json) => HallModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      address: json['address'] as String,
      capacity: (json['capacity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      features:
          (json['features'] as List<dynamic>).map((e) => e as String).toList(),
      contactPhone: json['contactPhone'] as String?,
      contactEmail: json['contactEmail'] as String?,
      amenities: json['amenities'] as Map<String, dynamic>?,
      isAvailable: json['isAvailable'] as bool? ?? true,
      isFeatured: json['isFeatured'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$HallModelToJson(HallModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'location': instance.location,
      'address': instance.address,
      'capacity': instance.capacity,
      'price': instance.price,
      'images': instance.images,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'features': instance.features,
      'contactPhone': instance.contactPhone,
      'contactEmail': instance.contactEmail,
      'amenities': instance.amenities,
      'isAvailable': instance.isAvailable,
      'isFeatured': instance.isFeatured,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

ServiceModel _$ServiceModelFromJson(Map<String, dynamic> json) => ServiceModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      provider: json['provider'] as String,
      price: (json['price'] as num).toDouble(),
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      features:
          (json['features'] as List<dynamic>).map((e) => e as String).toList(),
      contactPhone: json['contactPhone'] as String?,
      contactEmail: json['contactEmail'] as String?,
      details: json['details'] as Map<String, dynamic>?,
      isAvailable: json['isAvailable'] as bool? ?? true,
      isFeatured: json['isFeatured'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ServiceModelToJson(ServiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'provider': instance.provider,
      'price': instance.price,
      'images': instance.images,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'features': instance.features,
      'contactPhone': instance.contactPhone,
      'contactEmail': instance.contactEmail,
      'details': instance.details,
      'isAvailable': instance.isAvailable,
      'isFeatured': instance.isFeatured,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

ServiceCategoryModel _$ServiceCategoryModelFromJson(
        Map<String, dynamic> json) =>
    ServiceCategoryModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      nameAr: json['nameAr'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      image: json['image'] as String?,
      serviceCount: (json['serviceCount'] as num).toInt(),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ServiceCategoryModelToJson(
        ServiceCategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nameAr': instance.nameAr,
      'description': instance.description,
      'icon': instance.icon,
      'image': instance.image,
      'serviceCount': instance.serviceCount,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
