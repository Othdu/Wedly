import '../../../../core/api/api_exceptions.dart';
import '../datasources/booking_remote_datasource.dart';
import '../models/booking_model.dart';

/// Repository interface for booking operations
abstract class BookingRepository {
  Future<List<Booking>> getBookings({
    int page = 1,
    int pageSize = 20,
    String? status,
  });
  Future<List<Booking>> getMyBookings();
  Future<Booking> getBookingDetails(int id);
  Future<Booking> createBooking({
    int? hallId,
    int? serviceId,
    required DateTime eventDate,
    required DateTime startTime,
    required DateTime endTime,
    required int guestCount,
    String? specialRequests,
    String? notes,
    Map<String, dynamic>? eventDetails,
  });
  Future<Booking> updateBooking({
    required int id,
    DateTime? eventDate,
    DateTime? startTime,
    DateTime? endTime,
    int? guestCount,
    String? specialRequests,
    String? notes,
    Map<String, dynamic>? eventDetails,
  });
  Future<void> cancelBooking(int id);
  Future<void> deleteBooking(int id);
}

/// Implementation of BookingRepository
class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource _remoteDataSource;

  BookingRepositoryImpl({required BookingRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<Booking>> getBookings({
    int page = 1,
    int pageSize = 20,
    String? status,
  }) async {
    try {
      final bookings = await _remoteDataSource.getBookings(
        page: page,
        pageSize: pageSize,
        status: status,
      );
      return bookings.map((booking) => Booking.fromModel(booking)).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException();
    }
  }

  @override
  Future<List<Booking>> getMyBookings() async {
    try {
      final bookings = await _remoteDataSource.getMyBookings();
      return bookings.map((booking) => Booking.fromModel(booking)).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException();
    }
  }

  @override
  Future<Booking> getBookingDetails(int id) async {
    try {
      final booking = await _remoteDataSource.getBookingDetails(id);
      return Booking.fromModel(booking);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException();
    }
  }

  @override
  Future<Booking> createBooking({
    int? hallId,
    int? serviceId,
    required DateTime eventDate,
    required DateTime startTime,
    required DateTime endTime,
    required int guestCount,
    String? specialRequests,
    String? notes,
    Map<String, dynamic>? eventDetails,
  }) async {
    try {
      final request = CreateBookingRequest(
        hallId: hallId,
        serviceId: serviceId,
        eventDate: eventDate,
        startTime: startTime,
        endTime: endTime,
        guestCount: guestCount,
        specialRequests: specialRequests,
        notes: notes,
        eventDetails: eventDetails,
      );
      
      final booking = await _remoteDataSource.createBooking(request);
      return Booking.fromModel(booking);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException();
    }
  }

  @override
  Future<Booking> updateBooking({
    required int id,
    DateTime? eventDate,
    DateTime? startTime,
    DateTime? endTime,
    int? guestCount,
    String? specialRequests,
    String? notes,
    Map<String, dynamic>? eventDetails,
  }) async {
    try {
      final request = UpdateBookingRequest(
        eventDate: eventDate,
        startTime: startTime,
        endTime: endTime,
        guestCount: guestCount,
        specialRequests: specialRequests,
        notes: notes,
        eventDetails: eventDetails,
      );
      
      final booking = await _remoteDataSource.updateBooking(id, request);
      return Booking.fromModel(booking);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException();
    }
  }

  @override
  Future<void> cancelBooking(int id) async {
    try {
      await _remoteDataSource.cancelBooking(id);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException();
    }
  }

  @override
  Future<void> deleteBooking(int id) async {
    try {
      await _remoteDataSource.deleteBooking(id);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException();
    }
  }
}
