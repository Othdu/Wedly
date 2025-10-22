// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reviews_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => ReviewModel(
      id: (json['id'] as num).toInt(),
      userData: json['user'] as Map<String, dynamic>,
      hallData: json['hall'] as Map<String, dynamic>?,
      serviceData: json['service'] as Map<String, dynamic>?,
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.userData,
      'hall': instance.hallData,
      'service': instance.serviceData,
      'rating': instance.rating,
      'comment': instance.comment,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

ReviewRequest _$ReviewRequestFromJson(Map<String, dynamic> json) =>
    ReviewRequest(
      hallId: (json['hall_id'] as num?)?.toInt(),
      serviceId: (json['service_id'] as num?)?.toInt(),
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$ReviewRequestToJson(ReviewRequest instance) =>
    <String, dynamic>{
      'hall_id': instance.hallId,
      'service_id': instance.serviceId,
      'rating': instance.rating,
      'comment': instance.comment,
    };
