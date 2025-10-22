import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../auth/data/datasources/auth_remote_datasource.dart';
import '../../../booking/data/repositories/booking_repository_impl.dart';
import '../../../booking/data/datasources/booking_remote_datasource.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exceptions.dart';
import '../../../auth/data/models/auth_models.dart';

// Events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => [];
}

class ProfileLoadRequested extends ProfileEvent {
  const ProfileLoadRequested();
}

// States
abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final User user;
  final int bookingsCount;

  const ProfileLoaded({
    required this.user,
    required this.bookingsCount,
  });

  @override
  List<Object> get props => [user, bookingsCount];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object> get props => [message];
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository _authRepository;
  final BookingRepository _bookingRepository;

  ProfileBloc({
    AuthRepository? authRepository,
    BookingRepository? bookingRepository,
  }) : _authRepository = authRepository ?? AuthRepositoryImpl(
          remoteDataSource: AuthRemoteDataSourceImpl(apiClient: apiClient),
        ),
        _bookingRepository = bookingRepository ?? BookingRepositoryImpl(
          remoteDataSource: BookingRemoteDataSourceImpl(apiClient: apiClient),
        ),
        super(const ProfileInitial()) {
    on<ProfileLoadRequested>(_onProfileLoadRequested);
  }

  Future<void> _onProfileLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    try {
      // Get current user
      final user = await _authRepository.getCurrentUser();
      
      // Get user's bookings count
      int bookingsCount = 0;
      try {
        final bookings = await _bookingRepository.getMyBookings();
        bookingsCount = bookings.length;
      } catch (e) {
        // If bookings fail, just use 0
        bookingsCount = 0;
      }

      emit(ProfileLoaded(
        user: user,
        bookingsCount: bookingsCount,
      ));
    } on ApiException catch (e) {
      emit(ProfileError(message: e.message));
    } catch (e) {
      emit(ProfileError(message: 'Failed to load profile: $e'));
    }
  }
}
