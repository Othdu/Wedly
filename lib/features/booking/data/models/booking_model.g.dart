// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) => BookingModel(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      hallId: (json['hallId'] as num?)?.toInt(),
      serviceId: (json['serviceId'] as num?)?.toInt(),
      eventDate: DateTime.parse(json['eventDate'] as String),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      guestCount: (json['guestCount'] as num).toInt(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: json['status'] as String,
      paymentStatus: json['paymentStatus'] as String,
      specialRequests: json['specialRequests'] as String?,
      notes: json['notes'] as String?,
      eventDetails: json['eventDetails'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      hall: json['hall'] == null
          ? null
          : BookingHallModel.fromJson(json['hall'] as Map<String, dynamic>),
      service: json['service'] == null
          ? null
          : BookingServiceModel.fromJson(
              json['service'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BookingModelToJson(BookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'hallId': instance.hallId,
      'serviceId': instance.serviceId,
      'eventDate': instance.eventDate.toIso8601String(),
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'guestCount': instance.guestCount,
      'totalPrice': instance.totalPrice,
      'status': instance.status,
      'paymentStatus': instance.paymentStatus,
      'specialRequests': instance.specialRequests,
      'notes': instance.notes,
      'eventDetails': instance.eventDetails,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'hall': instance.hall,
      'service': instance.service,
    };

BookingHallModel _$BookingHallModelFromJson(Map<String, dynamic> json) =>
    BookingHallModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      location: json['location'] as String,
      image: json['image'] as String?,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$BookingHallModelToJson(BookingHallModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'image': instance.image,
      'price': instance.price,
    };

BookingServiceModel _$BookingServiceModelFromJson(Map<String, dynamic> json) =>
    BookingServiceModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      category: json['category'] as String,
      image: json['image'] as String?,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$BookingServiceModelToJson(
        BookingServiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'image': instance.image,
      'price': instance.price,
    };

CreateBookingRequest _$CreateBookingRequestFromJson(
        Map<String, dynamic> json) =>
    CreateBookingRequest(
      hallId: (json['hallId'] as num?)?.toInt(),
      serviceId: (json['serviceId'] as num?)?.toInt(),
      eventDate: DateTime.parse(json['eventDate'] as String),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      guestCount: (json['guestCount'] as num).toInt(),
      specialRequests: json['specialRequests'] as String?,
      notes: json['notes'] as String?,
      eventDetails: json['eventDetails'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$CreateBookingRequestToJson(
        CreateBookingRequest instance) =>
    <String, dynamic>{
      'hallId': instance.hallId,
      'serviceId': instance.serviceId,
      'eventDate': instance.eventDate.toIso8601String(),
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'guestCount': instance.guestCount,
      'specialRequests': instance.specialRequests,
      'notes': instance.notes,
      'eventDetails': instance.eventDetails,
    };

UpdateBookingRequest _$UpdateBookingRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateBookingRequest(
      eventDate: json['eventDate'] == null
          ? null
          : DateTime.parse(json['eventDate'] as String),
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      guestCount: (json['guestCount'] as num?)?.toInt(),
      specialRequests: json['specialRequests'] as String?,
      notes: json['notes'] as String?,
      eventDetails: json['eventDetails'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$UpdateBookingRequestToJson(
        UpdateBookingRequest instance) =>
    <String, dynamic>{
      'eventDate': instance.eventDate?.toIso8601String(),
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'guestCount': instance.guestCount,
      'specialRequests': instance.specialRequests,
      'notes': instance.notes,
      'eventDetails': instance.eventDetails,
    };
