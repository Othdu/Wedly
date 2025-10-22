import 'package:json_annotation/json_annotation.dart';

part 'reviews_model.g.dart';

/// Review model from backend API
@JsonSerializable()
class ReviewModel {
  final int id;
  @JsonKey(name: 'user')
  final Map<String, dynamic> userData;
  @JsonKey(name: 'hall')
  final Map<String, dynamic>? hallData;
  @JsonKey(name: 'service')
  final Map<String, dynamic>? serviceData;
  final int rating;
  final String? comment;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const ReviewModel({
    required this.id,
    required this.userData,
    this.hallData,
    this.serviceData,
    required this.rating,
    this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);

  /// Convert to domain entity for UI
  Review toReview() {
    final userName = '${userData['first_name'] ?? ''} ${userData['last_name'] ?? ''}'.trim();
    final serviceName = hallData?['name'] ?? serviceData?['name'] ?? 'خدمة غير محددة';
    
    return Review(
      id: id.toString(),
      userName: userName.isNotEmpty ? userName : 'مستخدم',
      rating: rating,
      comment: comment ?? '',
      date: createdAt,
      serviceName: serviceName,
    );
  }
}

/// Request model for creating reviews
@JsonSerializable()
class ReviewRequest {
  @JsonKey(name: 'hall_id')
  final int? hallId;
  @JsonKey(name: 'service_id')
  final int? serviceId;
  final int rating;
  final String? comment;

  const ReviewRequest({
    this.hallId,
    this.serviceId,
    required this.rating,
    this.comment,
  });

  factory ReviewRequest.fromJson(Map<String, dynamic> json) =>
      _$ReviewRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewRequestToJson(this);
}

/// Domain entity for reviews (matching existing UI)
class Review {
  final String id;
  final String userName;
  final int rating;
  final String comment;
  final DateTime date;
  final String serviceName;

  const Review({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
    required this.serviceName,
  });

  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }

  String get initials {
    return userName.isNotEmpty 
        ? userName.trim().split(' ').map((e) => e[0]).take(2).join()
        : '؟';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Review && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
