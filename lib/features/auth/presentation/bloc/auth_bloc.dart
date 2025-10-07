import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthInitial()) {
    on<AuthInitialized>(_onAuthInitialized);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthPasswordResetRequested>(_onAuthPasswordResetRequested);
  }

  Future<void> _onAuthInitialized(
    AuthInitialized event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // Check if user is already logged in (mock implementation)
      // In a real app, you would check SharedPreferences or secure storage
      await Future.delayed(const Duration(milliseconds: 500));
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock authentication logic
      if (event.email.isNotEmpty && event.password.isNotEmpty) {
        final user = User(
          id: '1',
          email: event.email,
          fullName: 'Test User',
          phone: '+1234567890',
          createdAt: DateTime.now(),
        );
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthError(message: 'Invalid email or password'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock registration logic
      if (event.email.isNotEmpty && event.password.isNotEmpty) {
        final user = User(
          id: '1',
          email: event.email,
          fullName: event.fullName,
          phone: event.phone,
          createdAt: DateTime.now(),
        );
        emit(AuthRegistered(user: user));
      } else {
        emit(const AuthError(message: 'Registration failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      // Simulate logout delay
      await Future.delayed(const Duration(milliseconds: 500));
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      // Simulate password reset delay
      await Future.delayed(const Duration(seconds: 1));
      emit(const AuthPasswordResetSent());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}