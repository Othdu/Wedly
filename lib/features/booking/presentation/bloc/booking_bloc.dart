import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../data/datasources/booking_remote_datasource.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exceptions.dart';
import '../../data/models/booking_model.dart';

// Events
abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class BookingInitialized extends BookingEvent {
  const BookingInitialized();
}

class BookingListRequested extends BookingEvent {
  final int page;
  final int pageSize;
  final String? status;

  const BookingListRequested({
    this.page = 1,
    this.pageSize = 20,
    this.status,
  });

  @override
  List<Object?> get props => [page, pageSize, status];
}

class MyBookingsRequested extends BookingEvent {
  const MyBookingsRequested();
}

class BookingDetailsRequested extends BookingEvent {
  final int bookingId;

  const BookingDetailsRequested({required this.bookingId});

  @override
  List<Object> get props => [bookingId];
}

class BookingCreateRequested extends BookingEvent {
  final int? hallId;
  final int? serviceId;
  final DateTime eventDate;
  final DateTime startTime;
  final DateTime endTime;
  final int guestCount;
  final String? specialRequests;
  final String? notes;
  final Map<String, dynamic>? eventDetails;

  const BookingCreateRequested({
    this.hallId,
    this.serviceId,
    required this.eventDate,
    required this.startTime,
    required this.endTime,
    required this.guestCount,
    this.specialRequests,
    this.notes,
    this.eventDetails,
  });

  @override
  List<Object?> get props => [
        hallId,
        serviceId,
        eventDate,
        startTime,
        endTime,
        guestCount,
        specialRequests,
        notes,
        eventDetails,
      ];
}

class BookingUpdateRequested extends BookingEvent {
  final int bookingId;
  final DateTime? eventDate;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? guestCount;
  final String? specialRequests;
  final String? notes;
  final Map<String, dynamic>? eventDetails;

  const BookingUpdateRequested({
    required this.bookingId,
    this.eventDate,
    this.startTime,
    this.endTime,
    this.guestCount,
    this.specialRequests,
    this.notes,
    this.eventDetails,
  });

  @override
  List<Object?> get props => [
        bookingId,
        eventDate,
        startTime,
        endTime,
        guestCount,
        specialRequests,
        notes,
        eventDetails,
      ];
}

class BookingCancelRequested extends BookingEvent {
  final int bookingId;

  const BookingCancelRequested({required this.bookingId});

  @override
  List<Object> get props => [bookingId];
}

class BookingDeleteRequested extends BookingEvent {
  final int bookingId;

  const BookingDeleteRequested({required this.bookingId});

  @override
  List<Object> get props => [bookingId];
}

// States
abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {
  const BookingInitial();
}

class BookingLoading extends BookingState {
  const BookingLoading();
}

class BookingListLoaded extends BookingState {
  final List<Booking> bookings;
  final bool hasMore;
  final int currentPage;

  const BookingListLoaded({
    required this.bookings,
    this.hasMore = false,
    this.currentPage = 1,
  });

