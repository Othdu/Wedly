// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) => BookingModel(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      venueId: (json['venueId'] as num?)?.toInt(),
      eventDate: DateTime.parse(json['eventDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      status: json['status'] as String,
      venue: json['venue'] == null
          ? null
          : BookingVenueModel.fromJson(json['venue'] as Map<String, dynamic>),
      serviceBookings: (json['serviceBookings'] as List<dynamic>?)
          ?.map((e) => ServiceBookingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BookingModelToJson(BookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'venueId': instance.venueId,
      'eventDate': instance.eventDate.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'totalPrice': instance.totalPrice,
      'status': instance.status,
      'venue': instance.venue,
      'serviceBookings': instance.serviceBookings,
    };

BookingVenueModel _$BookingVenueModelFromJson(Map<String, dynamic> json) =>
    BookingVenueModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      address: json['address'] as String?,
      image: json['image'] as String?,
      pricePerDay: (json['pricePerDay'] as num).toDouble(),
    );

Map<String, dynamic> _$BookingVenueModelToJson(BookingVenueModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'image': instance.image,
      'pricePerDay': instance.pricePerDay,
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

ServiceBookingModel _$ServiceBookingModelFromJson(Map<String, dynamic> json) =>
    ServiceBookingModel(
      id: (json['id'] as num).toInt(),
      service:
          BookingServiceModel.fromJson(json['service'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$ServiceBookingModelToJson(
        ServiceBookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'service': instance.service,
      'quantity': instance.quantity,
      'price': instance.price,
    };

CreateBookingRequest _$CreateBookingRequestFromJson(
        Map<String, dynamic> json) =>
    CreateBookingRequest(
      venueId: (json['venueId'] as num).toInt(),
      serviceIds: (json['serviceIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      eventDate: DateTime.parse(json['eventDate'] as String),
    );

Map<String, dynamic> _$CreateBookingRequestToJson(
        CreateBookingRequest instance) =>
    <String, dynamic>{
      'venueId': instance.venueId,
      'serviceIds': instance.serviceIds,
      'eventDate': instance.eventDate.toIso8601String(),
    };

UpdateBookingRequest _$UpdateBookingRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateBookingRequest(
      venueId: (json['venueId'] as num?)?.toInt(),
      serviceIds: (json['serviceIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      eventDate: json['eventDate'] == null
          ? null
          : DateTime.parse(json['eventDate'] as String),
    );

Map<String, dynamic> _$UpdateBookingRequestToJson(
        UpdateBookingRequest instance) =>
    <String, dynamic>{
      'venueId': instance.venueId,
      'serviceIds': instance.serviceIds,
      'eventDate': instance.eventDate?.toIso8601String(),
    };
