import 'package:json_annotation/json_annotation.dart';

part 'booking_model.g.dart';

/// Booking model from backend API
@JsonSerializable()
class BookingModel {
  final int id;
  final int userId;
  final int? hallId;
  final int? serviceId;
  final DateTime eventDate;
  final DateTime startTime;
  final DateTime endTime;
  final int guestCount;
  final double totalPrice;
  final String status; // pending, confirmed, cancelled, completed
  final String paymentStatus; // pending, paid, failed, refunded
  final String? specialRequests;
  final String? notes;
  final Map<String, dynamic>? eventDetails;
  final DateTime createdAt;
  final DateTime updatedAt;
  final BookingHallModel? hall;
  final BookingServiceModel? service;

  const BookingModel({
    required this.id,
    required this.userId,
    this.hallId,
    this.serviceId,
    required this.eventDate,
    required this.startTime,
    required this.endTime,
    required this.guestCount,
    required this.totalPrice,
    required this.status,
    required this.paymentStatus,
    this.specialRequests,
    this.notes,
    this.eventDetails,
    required this.createdAt,
    required this.updatedAt,
    this.hall,
    this.service,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingModelToJson(this);

  /// Check if booking is confirmed
  bool get isConfirmed => status == 'confirmed';

  /// Check if booking is pending
  bool get isPending => status == 'pending';

  /// Check if booking is cancelled
  bool get isCancelled => status == 'cancelled';

  /// Check if booking is completed
  bool get isCompleted => status == 'completed';

  /// Check if payment is completed
  bool get isPaid => paymentStatus == 'paid';

  /// Get formatted event date
  String get formattedEventDate {
    final months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    return '${eventDate.day} ${months[eventDate.month - 1]} ${eventDate.year}';
  }

  /// Get formatted time range
  String get formattedTimeRange {
    final start = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    final end = '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
    return '$start - $end';
  }

  /// Get formatted total price
  String get formattedTotalPrice => '${totalPrice.toStringAsFixed(0)} جنيه';

  /// Get booking title
  String get title {
    if (hall != null) return hall!.name;
    if (service != null) return service!.name;
    return 'حجز';
  }

  /// Get booking subtitle
  String get subtitle {
    return '$formattedEventDate في $formattedTimeRange';
  }
}

/// Booking hall model (simplified hall info for bookings)
@JsonSerializable()
class BookingHallModel {
  final int id;
  final String name;
  final String location;
  final String? image;
  final double price;

  const BookingHallModel({
    required this.id,
    required this.name,
    required this.location,
    this.image,
    required this.price,
  });

  factory BookingHallModel.fromJson(Map<String, dynamic> json) =>
      _$BookingHallModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingHallModelToJson(this);
}

/// Booking service model (simplified service info for bookings)
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

/// Create booking request model
@JsonSerializable()
class CreateBookingRequest {
  final int? hallId;
  final int? serviceId;
  final DateTime eventDate;
  final DateTime startTime;
  final DateTime endTime;
  final int guestCount;
  final String? specialRequests;
  final String? notes;
  final Map<String, dynamic>? eventDetails;

  const CreateBookingRequest({
    this.hallId,
    this.serviceId,
    required this.eventDate,
    required this.startTime,
    required this.endTime,
    required this.guestCount,
    this.specialRequests,
    this.notes,
    this.eventDetails,
  });

  factory CreateBookingRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateBookingRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateBookingRequestToJson(this);
}

/// Update booking request model
@JsonSerializable()
class UpdateBookingRequest {
  final DateTime? eventDate;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? guestCount;
  final String? specialRequests;
  final String? notes;
  final Map<String, dynamic>? eventDetails;

  const UpdateBookingRequest({
    this.eventDate,
    this.startTime,
    this.endTime,
    this.guestCount,
    this.specialRequests,
    this.notes,
    this.eventDetails,
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
  final String paymentStatus;
  final String totalPrice;
  final String eventDate;
  final String timeRange;
  final int guestCount;
  final String? specialRequests;
  final String? imageUrl;

  const Booking({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.paymentStatus,
    required this.totalPrice,
    required this.eventDate,
    required this.timeRange,
    required this.guestCount,
    this.specialRequests,
    this.imageUrl,
  });

  factory Booking.fromModel(BookingModel model) {
    return Booking(
      id: model.id.toString(),
      title: model.title,
      subtitle: model.subtitle,
      status: model.status,
      paymentStatus: model.paymentStatus,
      totalPrice: model.formattedTotalPrice,
      eventDate: model.formattedEventDate,
      timeRange: model.formattedTimeRange,
      guestCount: model.guestCount,
      specialRequests: model.specialRequests,
      imageUrl: model.hall?.image ?? model.service?.image ?? 'assets/images/logo.png',
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
