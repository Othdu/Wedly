import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_constants.dart';
import 'api_exceptions.dart';
import 'token_manager.dart';

/// API Client for making HTTP requests to the wedly-app backend
/// Handles authentication, error handling, and request/response transformation
class ApiClient {
  late final Dio _dio;
  
  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      sendTimeout: ApiConstants.sendTimeout,
      headers: {
        'Content-Type': ApiConstants.contentType,
        'Accept': ApiConstants.acceptHeader,
      },
    ));
    _setupInterceptors();
  }

  /// Setup Dio interceptors for authentication and error handling
  void _setupInterceptors() {
    // Request interceptor - Add authentication header
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          print('=== REQUEST INTERCEPTOR ===');
          print('URL: ${options.uri}');
          print('Method: ${options.method}');
          print('Headers: ${options.headers}');
          
          // Add authorization header if available
          final authHeader = await TokenManager.getAuthorizationHeader();
          if (authHeader != null) {
            options.headers[ApiConstants.authorizationHeader] = authHeader;
            print('Added auth header');
          }
          
          handler.next(options);
        },
        onError: (error, handler) async {
          print('=== INTERCEPTOR ERROR ===');
          print('Error Type: ${error.type}');
          print('Error Message: ${error.message}');
          print('Response Status: ${error.response?.statusCode}');
          print('Error Object: ${error.error}');
          print('Error Object Type: ${error.error.runtimeType}');
          
          // Handle 401 errors by trying to refresh token
          if (error.response?.statusCode == 401) {
            print('Attempting to refresh token...');
            try {
              final newToken = await TokenManager.refreshAccessToken();
              if (newToken != null) {
                print('Token refresh successful, retrying request');
                // Retry the original request with new token
                final options = error.requestOptions;
                options.headers[ApiConstants.authorizationHeader] = 
                    '${ApiConstants.bearerPrefix}$newToken';
                
                final response = await _dio.fetch(options);
                handler.resolve(response);
                return;
              }
            } catch (e) {
              print('Token refresh failed: $e');
              // Refresh failed, clear tokens and continue with error
              await TokenManager.clearTokens();
            }
          }
          
          // Convert DioException to ApiException
          print('Converting error to ApiException');
          final apiException = _handleDioException(error);
          print('ApiException type: ${apiException.runtimeType}');
          print('ApiException message: ${apiException.message}');
          
          handler.reject(DioException(
            requestOptions: error.requestOptions,
            error: apiException,
            type: error.type,
            response: error.response,
          ));
        },
      ),
    );

    // Logging interceptor (only in debug mode)
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) {
        // Only log in debug mode
        if (const bool.fromEnvironment('dart.vm.product') == false) {
          // Use debugPrint instead of print for better logging
          debugPrint('API: $obj');
        }
        },
      ),
    );
  }

  /// Handle DioException and convert to appropriate ApiException
  ApiException _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();
      
      case DioExceptionType.connectionError:
        return const NetworkException();
      
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        final message = ApiExceptionFactory.parseErrorMessage(error.response?.data);
        return ApiExceptionFactory.createException(
          statusCode: statusCode,
          message: message,
          details: error.response?.data?.toString(),
        );
      
      case DioExceptionType.cancel:
        return const NetworkException(message: 'تم إلغاء الطلب');
      
      case DioExceptionType.badCertificate:
        return const NetworkException(message: 'خطأ في شهادة الأمان');
      
      case DioExceptionType.unknown:
      default:
        return const UnknownException();
    }
  }

  /// Configure Dio with base settings
  void configure({
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
  }) {
    _dio.options.connectTimeout = connectTimeout ?? ApiConstants.connectTimeout;
    _dio.options.receiveTimeout = receiveTimeout ?? ApiConstants.receiveTimeout;
    _dio.options.sendTimeout = sendTimeout ?? ApiConstants.sendTimeout;
  }

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw e.error as ApiException;
    }
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      print('=== API CLIENT POST REQUEST ===');
      print('URL: ${ApiConstants.baseUrl}$path');
      print('Data: $data');
      print('Headers: ${options?.headers}');
      
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      
      print('=== API CLIENT POST RESPONSE ===');
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      
      return response;
    } on DioException catch (e) {
      print('=== API CLIENT ERROR ===');
      print('Error Type: ${e.type}');
      print('Error Message: ${e.message}');
      print('Response Status: ${e.response?.statusCode}');
      print('Response Data: ${e.response?.data}');
      print('Error Object Type: ${e.error?.runtimeType}');
      print('Error Object: ${e.error}');
      
      // Handle different error types
      if (e.error != null && e.error is ApiException) {
        throw e.error as ApiException;
      } else if (e.error != null && e.error is DioException) {
        // This is a nested DioException, handle it properly
        final nestedError = e.error as DioException;
        throw _handleDioException(nestedError);
      } else {
        // If there's no error in the DioException, convert it ourselves
        throw _handleDioException(e);
      }
    } on TypeError catch (e) {
      // This handles the case where the cast fails
      print('=== TYPE ERROR IN API CLIENT ===');
      print('Error: $e');
      print('Stack trace: ${StackTrace.current}');
      throw const UnknownException(message: 'Internal error occurred');
    } catch (e) {
      // Catch any other errors
      print('=== UNEXPECTED ERROR IN POST ===');
      print('Error: $e');
      print('Stack trace: ${StackTrace.current}');
      throw const UnknownException(message: 'Unexpected error occurred');
    }
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw e.error as ApiException;
    }
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw e.error as ApiException;
    }
  }

  /// PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw e.error as ApiException;
    }
  }

  /// Upload file
  Future<Response<T>> uploadFile<T>(
    String path,
    String filePath, {
    String fieldName = 'file',
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        ...?data,
      });

      return await _dio.post<T>(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw e.error as ApiException;
    }
  }

  /// Download file
  Future<Response> downloadFile(
    String path,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.download(
        path,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw e.error as ApiException;
    }
  }

  /// Cancel all pending requests
  void cancelAllRequests() {
    _dio.close(force: true);
  }
}

/// Singleton instance of ApiClient
final apiClient = ApiClient();
