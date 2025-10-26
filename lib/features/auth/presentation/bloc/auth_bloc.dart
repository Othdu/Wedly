import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exceptions.dart';
import '../../../../core/api/token_manager.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// AuthBloc - إدارة حالة المصادقة في التطبيق
/// 
/// هذا الكلاس مسؤول عن:
/// - تسجيل الدخول للمستخدمين
/// - تسجيل المستخدمين الجدد
/// - تسجيل الخروج
/// - إعادة تعيين كلمة المرور
/// - التحقق من حالة المصادقة الحالية
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  /// Constructor - إنشاء AuthBloc مع ربط جميع الأحداث
  /// 
  /// [authRepository] - مستودع البيانات للمصادقة (اختياري)
  /// إذا لم يتم توفيره، سيتم إنشاء مثيل افتراضي
  AuthBloc({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepositoryImpl(
            remoteDataSource: AuthRemoteDataSourceImpl(
              apiClient: apiClient,
            ),
          ),
        super(const AuthInitial()) {
    // ربط جميع الأحداث بمعالجاتها المناسبة
    on<AuthInitialized>(_onAuthInitialized);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthPasswordResetRequested>(_onAuthPasswordResetRequested);
    on<AuthProfileUpdateRequested>(_onAuthProfileUpdateRequested);
  }

  /// معالج التهيئة - التحقق من حالة المصادقة الحالية عند بدء التطبيق
  /// 
  /// [event] - حدث التهيئة
  /// [emit] - مرسل الحالة لإرسال التحديثات للواجهة
  Future<void> _onAuthInitialized(
    AuthInitialized event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // التحقق من وجود مصادقة سابقة
      final isAuthenticated = await _authRepository.isAuthenticated();
      
      if (isAuthenticated) {
        // المستخدم مصادق عليه - محاولة جلب بياناته
        try {
          final user = await _authRepository.getCurrentUser();
          emit(AuthAuthenticated(user: user));
        } catch (e) {
          // فشل في جلب بيانات المستخدم - مسح التوكنات وإظهار حالة غير مصادق
          await TokenManager.clearTokens();
          emit(const AuthUnauthenticated());
        }
      } else {
        // المستخدم غير مصادق عليه
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      // خطأ في التهيئة - إرسال رسالة خطأ
      emit(AuthError(message: 'حدث خطأ أثناء التحقق من حالة المصادقة: ${e.toString()}'));
    }
  }

  /// معالج تسجيل الدخول - تسجيل دخول المستخدم إلى التطبيق
  /// 
  /// [event] - حدث تسجيل الدخول يحتوي على البريد الإلكتروني وكلمة المرور
  /// [emit] - مرسل الحالة لإرسال التحديثات للواجهة
  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    // إرسال حالة التحميل للواجهة
    emit(const AuthLoading());
    
    try {
      // محاولة تسجيل الدخول باستخدام المستودع
      final user = await _authRepository.login(event.email, event.password);
      
      // تسجيل الدخول نجح - إرسال حالة المصادقة مع بيانات المستخدم
      emit(AuthAuthenticated(user: user));
      
    } on UnauthorizedException {
      // خطأ في المصادقة - بيانات الدخول غير صحيحة
      emit(const AuthError(message: 'البريد الإلكتروني أو كلمة المرور غير صحيحة، يرجى المحاولة مرة أخرى'));
      
    } on ValidationException {
      // خطأ في التحقق من البيانات المدخلة
      emit(const AuthError(message: 'يرجى التأكد من صحة البيانات المدخلة'));
      
    } on NetworkException {
      // خطأ في الشبكة - مشكلة في الاتصال بالإنترنت
      emit(const AuthError(message: 'تحقق من اتصال الإنترنت وحاول مرة أخرى'));
      
    } on ServerException {
      // خطأ في الخادم - مشكلة في الخادم البعيد
      emit(const AuthError(message: 'خدمة تسجيل الدخول غير متاحة حالياً، يرجى المحاولة لاحقاً'));
      
    } on TimeoutException {
      // انتهت مهلة الطلب - الخادم لم يستجب في الوقت المحدد
      emit(const AuthError(message: 'انتهت مهلة الطلب، يرجى المحاولة مرة أخرى'));
      
    } catch (e, stackTrace) {
      // خطأ غير متوقع - تسجيل الخطأ للمطورين
      print('Login unexpected error: $e');
      print('Error type: ${e.runtimeType}');
      print('Stack trace: $stackTrace');
      
      // Try to extract more information about the error
      if (e.toString().contains('TypeError')) {
        emit(const AuthError(message: 'خطأ في تحويل البيانات، يرجى المحاولة مرة أخرى'));
      } else if (e.toString().contains('FormatException')) {
        emit(const AuthError(message: 'تنسيق البيانات غير صحيح من الخادم'));
      } else {
        emit(AuthError(message: 'حدث خطأ غير متوقع: ${e.toString().split('\n').first}'));
      }
    }
  }

  /// معالج التسجيل - إنشاء حساب جديد للمستخدم
  /// 
  /// [event] - حدث التسجيل يحتوي على جميع بيانات المستخدم المطلوبة
  /// [emit] - مرسل الحالة لإرسال التحديثات للواجهة
  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    // إرسال حالة التحميل للواجهة
    emit(const AuthLoading());
    
    try {
      // محاولة إنشاء حساب جديد باستخدام المستودع
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
        businessType: event.businessType,
      );
      
      // التسجيل نجح - إرسال حالة التسجيل مع بيانات المستخدم
      emit(AuthRegistered(user: user));
      
    } on ValidationException {
      // خطأ في التحقق من البيانات المدخلة
      emit(const AuthError(message: 'يرجى التأكد من صحة جميع البيانات المدخلة وتطابق كلمة المرور'));
      
    } on NetworkException {
      // خطأ في الشبكة - مشكلة في الاتصال بالإنترنت
      emit(const AuthError(message: 'تحقق من اتصال الإنترنت وحاول مرة أخرى'));
      
    } on ServerException {
      // خطأ في الخادم - مشكلة في الخادم البعيد
      emit(const AuthError(message: 'خدمة إنشاء الحساب غير متاحة حالياً، يرجى المحاولة لاحقاً'));
      
    } on TimeoutException {
      // انتهت مهلة الطلب - الخادم لم يستجب في الوقت المحدد
      emit(const AuthError(message: 'انتهت مهلة الطلب، يرجى المحاولة مرة أخرى'));
      
    } on ClientException {
      // خطأ من جانب العميل - البيانات المرسلة غير صحيحة
      emit(const AuthError(message: 'البيانات المرسلة غير صحيحة، يرجى مراجعة المعلومات المدخلة'));
      
    } catch (e) {
      // خطأ غير متوقع - تسجيل الخطأ للمطورين
      print('Registration unexpected error: $e');
      emit(const AuthError(message: 'حدث خطأ غير متوقع أثناء إنشاء الحساب، يرجى المحاولة مرة أخرى أو التواصل مع الدعم الفني'));
    }
  }

  /// معالج تسجيل الخروج - تسجيل خروج المستخدم من التطبيق
  /// 
  /// [event] - حدث تسجيل الخروج
  /// [emit] - مرسل الحالة لإرسال التحديثات للواجهة
  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    // إرسال حالة التحميل للواجهة
    emit(const AuthLoading());
    
    try {
      // محاولة تسجيل الخروج من الخادم
      await _authRepository.logout();
      
      // تسجيل الخروج نجح - إرسال حالة غير مصادق
      emit(const AuthUnauthenticated());
      
    } catch (e) {
      // حتى لو فشل تسجيل الخروج من الخادم، يجب إظهار حالة غير مصادق محلياً
      print('Logout error: $e');
      emit(const AuthUnauthenticated());
    }
  }

  /// معالج إعادة تعيين كلمة المرور - إرسال رابط إعادة تعيين كلمة المرور
  /// 
  /// [event] - حدث إعادة تعيين كلمة المرور يحتوي على البريد الإلكتروني
  /// [emit] - مرسل الحالة لإرسال التحديثات للواجهة
  Future<void> _onAuthPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    // إرسال حالة التحميل للواجهة
    emit(const AuthLoading());
    
    try {
      // محاولة إرسال رابط إعادة تعيين كلمة المرور
      await _authRepository.requestPasswordReset(event.email);
      
      // إرسال الرابط نجح - إرسال حالة نجح الإرسال
      emit(const AuthPasswordResetSent());
      
    } on ValidationException {
      // خطأ في التحقق من البريد الإلكتروني
      emit(const AuthError(message: 'يرجى إدخال بريد إلكتروني صحيح'));
      
    } on NetworkException {
      // خطأ في الشبكة - مشكلة في الاتصال بالإنترنت
      emit(const AuthError(message: 'تحقق من اتصال الإنترنت وحاول مرة أخرى'));
      
    } on ServerException {
      // خطأ في الخادم - مشكلة في الخادم البعيد
      emit(const AuthError(message: 'خدمة إعادة تعيين كلمة المرور غير متاحة حالياً، يرجى المحاولة لاحقاً'));
      
    } on TimeoutException {
      // انتهت مهلة الطلب - الخادم لم يستجب في الوقت المحدد
      emit(const AuthError(message: 'انتهت مهلة الطلب، يرجى المحاولة مرة أخرى'));
      
    } catch (e) {
      // خطأ غير متوقع - تسجيل الخطأ للمطورين
      print('Password reset unexpected error: $e');
      emit(const AuthError(message: 'حدث خطأ غير متوقع أثناء إرسال رابط إعادة تعيين كلمة المرور، يرجى المحاولة مرة أخرى أو التواصل مع الدعم الفني'));
    }
  }

  /// معالج تحديث الملف الشخصي - تحديث معلومات المستخدم
  /// 
  /// [event] - حدث تحديث الملف الشخصي يحتوي على المعلومات المحدثة
  /// [emit] - مرسل الحالة لإرسال التحديثات للواجهة
  Future<void> _onAuthProfileUpdateRequested(
    AuthProfileUpdateRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Get current state before attempting update
    final currentState = state;
    
    if (!(currentState is AuthAuthenticated || currentState is AuthRegistered)) {
      // User is not authenticated, don't proceed
      return;
    }
    
    // إرسال حالة التحميل للواجهة
    emit(const AuthLoading());
    
    try {
      // محاولة تحديث الملف الشخصي
      final updatedUser = await _authRepository.updateProfile(
        firstName: event.firstName,
        lastName: event.lastName,
        phone: event.phone,
        profileImage: event.profileImage,
        username: event.username,
      );
      
      // Update successful - emit new state with updated user
      if (currentState is AuthAuthenticated) {
        emit(AuthAuthenticated(user: updatedUser));
      } else if (currentState is AuthRegistered) {
        emit(AuthRegistered(user: updatedUser));
      }
      
    } on NetworkException {
      // Network error - restore previous state
      emit(currentState);
      emit(AuthError(message: 'تحقق من اتصال الإنترنت وحاول مرة أخرى'));
    } on ValidationException catch (e) {
      // Validation error - restore previous state and show specific error
      emit(currentState); // Restore first
      
      final errorMessage = e.message.toLowerCase();
      if (errorMessage.contains('username') && 
          (errorMessage.contains('taken') || 
           errorMessage.contains('exists') || 
           errorMessage.contains('already'))) {
        emit(AuthError(message: 'اسم المستخدم مستخدم بالفعل، يرجى اختيار اسم آخر'));
      } else {
        emit(AuthError(message: 'يرجى التأكد من صحة البيانات المدخلة'));
      }
    } on ClientException catch (e) {
      // Client error (400) - restore previous state and show error
      emit(currentState); // Restore first
      
      final errorMessage = e.message.toLowerCase();
      if (errorMessage.contains('username') && 
          (errorMessage.contains('taken') || 
           errorMessage.contains('exists') || 
           errorMessage.contains('already'))) {
        emit(AuthError(message: 'اسم المستخدم مستخدم بالفعل، يرجى اختيار اسم آخر'));
      } else {
        emit(AuthError(message: e.message));
      }
    } catch (e) {
      print('Profile update error: $e');
      
      // Restore previous state first
      emit(currentState);
      
      // Check if error message indicates username conflict
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('username') && 
          (errorString.contains('taken') || 
           errorString.contains('exists') || 
           errorString.contains('already') ||
           errorString.contains('unique'))) {
        emit(AuthError(message: 'اسم المستخدم مستخدم بالفعل، يرجى اختيار اسم آخر'));
      } else {
        emit(AuthError(message: 'حدث خطأ أثناء تحديث الملف الشخصي'));
      }
    }
  }
}