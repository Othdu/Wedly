import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthInitialized extends AuthEvent {
  const AuthInitialized();
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassword;
  final String username;
  final String firstName;
  final String lastName;
  final String phone;
  final String gender;
  final String role;
  final String? businessType;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.gender,
    required this.role,
    this.businessType,
  });

  @override
  List<Object?> get props => [email, password, confirmPassword, username, firstName, lastName, phone, gender, role, businessType];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthPasswordResetRequested extends AuthEvent {
  final String email;

  const AuthPasswordResetRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class AuthProfileUpdateRequested extends AuthEvent {
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? profileImage;
  final String? username;

  const AuthProfileUpdateRequested({
    this.firstName,
    this.lastName,
    this.phone,
    this.profileImage,
    this.username,
  });

  @override
  List<Object?> get props => [firstName, lastName, phone, profileImage, username];
}