  BookingListLoaded copyWith({
    List<Booking>? bookings,
    bool? hasMore,
    int? currentPage,
  }) {
    return BookingListLoaded(
      bookings: bookings ?? this.bookings,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object> get props => [bookings, hasMore, currentPage];
}

class BookingDetailsLoaded extends BookingState {
  final Booking booking;

  const BookingDetailsLoaded({required this.booking});

  @override
  List<Object> get props => [booking];
}

class BookingCreated extends BookingState {
  final Booking booking;

  const BookingCreated({required this.booking});

  @override
  List<Object> get props => [booking];
}

class BookingUpdated extends BookingState {
  final Booking booking;

  const BookingUpdated({required this.booking});

  @override
  List<Object> get props => [booking];
}

class BookingCancelled extends BookingState {
  final int bookingId;

  const BookingCancelled({required this.bookingId});

  @override
  List<Object> get props => [bookingId];
}

class BookingDeleted extends BookingState {
  final int bookingId;

  const BookingDeleted({required this.bookingId});

  @override
  List<Object> get props => [bookingId];
}

class BookingError extends BookingState {
  final String message;

  const BookingError({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC
class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository _bookingRepository;

  BookingBloc({BookingRepository? bookingRepository})
      : _bookingRepository = bookingRepository ?? BookingRepositoryImpl(
            remoteDataSource: BookingRemoteDataSourceImpl(
              apiClient: apiClient,
            ),
          ),
        super(const BookingInitial()) {
    on<BookingInitialized>(_onBookingInitialized);
    on<BookingListRequested>(_onBookingListRequested);
    on<MyBookingsRequested>(_onMyBookingsRequested);
    on<BookingDetailsRequested>(_onBookingDetailsRequested);
    on<BookingCreateRequested>(_onBookingCreateRequested);
    on<BookingUpdateRequested>(_onBookingUpdateRequested);
    on<BookingCancelRequested>(_onBookingCancelRequested);
    on<BookingDeleteRequested>(_onBookingDeleteRequested);
  }

  Future<void> _onBookingInitialized(
    BookingInitialized event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());
    try {
      final bookings = await _bookingRepository.getMyBookings();
      emit(BookingListLoaded(bookings: bookings));
    } on NetworkException catch (e) {
      emit(BookingError(message: e.message));
    } on ServerException catch (e) {
      emit(BookingError(message: e.message));
    } catch (e) {
      emit(const BookingError(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<void> _onBookingListRequested(
    BookingListRequested event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());
    try {
      final bookings = await _bookingRepository.getBookings(
        page: event.page,
        pageSize: event.pageSize,
        status: event.status,
      );
      emit(BookingListLoaded(
        bookings: bookings,
        currentPage: event.page,
        hasMore: bookings.length == event.pageSize,
      ));
    } on NetworkException catch (e) {
      emit(BookingError(message: e.message));
    } on ServerException catch (e) {
      emit(BookingError(message: e.message));
    } catch (e) {
      emit(const BookingError(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<void> _onMyBookingsRequested(
    MyBookingsRequested event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());
    try {
      final bookings = await _bookingRepository.getMyBookings();
      emit(BookingListLoaded(bookings: bookings));
    } on NetworkException catch (e) {
      emit(BookingError(message: e.message));
    } on ServerException catch (e) {
      emit(BookingError(message: e.message));
    } catch (e) {
      emit(const BookingError(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<void> _onBookingDetailsRequested(
    BookingDetailsRequested event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());
    try {
      final booking = await _bookingRepository.getBookingDetails(event.bookingId);
      emit(BookingDetailsLoaded(booking: booking));
    } on NetworkException catch (e) {
      emit(BookingError(message: e.message));
    } on ServerException catch (e) {
      emit(BookingError(message: e.message));
    } catch (e) {
      emit(const BookingError(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<void> _onBookingCreateRequested(
    BookingCreateRequested event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());
    try {
      final booking = await _bookingRepository.createBooking(
        hallId: event.hallId,
        serviceId: event.serviceId,
        eventDate: event.eventDate,
        startTime: event.startTime,
        endTime: event.endTime,
        guestCount: event.guestCount,
        specialRequests: event.specialRequests,
        notes: event.notes,
        eventDetails: event.eventDetails,
      );
      emit(BookingCreated(booking: booking));
    } on ValidationException catch (e) {
      emit(BookingError(message: e.message));
    } on NetworkException catch (e) {
      emit(BookingError(message: e.message));
    } on ServerException catch (e) {
      emit(BookingError(message: e.message));
    } catch (e) {
      emit(const BookingError(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<void> _onBookingUpdateRequested(
    BookingUpdateRequested event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());
    try {
      final booking = await _bookingRepository.updateBooking(
        id: event.bookingId,
        eventDate: event.eventDate,
        startTime: event.startTime,
        endTime: event.endTime,
        guestCount: event.guestCount,
        specialRequests: event.specialRequests,
        notes: event.notes,
        eventDetails: event.eventDetails,
      );
      emit(BookingUpdated(booking: booking));
    } on ValidationException catch (e) {
      emit(BookingError(message: e.message));
    } on NetworkException catch (e) {
      emit(BookingError(message: e.message));
    } on ServerException catch (e) {
      emit(BookingError(message: e.message));
    } catch (e) {
      emit(const BookingError(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<void> _onBookingCancelRequested(
    BookingCancelRequested event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());
    try {
      await _bookingRepository.cancelBooking(event.bookingId);
      emit(BookingCancelled(bookingId: event.bookingId));
    } on NetworkException catch (e) {
      emit(BookingError(message: e.message));
    } on ServerException catch (e) {
      emit(BookingError(message: e.message));
    } catch (e) {
      emit(const BookingError(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<void> _onBookingDeleteRequested(
    BookingDeleteRequested event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());
    try {
      await _bookingRepository.deleteBooking(event.bookingId);
      emit(BookingDeleted(bookingId: event.bookingId));
    } on NetworkException catch (e) {
      emit(BookingError(message: e.message));
    } on ServerException catch (e) {
      emit(BookingError(message: e.message));
    } catch (e) {
      emit(const BookingError(message: 'حدث خطأ غير متوقع'));
    }
  }
}
