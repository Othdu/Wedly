import '../../../../core/api/api_exceptions.dart';
import '../../../../core/api/token_manager.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_models.dart';

/// Repository interface for authentication operations
abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String username,
    required String firstName,
    required String lastName,
    required String phone,
    required String gender,
    required String role,
    String? businessType,
  });
  Future<User> getCurrentUser();
  Future<void> logout();
  Future<void> requestPasswordReset(String email);
  Future<void> confirmPasswordReset(String token, String newPassword);
  Future<void> changePassword(String currentPassword, String newPassword);
  Future<User> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? profileImage,
    String? username,
  });
  Future<bool> isAuthenticated();
}

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<User> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _remoteDataSource.login(request);
      
      // Always try to fetch complete user profile data
      print('Fetching user profile after login...');
      try {
        final profile = await _remoteDataSource.getProfile();
        print('Profile fetched successfully: ${profile.firstName} ${profile.lastName}');
        return profile.toDomain();
      } catch (e) {
        print('Failed to fetch profile: $e');
        print('Using login response user data: ${response.user.email}');
        // If profile fetch fails, use response data as fallback
        return response.user.toDomain();
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException();
    }
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String username,
    required String firstName,
    required String lastName,
    required String phone,
    required String gender,
    required String role,
    String? businessType,
  }) async {
    try {
      final request = RegisterRequest(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        username: username,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        gender: gender,
        role: role,
        businessType: businessType,
      );
      final response = await _remoteDataSource.register(request);
      // Create a User object from the registration response
      return User(
        id: response.id?.toString() ?? '0'.toString(),
        email: response.email,
        firstName: response.firstName ?? firstName, // Use firstName from response or fallback to the one we sent
        lastName: response.lastName ?? lastName, // Use lastName from response or fallback to the one we sent
        phone: response.phone,
        username: response.username, // Include username from response
        createdAt: DateTime.now(),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException();
    }
  }

  @override
  Future<User> getCurrentUser() async {
    try {
      final userModel = await _remoteDataSource.getProfile();
      return userModel.toDomain();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException();
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _remoteDataSource.logout();
    } on ApiException {
      // Even if logout fails, we should clear local tokens
      await TokenManager.clearTokens();
      rethrow;
    } catch (e) {
      // Clear tokens even if there's an error
      await TokenManager.clearTokens();
      throw const NetworkException();
    }
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    try {
      final request = PasswordResetRequest(email: email);
      await _remoteDataSource.requestPasswordReset(request);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException();
    }
  }

  @override
  Future<void> confirmPasswordReset(String token, String newPassword) async {
    try {
      final request = PasswordResetConfirmRequest(
        token: token,
        newPassword: newPassword,
      );
      await _remoteDataSource.confirmPasswordReset(request);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException();
    }
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      final request = ChangePasswordRequest(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      await _remoteDataSource.changePassword(request);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException();
    }
  }

  @override
  Future<User> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? profileImage,
    String? username,
  }) async {
    try {
      final request = UpdateProfileRequest(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        profileImage: profileImage,
        username: username,
      );
      final userModel = await _remoteDataSource.updateProfile(request);
      return userModel.toDomain();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException();
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return await TokenManager.isAuthenticated();
  }
}
