import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/api/api_exceptions.dart';
import '../models/booking_model.dart';

/// Remote data source for booking operations
/// Handles all API calls related to bookings
abstract class BookingRemoteDataSource {
  Future<List<BookingModel>> getBookings({
    int page = 1,
    int pageSize = 20,
    String? status,
  });
  Future<List<BookingModel>> getMyBookings();
  Future<BookingModel> getBookingDetails(int id);
  Future<BookingModel> createBooking(CreateBookingRequest request);
  Future<BookingModel> updateBooking(int id, UpdateBookingRequest request);
  Future<void> cancelBooking(int id);
  Future<void> deleteBooking(int id);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final ApiClient _apiClient;

  BookingRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<BookingModel>> getBookings({
    int page = 1,
    int pageSize = 20,
    String? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        ApiConstants.pageParam: page,
        ApiConstants.pageSizeParam: pageSize,
      };
      
      if (status != null && status.isNotEmpty) {
        queryParams[ApiConstants.statusParam] = status;
      }

      final response = await _apiClient.get(
        ApiConstants.bookingsEndpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'] ?? response.data;
        return data.map((json) => BookingModel.fromJson(json)).toList();
      } else {
        throw ApiExceptionFactory.createException(
          statusCode: response.statusCode ?? 0,
          message: ApiExceptionFactory.parseErrorMessage(response.data),
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException();
    }
  }

  @override
  Future<List<BookingModel>> getMyBookings() async {
    try {
      final response = await _apiClient.get(ApiConstants.myBookingsEndpoint);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'] ?? response.data;
        return data.map((json) => BookingModel.fromJson(json)).toList();
      } else {
        throw ApiExceptionFactory.createException(
          statusCode: response.statusCode ?? 0,
          message: ApiExceptionFactory.parseErrorMessage(response.data),
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException();
    }
  }

  @override
  Future<BookingModel> getBookingDetails(int id) async {
    try {
      final response = await _apiClient.get(ApiConstants.bookingDetailsEndpoint(id.toString()));

      if (response.statusCode == 200) {
        return BookingModel.fromJson(response.data);
      } else {
        throw ApiExceptionFactory.createException(
          statusCode: response.statusCode ?? 0,
          message: ApiExceptionFactory.parseErrorMessage(response.data),
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException();
    }
  }

  @override
  Future<BookingModel> createBooking(CreateBookingRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.bookingsEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return BookingModel.fromJson(response.data);
      } else {
        throw ApiExceptionFactory.createException(
          statusCode: response.statusCode ?? 0,
          message: ApiExceptionFactory.parseErrorMessage(response.data),
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException();
    }
  }

  @override
  Future<BookingModel> updateBooking(int id, UpdateBookingRequest request) async {
    try {
      final response = await _apiClient.put(
        ApiConstants.bookingDetailsEndpoint(id.toString()),
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return BookingModel.fromJson(response.data);
      } else {
        throw ApiExceptionFactory.createException(
          statusCode: response.statusCode ?? 0,
          message: ApiExceptionFactory.parseErrorMessage(response.data),
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException();
    }
  }

  @override
  Future<void> cancelBooking(int id) async {
    try {
      final response = await _apiClient.patch(
        ApiConstants.bookingDetailsEndpoint(id.toString()),
        data: {'status': 'cancelled'},
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiExceptionFactory.createException(
          statusCode: response.statusCode ?? 0,
          message: ApiExceptionFactory.parseErrorMessage(response.data),
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException();
    }
  }

  @override
  Future<void> deleteBooking(int id) async {
    try {
      final response = await _apiClient.delete(
        ApiConstants.bookingDetailsEndpoint(id.toString()),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiExceptionFactory.createException(
          statusCode: response.statusCode ?? 0,
          message: ApiExceptionFactory.parseErrorMessage(response.data),
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException();
    }
  }
}
