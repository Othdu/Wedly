import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/api/api_exceptions.dart';
import '../../../../core/api/token_manager.dart';
import '../models/auth_models.dart';

/// Remote data source for authentication operations
/// Handles all API calls related to user authentication
abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequest request);
  Future<RegisterResponse> register(RegisterRequest request);
  Future<UserModel> getProfile();
  Future<void> logout();
  Future<void> requestPasswordReset(PasswordResetRequest request);
  Future<void> confirmPasswordReset(PasswordResetConfirmRequest request);
  Future<void> changePassword(ChangePasswordRequest request);
  Future<UserModel> updateProfile(UpdateProfileRequest request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.loginEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);
        
        // Save tokens securely
        await TokenManager.saveTokens(
          accessToken: loginResponse.access,
          refreshToken: loginResponse.refresh,
        );

        return loginResponse;
      } else {
        throw ApiExceptionFactory.createException(
          statusCode: response.statusCode ?? 0,
          message: ApiExceptionFactory.parseErrorMessage(response.data),
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException(message: 'Failed to login');
    }
  }

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.registerEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Register response data: ${response.data}');
        try {
          final registerResponse = RegisterResponse.fromJson(response.data);
          
          // Note: Registration API doesn't return tokens, user needs to login separately
          // Tokens will be saved during login process

          return registerResponse;
        } catch (e) {
          print('JSON parsing error: $e');
          throw const NetworkException(message: 'Failed to parse registration response');
        }
      } else {
        throw ApiExceptionFactory.createException(
          statusCode: response.statusCode ?? 0,
          message: ApiExceptionFactory.parseErrorMessage(response.data),
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException(message: 'Failed to register');
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await _apiClient.get(ApiConstants.profileEndpoint);

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw ApiExceptionFactory.createException(
          statusCode: response.statusCode ?? 0,
          message: ApiExceptionFactory.parseErrorMessage(response.data),
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException(message: 'Failed to fetch profile');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _apiClient.post(ApiConstants.logoutEndpoint);
      
      // Clear tokens from storage
      await TokenManager.clearTokens();
    } on ApiException {
      // Even if logout fails on server, clear local tokens
      await TokenManager.clearTokens();
      rethrow;
    } catch (e) {
      // Clear tokens even if request fails
      await TokenManager.clearTokens();
      throw const NetworkException(message: 'Failed to logout');
    }
  }

  @override
  Future<void> requestPasswordReset(PasswordResetRequest request) async {
    try {
      // Since password reset is not available in the API yet,
      // we'll simulate a successful response for now
      // TODO: Implement when API supports password reset
      
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      // For now, we'll just return success
      // In a real implementation, this would send an email
      print('Password reset requested for: ${request.email}');
      
    } catch (e) {
      throw const NetworkException(message: 'Failed to request password reset');
    }
  }

  @override
  Future<void> confirmPasswordReset(PasswordResetConfirmRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.passwordResetConfirmEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode != 200) {
        throw ApiExceptionFactory.createException(
          statusCode: response.statusCode ?? 0,
          message: ApiExceptionFactory.parseErrorMessage(response.data),
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException(message: 'Failed to confirm password reset');
    }
  }

  @override
  Future<void> changePassword(ChangePasswordRequest request) async {
    try {
      final response = await _apiClient.post(
        '/accounts/change-password/',
        data: request.toJson(),
      );

      if (response.statusCode != 200) {
        throw ApiExceptionFactory.createException(
          statusCode: response.statusCode ?? 0,
          message: ApiExceptionFactory.parseErrorMessage(response.data),
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException(message: 'Failed to change password');
    }
  }

  @override
  Future<UserModel> updateProfile(UpdateProfileRequest request) async {
    try {
      final response = await _apiClient.put(
        ApiConstants.profileEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw ApiExceptionFactory.createException(
          statusCode: response.statusCode ?? 0,
          message: ApiExceptionFactory.parseErrorMessage(response.data),
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException(message: 'Failed to update profile');
    }
  }
}