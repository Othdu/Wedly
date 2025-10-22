// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      access: json['access'] as String,
      refresh: json['refresh'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'access': instance.access,
      'refresh': instance.refresh,
      'user': instance.user,
    };

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      confirmPassword: json['confirm_password'] as String,
      username: json['username'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      phone: json['phone'] as String,
      gender: json['gender'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'confirm_password': instance.confirmPassword,
      'username': instance.username,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'phone': instance.phone,
      'gender': instance.gender,
      'role': instance.role,
    };

RegisterResponse _$RegisterResponseFromJson(Map<String, dynamic> json) =>
    RegisterResponse(
      username: json['username'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      gender: json['gender'] as String,
      role: json['role'] as String,
      businessType: json['business_type'] as String,
    );

Map<String, dynamic> _$RegisterResponseToJson(RegisterResponse instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'phone': instance.phone,
      'gender': instance.gender,
      'role': instance.role,
      'business_type': instance.businessType,
    };

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      firstName: json['firstName'] as String? ?? json['first_name'] as String? ?? '',
      lastName: json['lastName'] as String? ?? json['last_name'] as String? ?? '',
      phone: json['phone'] as String?,
      profileImage: json['profileImage'] as String? ?? json['profile_image'] as String?,
      isActive: json['isActive'] as bool? ?? json['is_active'] as bool? ?? true,
      isVerified: json['isVerified'] as bool? ?? json['is_verified'] as bool? ?? false,
      dateJoined: json['dateJoined'] == null
          ? null
          : DateTime.parse(json['dateJoined'] as String),
      lastLogin: json['lastLogin'] == null
          ? null
          : DateTime.parse(json['lastLogin'] as String),
      userType: json['userType'] as String? ?? json['user_type'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
      'profileImage': instance.profileImage,
      'isActive': instance.isActive,
      'isVerified': instance.isVerified,
      'dateJoined': instance.dateJoined?.toIso8601String(),
      'lastLogin': instance.lastLogin?.toIso8601String(),
      'userType': instance.userType,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

PasswordResetRequest _$PasswordResetRequestFromJson(Map<String, dynamic> json) =>
    PasswordResetRequest(
      email: json['email'] as String,
    );

Map<String, dynamic> _$PasswordResetRequestToJson(PasswordResetRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
    };

PasswordResetConfirmRequest _$PasswordResetConfirmRequestFromJson(Map<String, dynamic> json) =>
    PasswordResetConfirmRequest(
      token: json['token'] as String,
      newPassword: json['new_password'] as String,
    );

Map<String, dynamic> _$PasswordResetConfirmRequestToJson(PasswordResetConfirmRequest instance) =>
    <String, dynamic>{
      'token': instance.token,
      'new_password': instance.newPassword,
    };

ChangePasswordRequest _$ChangePasswordRequestFromJson(Map<String, dynamic> json) =>
    ChangePasswordRequest(
      currentPassword: json['current_password'] as String,
      newPassword: json['new_password'] as String,
    );

Map<String, dynamic> _$ChangePasswordRequestToJson(ChangePasswordRequest instance) =>
    <String, dynamic>{
      'current_password': instance.currentPassword,
      'new_password': instance.newPassword,
    };

UpdateProfileRequest _$UpdateProfileRequestFromJson(Map<String, dynamic> json) =>
    UpdateProfileRequest(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      phone: json['phone'] as String?,
      profileImage: json['profile_image'] as String?,
    );

Map<String, dynamic> _$UpdateProfileRequestToJson(UpdateProfileRequest instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'phone': instance.phone,
      'profile_image': instance.profileImage,
    };