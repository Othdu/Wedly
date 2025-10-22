import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/reviews_repository_impl.dart';
import '../../data/datasources/reviews_remote_datasource.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exceptions.dart';
import '../../data/models/reviews_model.dart';

// Events
abstract class ReviewsEvent extends Equatable {
  const ReviewsEvent();
  @override
  List<Object?> get props => [];
}

class ReviewsLoadRequested extends ReviewsEvent {
  final int? rating;
  final int? hallId;
  final int? serviceId;

  const ReviewsLoadRequested({
    this.rating,
    this.hallId,
    this.serviceId,
  });

  @override
  List<Object?> get props => [rating, hallId, serviceId];
}

class ReviewCreateRequested extends ReviewsEvent {
  final int? hallId;
  final int? serviceId;
  final int rating;
  final String? comment;

  const ReviewCreateRequested({
    this.hallId,
    this.serviceId,
    required this.rating,
    this.comment,
  });

  @override
  List<Object?> get props => [hallId, serviceId, rating, comment];
}

class ReviewUpdateRequested extends ReviewsEvent {
  final int id;
  final int? hallId;
  final int? serviceId;
  final int rating;
  final String? comment;

  const ReviewUpdateRequested({
    required this.id,
    this.hallId,
    this.serviceId,
    required this.rating,
    this.comment,
  });

  @override
  List<Object?> get props => [id, hallId, serviceId, rating, comment];
}

class ReviewDeleteRequested extends ReviewsEvent {
  final int id;

  const ReviewDeleteRequested({required this.id});

  @override
  List<Object> get props => [id];
}

// States
abstract class ReviewsState extends Equatable {
  const ReviewsState();
  @override
  List<Object?> get props => [];
}

class ReviewsInitial extends ReviewsState {
  const ReviewsInitial();
}

class ReviewsLoading extends ReviewsState {
  const ReviewsLoading();
}

class ReviewsLoaded extends ReviewsState {
  final List<Review> reviews;
  final double averageRating;
  final Map<int, int> ratingCounts;

  const ReviewsLoaded({
    required this.reviews,
    required this.averageRating,
    required this.ratingCounts,
  });

  @override
  List<Object> get props => [reviews, averageRating, ratingCounts];
}

class ReviewCreated extends ReviewsState {
  final Review review;

  const ReviewCreated({required this.review});

  @override
  List<Object> get props => [review];
}

class ReviewUpdated extends ReviewsState {
  final Review review;

  const ReviewUpdated({required this.review});

  @override
  List<Object> get props => [review];
}

class ReviewDeleted extends ReviewsState {
  final int reviewId;

  const ReviewDeleted({required this.reviewId});

  @override
  List<Object> get props => [reviewId];
}

class ReviewsError extends ReviewsState {
  final String message;

  const ReviewsError({required this.message});

  @override
  List<Object> get props => [message];
}

class ReviewsBloc extends Bloc<ReviewsEvent, ReviewsState> {
  final ReviewsRepository _reviewsRepository;

  ReviewsBloc({ReviewsRepository? reviewsRepository})
      : _reviewsRepository = reviewsRepository ??
            ReviewsRepositoryImpl(
              remoteDataSource: ReviewsRemoteDataSourceImpl(
                apiClient: apiClient,
              ),
            ),
        super(const ReviewsInitial()) {
    on<ReviewsLoadRequested>(_onReviewsLoadRequested);
    on<ReviewCreateRequested>(_onReviewCreateRequested);
    on<ReviewUpdateRequested>(_onReviewUpdateRequested);
    on<ReviewDeleteRequested>(_onReviewDeleteRequested);
  }

  Future<void> _onReviewsLoadRequested(
    ReviewsLoadRequested event,
    Emitter<ReviewsState> emit,
  ) async {
    emit(const ReviewsLoading());
    try {
      List<Review> reviews;
      
      if (event.rating != null) {
        reviews = await _reviewsRepository.getReviewsByRating(event.rating!);
      } else if (event.hallId != null || event.serviceId != null) {
        reviews = await _reviewsRepository.getReviewsForService(event.hallId, event.serviceId);
      } else {
        reviews = await _reviewsRepository.getReviews();
      }

      // Calculate average rating and rating counts
      final averageRating = reviews.isEmpty 
          ? 0.0 
          : reviews.fold<double>(0, (sum, review) => sum + review.rating) / reviews.length;
      
      final Map<int, int> ratingCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
      for (final review in reviews) {
        ratingCounts[review.rating] = (ratingCounts[review.rating] ?? 0) + 1;
      }

      emit(ReviewsLoaded(
        reviews: reviews,
        averageRating: averageRating,
        ratingCounts: ratingCounts,
      ));
    } on ApiException catch (e) {
      emit(ReviewsError(message: e.message));
    } catch (e) {
      emit(ReviewsError(message: 'Failed to load reviews: $e'));
    }
  }

  Future<void> _onReviewCreateRequested(
    ReviewCreateRequested event,
    Emitter<ReviewsState> emit,
  ) async {
    try {
      final review = await _reviewsRepository.createReview(
        hallId: event.hallId,
        serviceId: event.serviceId,
        rating: event.rating,
        comment: event.comment,
      );
      emit(ReviewCreated(review: review));
    } on ApiException catch (e) {
      emit(ReviewsError(message: e.message));
    } catch (e) {
      emit(ReviewsError(message: 'Failed to create review: $e'));
    }
  }

  Future<void> _onReviewUpdateRequested(
    ReviewUpdateRequested event,
    Emitter<ReviewsState> emit,
  ) async {
    try {
      final review = await _reviewsRepository.updateReview(
        event.id,
        hallId: event.hallId,
        serviceId: event.serviceId,
        rating: event.rating,
        comment: event.comment,
      );
      emit(ReviewUpdated(review: review));
    } on ApiException catch (e) {
      emit(ReviewsError(message: e.message));
    } catch (e) {
      emit(ReviewsError(message: 'Failed to update review: $e'));
    }
  }

  Future<void> _onReviewDeleteRequested(
    ReviewDeleteRequested event,
    Emitter<ReviewsState> emit,
  ) async {
    try {
      await _reviewsRepository.deleteReview(event.id);
      emit(ReviewDeleted(reviewId: event.id));
    } on ApiException catch (e) {
      emit(ReviewsError(message: e.message));
    } catch (e) {
      emit(ReviewsError(message: 'Failed to delete review: $e'));
    }
  }
}
