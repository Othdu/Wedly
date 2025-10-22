import 'package:json_annotation/json_annotation.dart';

part 'auth_models.g.dart';

/// Login request model
@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

/// Login response model
@JsonSerializable()
class LoginResponse {
  final String access;
  final String refresh;
  final UserModel user;

  const LoginResponse({
    required this.access,
    required this.refresh,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

/// Register request model
@JsonSerializable()
class RegisterRequest {
  final String email;
  final String password;
  @JsonKey(name: 'confirm_password')
  final String confirmPassword;
  final String username;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String phone;
  final String gender;
  final String role;

  const RegisterRequest({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.gender,
    required this.role,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

/// Register response model
@JsonSerializable()
class RegisterResponse {
  final String username;
  final String email;
  final String phone;
  final String gender;
  final String role;
  @JsonKey(name: 'business_type')
  final String businessType;

  const RegisterResponse({
    required this.username,
    required this.email,
    required this.phone,
    required this.gender,
    required this.role,
    required this.businessType,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}

/// User model from backend
@JsonSerializable()
class UserModel {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? profileImage;
  final bool isActive;
  final bool isVerified;
  final DateTime? dateJoined;
  final DateTime? lastLogin;
  final String? userType; // user, vendor, admin, etc.

  const UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.profileImage,
    this.isActive = true,
    this.isVerified = false,
    this.dateJoined,
    this.lastLogin,
    this.userType,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle both camelCase and snake_case field names
    return UserModel(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      firstName: json['firstName'] as String? ?? json['first_name'] as String? ?? '',
      lastName: json['lastName'] as String? ?? json['last_name'] as String? ?? '',
      phone: json['phone'] as String?,
      profileImage: json['profileImage'] as String? ?? json['profile_image'] as String?,
      isActive: json['isActive'] as bool? ?? json['is_active'] as bool? ?? true,
      isVerified: json['isVerified'] as bool? ?? json['is_verified'] as bool? ?? false,
      dateJoined: json['dateJoined'] != null
          ? DateTime.parse(json['dateJoined'] as String)
          : json['date_joined'] != null
              ? DateTime.parse(json['date_joined'] as String)
              : null,
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'] as String)
          : json['last_login'] != null
              ? DateTime.parse(json['last_login'] as String)
              : null,
      userType: json['userType'] as String? ?? json['user_type'] as String?,
    );
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Get full name
  String get fullName => '$firstName $lastName';

  /// Check if user is verified
  bool get isUserVerified => isVerified;

  /// Check if user is active
  bool get isUserActive => isActive;

  /// Convert to domain User entity
  User toDomain() {
    return User(
      id: id.toString(),
      email: email,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      createdAt: dateJoined,
    );
  }
}

/// Domain User entity (matches existing auth state)
class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.createdAt,
  });

  /// Get full name by combining first and last name
  String get fullName => '$firstName $lastName'.trim();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      email: json['email'] as String,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      phone: json['phone'] as String?,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone': phone,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Password reset request model
@JsonSerializable()
class PasswordResetRequest {
  final String email;

  const PasswordResetRequest({
    required this.email,
  });

  factory PasswordResetRequest.fromJson(Map<String, dynamic> json) =>
      _$PasswordResetRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PasswordResetRequestToJson(this);
}

/// Password reset confirm model
@JsonSerializable()
class PasswordResetConfirmRequest {
  final String token;
  final String newPassword;

  const PasswordResetConfirmRequest({
    required this.token,
    required this.newPassword,
  });

  factory PasswordResetConfirmRequest.fromJson(Map<String, dynamic> json) =>
      _$PasswordResetConfirmRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PasswordResetConfirmRequestToJson(this);
}

/// Change password request model
@JsonSerializable()
class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
  });

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordRequestToJson(this);
}

/// Update profile request model
@JsonSerializable()
class UpdateProfileRequest {
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? profileImage;

  const UpdateProfileRequest({
    this.firstName,
    this.lastName,
    this.phone,
    this.profileImage,
  });

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileRequestToJson(this);
}
