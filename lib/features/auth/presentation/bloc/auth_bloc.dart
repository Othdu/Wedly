import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exceptions.dart';
import '../../../../core/api/token_manager.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepositoryImpl(
            remoteDataSource: AuthRemoteDataSourceImpl(
              apiClient: apiClient,
            ),
          ),
        super(const AuthInitial()) {
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
      // Check if user is already authenticated
      final isAuthenticated = await _authRepository.isAuthenticated();
      
      if (isAuthenticated) {
        // Try to get current user profile
        try {
          final user = await _authRepository.getCurrentUser();
          emit(AuthAuthenticated(user: user));
        } catch (e) {
          // If profile fetch fails, clear tokens and show unauthenticated
          await TokenManager.clearTokens();
          emit(const AuthUnauthenticated());
        }
      } else {
        emit(const AuthUnauthenticated());
      }
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
      final user = await _authRepository.login(event.email, event.password);
      emit(AuthAuthenticated(user: user));
    } on UnauthorizedException catch (e) {
      emit(AuthError(message: e.message));
    } on ValidationException catch (e) {
      emit(AuthError(message: e.message));
    } on NetworkException catch (e) {
      emit(AuthError(message: e.message));
    } on ServerException catch (e) {
      emit(AuthError(message: e.message));
    } catch (e) {
      emit(AuthError(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.register(
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
        username: event.username,
        firstName: event.firstName,
        lastName: event.lastName,
        phone: event.phone,
        gender: event.gender,
        role: event.role,
      );
      emit(AuthRegistered(user: user));
    } on ValidationException catch (e) {
      emit(AuthError(message: e.message));
    } on NetworkException catch (e) {
      emit(AuthError(message: e.message));
    } on ServerException catch (e) {
      emit(AuthError(message: e.message));
    } catch (e) {
      print('Registration error: $e');
      emit(AuthError(message: 'حدث خطأ غير متوقع: ${e.toString()}'));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _authRepository.logout();
      emit(const AuthUnauthenticated());
    } catch (e) {
      // Even if logout fails, we should show unauthenticated state
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onAuthPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _authRepository.requestPasswordReset(event.email);
      emit(const AuthPasswordResetSent());
    } on ValidationException catch (e) {
      emit(AuthError(message: e.message));
    } on NetworkException catch (e) {
      emit(AuthError(message: e.message));
    } on ServerException catch (e) {
      emit(AuthError(message: e.message));
    } catch (e) {
      emit(AuthError(message: 'حدث خطأ غير متوقع'));
    }
  }
}