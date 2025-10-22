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
      return response.user.toDomain();
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
      );
      final response = await _remoteDataSource.register(request);
      // Create a User object from the registration response
      return User(
        id: '0', // Temporary ID as string
        email: response.email,
        firstName: response.username, // Using username as firstName
        lastName: '', // Not provided in response
        phone: response.phone,
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
  }) async {
    try {
      final request = UpdateProfileRequest(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        profileImage: profileImage,
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
