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
      print('=== LOGIN REQUEST ===');
      print('User Input: ${request.email}');
      print('Password length: ${request.password.length}');
      
      // طباعة البيانات المرسلة للAPI
      final requestData = request.toJson();
      print('Request JSON: $requestData');
      final loginType = requestData.containsKey('email') ? 'Email' : 'Username';
      final loginValue = loginType == 'Email' ? requestData['email'] : requestData['username'];
      print('Login Type: $loginType');
      print('Login Value: $loginValue');
      
      final response = await _apiClient.post(
        ApiConstants.loginEndpoint,
        data: requestData,
      );

      print('=== LOGIN RESPONSE ===');
      print('Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Data: ${response.data}');
      print('Response Data Type: ${response.data.runtimeType}');
      
      // Check if response.data is what we expect
      if (response.data is! Map<String, dynamic>) {
        print('ERROR: Response data is not a Map<String, dynamic>');
        print('Expected: Map<String, dynamic>');
        print('Actual: ${response.data.runtimeType}');
        throw const NetworkException(message: 'استجابة غير متوقعة من الخادم');
      }
      
      final data = response.data as Map<String, dynamic>;
      print('Response keys: ${data.keys.toList()}');

      if (response.statusCode == 200) {
        try {
          // Check if required keys exist
          if (!data.containsKey('access')) {
            print('ERROR: Response missing "access" token');
            throw const NetworkException(message: 'الاستجابة لا تحتوي على رمز الوصول');
          }
          if (!data.containsKey('refresh')) {
            print('ERROR: Response missing "refresh" token');
            throw const NetworkException(message: 'الاستجابة لا تحتوي على رمز التحديث');
          }
          
          print('Required keys present, parsing login response');
          
          // If user data is not in response, create a minimal user object
          Map<String, dynamic> responseWithUser = Map<String, dynamic>.from(data);
          if (!data.containsKey('user')) {
            print('User data not in response, creating minimal user object');
            responseWithUser['user'] = {
              'id': 0,
              'email': '',  // We'll get this from profile if needed
              'firstName': '',
              'lastName': '',
              'phone': null,
              'profileImage': null,
              'isActive': true,
              'isVerified': false,
              'dateJoined': null,
              'lastLogin': null,
              'userType': null,
            };
          }
          
          final loginResponse = LoginResponse.fromJson(responseWithUser);
          
          // Save tokens securely
          await TokenManager.saveTokens(
            accessToken: loginResponse.access,
            refreshToken: loginResponse.refresh,
          );

          print('Login successful - tokens saved');
          print('Access token: ${loginResponse.access.substring(0, 20)}...');
          
          // If user data is empty, try to fetch profile
          if (loginResponse.user.email.isEmpty) {
            print('User data not in response, will fetch from profile endpoint');
          } else {
            print('Login successful for: ${loginResponse.user.email}');
          }
          
          return loginResponse;
        } on TypeError catch (e) {
          print('Type Error in JSON parsing: $e');
          print('Raw response data: ${response.data}');
          throw const NetworkException(message: 'فشل في تحليل استجابة تسجيل الدخول - خطأ في نوع البيانات');
        } on FormatException catch (e) {
          print('Format Error in JSON parsing: $e');
          print('Raw response data: ${response.data}');
          throw const NetworkException(message: 'فشل في تحليل استجابة تسجيل الدخول - تنسيق البيانات غير صحيح');
        } catch (e) {
          print('JSON parsing error: $e');
          print('Error type: ${e.runtimeType}');
          print('Raw response data: ${response.data}');
          throw NetworkException(message: 'فشل في تحليل استجابة تسجيل الدخول: ${e.toString()}');
        }
      } else {
        final errorMessage = ApiExceptionFactory.parseErrorMessage(response.data);
        print('Login failed with status ${response.statusCode}: $errorMessage');
        throw ApiExceptionFactory.createException(
          statusCode: response.statusCode ?? 0,
          message: errorMessage,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      print('Login error: $e');
      throw const NetworkException(message: 'فشل في تسجيل الدخول');
    }
  }

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      print('=== REGISTRATION REQUEST ===');
      print('Email: ${request.email}');
      print('Username: ${request.username}');
      print('First Name: ${request.firstName}');
      print('Last Name: ${request.lastName}');
      print('Phone: ${request.phone}');
      print('Gender: ${request.gender}');
      print('Role: ${request.role}');
      print('Business Type: ${request.businessType ?? "NOT PROVIDED"}');
      print('Password length: ${request.password.length}');
      print('Confirm Password length: ${request.confirmPassword.length}');
      
      // طباعة البيانات المرسلة للAPI
      final requestData = request.toJson();
      
      print('=== REQUEST JSON ===');
      print('Full JSON: $requestData');
      print('JSON Keys: ${requestData.keys.toList()}');
      print('Business Type in JSON: ${requestData['business_type']}');
      
      final response = await _apiClient.post(
        ApiConstants.registerEndpoint,
        data: requestData,
      );

      print('=== REGISTRATION RESPONSE ===');
      print('Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        try {
          final registerResponse = RegisterResponse.fromJson(response.data);
          print('Registration successful for: ${registerResponse.email}');
          return registerResponse;
        } catch (e) {
          print('JSON parsing error: $e');
          print('Raw response data: ${response.data}');
          throw const NetworkException(message: 'فشل في تحليل استجابة التسجيل');
        }
      } else {
        // Detailed error logging
        print('=== REGISTRATION ERROR ===');
        print('Status Code: ${response.statusCode}');
        print('Response Data: ${response.data}');
        
        final errorMessage = ApiExceptionFactory.parseErrorMessage(response.data);
        print('Parsed Error Message: $errorMessage');
        
        // Try to get detailed validation errors
        if (response.data is Map<String, dynamic>) {
          final data = response.data as Map<String, dynamic>;
          print('Error Data Keys: ${data.keys.toList()}');
          
          // Check for common error fields
          if (data.containsKey('errors')) {
            print('Errors field: ${data['errors']}');
          }
          if (data.containsKey('detail')) {
            print('Detail field: ${data['detail']}');
          }
          if (data.containsKey('message')) {
            print('Message field: ${data['message']}');
          }
          
          // Check for field-specific errors
          final errorFields = <String>[];
          for (final key in data.keys) {
            if (key != 'errors' && key != 'detail' && key != 'message') {
              errorFields.add(key);
            }
          }
          if (errorFields.isNotEmpty) {
            print('Field-specific errors: $errorFields');
          }
        }
        
        throw ApiExceptionFactory.createException(
          statusCode: response.statusCode ?? 0,
          message: errorMessage,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      print('Registration error: $e');
      throw const NetworkException(message: 'فشل في التسجيل');
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      print('=== FETCHING PROFILE ===');
      final response = await _apiClient.get(ApiConstants.profileEndpoint);
      
      print('Profile response status: ${response.statusCode}');
      print('Profile response data: ${response.data}');

      if (response.statusCode == 200) {
        final userModel = UserModel.fromJson(response.data);
        print('Profile parsed - Email: ${userModel.email}, Name: ${userModel.firstName} ${userModel.lastName}');
        return userModel;
      } else {
        throw ApiExceptionFactory.createException(
          statusCode: response.statusCode ?? 0,
          message: ApiExceptionFactory.parseErrorMessage(response.data),
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      print('Error fetching profile: $e');
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