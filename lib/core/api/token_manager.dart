import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'api_constants.dart';
import 'api_exceptions.dart';

/// Token Manager for handling JWT tokens securely
/// Manages access tokens, refresh tokens, and automatic token refresh
class TokenManager {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Storage keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiryKey = 'token_expiry';

  /// Save JWT tokens securely
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    DateTime? expiresAt,
  }) async {
    try {
      await _storage.write(key: _accessTokenKey, value: accessToken);
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
      
      if (expiresAt != null) {
        await _storage.write(
          key: _tokenExpiryKey, 
          value: expiresAt.millisecondsSinceEpoch.toString(),
        );
      }
    } catch (e) {
      throw const NetworkException(message: 'فشل في حفظ بيانات المصادقة');
    }
  }

  /// Get access token
  static Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: _accessTokenKey);
    } catch (e) {
      return null;
    }
  }

  /// Get refresh token
  static Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _refreshTokenKey);
    } catch (e) {
      return null;
    }
  }

  /// Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final accessToken = await getAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }

  /// Check if access token is expired
  static Future<bool> isTokenExpired() async {
    try {
      final expiryString = await _storage.read(key: _tokenExpiryKey);
      if (expiryString == null) return true;
      
      final expiry = DateTime.fromMillisecondsSinceEpoch(int.parse(expiryString));
      return DateTime.now().isAfter(expiry);
    } catch (e) {
      return true;
    }
  }

  /// Clear all stored tokens
  static Future<void> clearTokens() async {
    try {
      await _storage.delete(key: _accessTokenKey);
      await _storage.delete(key: _refreshTokenKey);
      await _storage.delete(key: _tokenExpiryKey);
    } catch (e) {
      // Ignore errors when clearing tokens
    }
  }

  /// Refresh access token using refresh token
  static Future<String?> refreshAccessToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) {
        throw const UnauthorizedException(message: 'لا يوجد رمز تحديث صالح');
      }

      final dio = Dio();
      final response = await dio.post(
        '${ApiConstants.baseUrl}${ApiConstants.tokenRefreshEndpoint}',
        data: {'refresh': refreshToken},
        options: Options(
          headers: {
            'Content-Type': ApiConstants.contentType,
            'Accept': ApiConstants.acceptHeader,
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final newAccessToken = data['access'];
        
        if (newAccessToken != null) {
          // Save new access token
          await _storage.write(key: _accessTokenKey, value: newAccessToken);
          
          // Update expiry if provided
          if (data['expires_in'] != null) {
            final expiresAt = DateTime.now().add(
              Duration(seconds: data['expires_in']),
            );
            await _storage.write(
              key: _tokenExpiryKey,
              value: expiresAt.millisecondsSinceEpoch.toString(),
            );
          }
          
          return newAccessToken;
        }
      }
      
      throw const UnauthorizedException(message: 'فشل في تحديث الرمز المميز');
    } catch (e) {
      if (e is ApiException) rethrow;
      
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          throw const TimeoutException();
        }
        
        if (e.response?.statusCode == 401) {
          throw const UnauthorizedException(message: 'انتهت صلاحية رمز التحديث');
        }
        
        throw ServerException(
          message: ApiExceptionFactory.parseErrorMessage(e.response?.data),
          statusCode: e.response?.statusCode,
        );
      }
      
      throw const NetworkException();
    }
  }

  /// Get authorization header value
  static Future<String?> getAuthorizationHeader() async {
    final accessToken = await getAccessToken();
    if (accessToken == null) return null;
    
    return '${ApiConstants.bearerPrefix}$accessToken';
  }

  /// Validate and refresh token if needed
  static Future<String?> getValidAccessToken() async {
    try {
      // Check if we have a token
      final accessToken = await getAccessToken();
      if (accessToken == null) return null;
      
      // Check if token is expired
      final isExpired = await isTokenExpired();
      if (!isExpired) return accessToken;
      
      // Try to refresh the token
      return await refreshAccessToken();
    } catch (e) {
      // If refresh fails, clear tokens and return null
      await clearTokens();
      return null;
    }
  }
}
