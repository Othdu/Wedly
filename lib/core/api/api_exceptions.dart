/// Custom API Exceptions for better error handling
/// Maps HTTP status codes to meaningful error messages
abstract class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? details;

  const ApiException({
    required this.message,
    this.statusCode,
    this.details,
  });

  @override
  String toString() => 'ApiException: $message';
}

/// Network-related exceptions (no internet, timeout, etc.)
class NetworkException extends ApiException {
  const NetworkException({
    super.message = 'تحقق من اتصال الإنترنت',
    super.statusCode,
    super.details,
  });
}

/// Authentication/Authorization exceptions (401, 403)
class UnauthorizedException extends ApiException {
  const UnauthorizedException({
    super.message = 'انتهت صلاحية الجلسة، يرجى تسجيل الدخول مرة أخرى',
    super.statusCode = 401,
    super.details,
  });
}

/// Server-side exceptions (500, 502, 503, etc.)
class ServerException extends ApiException {
  const ServerException({
    super.message = 'خطأ في الخادم، حاول مرة أخرى',
    super.statusCode,
    super.details,
  });
}

/// Client-side exceptions (400, 404, 422, etc.)
class ClientException extends ApiException {
  const ClientException({
    super.message = 'البيانات المدخلة غير صحيحة',
    super.statusCode,
    super.details,
  });
}

/// Not Found exceptions (404)
class NotFoundException extends ApiException {
  const NotFoundException({
    super.message = 'البيانات المطلوبة غير موجودة',
    super.statusCode = 404,
    super.details,
  });
}

/// Validation exceptions (422)
class ValidationException extends ApiException {
  const ValidationException({
    super.message = 'البيانات المدخلة غير صحيحة',
    super.statusCode = 422,
    super.details,
  });
}

/// Timeout exceptions
class TimeoutException extends ApiException {
  const TimeoutException({
    super.message = 'انتهت مهلة الطلب، حاول مرة أخرى',
    super.statusCode,
    super.details,
  });
}

/// Unknown exceptions
class UnknownException extends ApiException {
  const UnknownException({
    super.message = 'حدث خطأ غير متوقع',
    super.statusCode,
    super.details,
  });
}

/// Exception factory for creating appropriate exceptions based on status code
class ApiExceptionFactory {
  static ApiException createException({
    required int statusCode,
    String? message,
    String? details,
  }) {
    switch (statusCode) {
      case 400:
        return ClientException(
          message: message ?? 'البيانات المدخلة غير صحيحة',
          statusCode: statusCode,
          details: details,
        );
      case 401:
        return UnauthorizedException(
          message: message ?? 'انتهت صلاحية الجلسة، يرجى تسجيل الدخول مرة أخرى',
          statusCode: statusCode,
          details: details,
        );
      case 403:
        return UnauthorizedException(
          message: message ?? 'ليس لديك صلاحية للوصول إلى هذا المورد',
          statusCode: statusCode,
          details: details,
        );
      case 404:
        return NotFoundException(
          message: message ?? 'البيانات المطلوبة غير موجودة',
          statusCode: statusCode,
          details: details,
        );
      case 422:
        return ValidationException(
          message: message ?? 'البيانات المدخلة غير صحيحة',
          statusCode: statusCode,
          details: details,
        );
      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(
          message: message ?? 'خطأ في الخادم، حاول مرة أخرى',
          statusCode: statusCode,
          details: details,
        );
      default:
        return UnknownException(
          message: message ?? 'حدث خطأ غير متوقع',
          statusCode: statusCode,
          details: details,
        );
    }
  }

  /// Parse error message from backend response
  static String parseErrorMessage(dynamic response) {
    if (response == null) return 'حدث خطأ غير متوقع';
    
    if (response is Map<String, dynamic>) {
      // Try different common error message fields
      if (response.containsKey('message')) {
        return response['message'].toString();
      }
      if (response.containsKey('error')) {
        return response['error'].toString();
      }
      if (response.containsKey('detail')) {
        return response['detail'].toString();
      }
      if (response.containsKey('errors')) {
        final errors = response['errors'];
        if (errors is Map<String, dynamic>) {
          // Get first error message
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            return firstError.first.toString();
          }
          return firstError.toString();
        }
        return errors.toString();
      }
    }
    
    return response.toString();
  }
}
