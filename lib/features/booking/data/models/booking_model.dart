import 'package:json_annotation/json_annotation.dart';

part 'booking_model.g.dart';

/// Booking model from backend API
@JsonSerializable()
class BookingModel {
  final int id;
  final int userId;
  final int? venueId;
  final DateTime eventDate;
  final DateTime createdAt;
  final double? totalPrice;
  final String status; // PENDING, CONFIRMED, CANCELLED, COMPLETED
  final BookingVenueModel? venue;
  final List<ServiceBookingModel>? serviceBookings;

  const BookingModel({
    required this.id,
    required this.userId,
    this.venueId,
    required this.eventDate,
    required this.createdAt,
    this.totalPrice,
    required this.status,
    this.venue,
    this.serviceBookings,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingModelToJson(this);

  /// Check if booking is confirmed
  bool get isConfirmed => status == 'CONFIRMED';

  /// Check if booking is pending
  bool get isPending => status == 'PENDING';

  /// Check if booking is cancelled
  bool get isCancelled => status == 'CANCELLED';

  /// Check if booking is completed
  bool get isCompleted => status == 'COMPLETED';

  /// Get formatted event date
  String get formattedEventDate {
    final months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    return '${eventDate.day} ${months[eventDate.month - 1]} ${eventDate.year}';
  }

  /// Get formatted total price
  String get formattedTotalPrice => '${(totalPrice ?? calculatedTotal).toStringAsFixed(2)} جنيه';

  /// Get booking title
  String get title {
    if (venue != null) return venue!.name;
    return 'حجز';
  }

  /// Get booking subtitle
  String get subtitle {
    return venue?.address ?? 'الموقع غير محدد';
  }
  
  /// Calculate total from venue and services
  double get calculatedTotal {
    final venuePrice = venue?.pricePerDay ?? 0.0;
    final servicesTotal = serviceBookings?.fold<double>(
      0.0,
      (sum, serviceBooking) => sum + (serviceBooking.quantity * serviceBooking.price),
    ) ?? 0.0;
    return venuePrice + servicesTotal;
  }
}

/// Booking venue model (simplified venue info for bookings)
@JsonSerializable()
class BookingVenueModel {
  final int id;
  final String name;
  final String? address;
  final String? image;
  final double pricePerDay;

  const BookingVenueModel({
    required this.id,
    required this.name,
    this.address,
    this.image,
    required this.pricePerDay,
  });

  factory BookingVenueModel.fromJson(Map<String, dynamic> json) =>
      _$BookingVenueModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingVenueModelToJson(this);
}

/// Booking service model (for service bookings in a booking)
@JsonSerializable()
class BookingServiceModel {
  final int id;
  final String name;
  final String category;
  final String? image;
  final double price;

  const BookingServiceModel({
    required this.id,
    required this.name,
    required this.category,
    this.image,
    required this.price,
  });

  factory BookingServiceModel.fromJson(Map<String, dynamic> json) =>
      _$BookingServiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingServiceModelToJson(this);
}

/// Service booking model (services added to a booking)
@JsonSerializable()
class ServiceBookingModel {
  final int id;
  final BookingServiceModel service;
  final int quantity;
  final double price;

  const ServiceBookingModel({
    required this.id,
    required this.service,
    required this.quantity,
    required this.price,
  });

  factory ServiceBookingModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceBookingModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceBookingModelToJson(this);
}

/// Create booking request model
@JsonSerializable()
class CreateBookingRequest {
  final int venueId;
  final List<int>? serviceIds;
  final DateTime eventDate;

  const CreateBookingRequest({
    required this.venueId,
    this.serviceIds,
    required this.eventDate,
  });

  factory CreateBookingRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateBookingRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateBookingRequestToJson(this);
}

/// Update booking request model
@JsonSerializable()
class UpdateBookingRequest {
  final int? venueId;
  final List<int>? serviceIds;
  final DateTime? eventDate;

  const UpdateBookingRequest({
    this.venueId,
    this.serviceIds,
    this.eventDate,
  });

  factory UpdateBookingRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateBookingRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateBookingRequestToJson(this);
}

/// Domain booking entity (for UI state)
class Booking {
  final String id;
  final String title;
  final String subtitle;
  final String status;
  final String totalPrice;
  final String eventDate;
  final String? imageUrl;

  const Booking({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.totalPrice,
    required this.eventDate,
    this.imageUrl,
  });

  factory Booking.fromModel(BookingModel model) {
    return Booking(
      id: model.id.toString(),
      title: model.title,
      subtitle: model.subtitle,
      status: model.status,
      totalPrice: model.formattedTotalPrice,
      eventDate: model.formattedEventDate,
      imageUrl: model.venue?.image ?? 'assets/images/logo.png',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Booking && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
