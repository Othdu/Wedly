import '../../../../core/api/api_exceptions.dart';
import '../datasources/reviews_remote_datasource.dart';
import '../models/reviews_model.dart';

abstract class ReviewsRepository {
  Future<List<Review>> getReviews({int? page, int? pageSize});
  Future<List<Review>> getReviewsByRating(int rating, {int? page, int? pageSize});
  Future<List<Review>> getReviewsForService(int? hallId, int? serviceId, {int? page, int? pageSize});
  Future<Review> createReview({
    int? hallId,
    int? serviceId,
    required int rating,
    String? comment,
  });
  Future<Review> updateReview(int id, {
    int? hallId,
    int? serviceId,
    required int rating,
    String? comment,
  });
  Future<void> deleteReview(int id);
}

class ReviewsRepositoryImpl implements ReviewsRepository {
  final ReviewsRemoteDataSource remoteDataSource;

  ReviewsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Review>> getReviews({int? page, int? pageSize}) async {
    try {
      final reviews = await remoteDataSource.getReviews(page: page, pageSize: pageSize);
      return reviews.map((review) => review.toReview()).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to fetch reviews: $e');
    }
  }

  @override
  Future<List<Review>> getReviewsByRating(int rating, {int? page, int? pageSize}) async {
    try {
      final reviews = await remoteDataSource.getReviewsByRating(rating, page: page, pageSize: pageSize);
      return reviews.map((review) => review.toReview()).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to fetch reviews by rating: $e');
    }
  }

  @override
  Future<List<Review>> getReviewsForService(int? hallId, int? serviceId, {int? page, int? pageSize}) async {
    try {
      final reviews = await remoteDataSource.getReviewsForService(hallId, serviceId, page: page, pageSize: pageSize);
      return reviews.map((review) => review.toReview()).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to fetch service reviews: $e');
    }
  }

  @override
  Future<Review> createReview({
    int? hallId,
    int? serviceId,
    required int rating,
    String? comment,
  }) async {
    try {
      final request = ReviewRequest(
        hallId: hallId,
        serviceId: serviceId,
        rating: rating,
        comment: comment,
      );
      final review = await remoteDataSource.createReview(request);
      return review.toReview();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to create review: $e');
    }
  }

  @override
  Future<Review> updateReview(int id, {
    int? hallId,
    int? serviceId,
    required int rating,
    String? comment,
  }) async {
    try {
      final request = ReviewRequest(
        hallId: hallId,
        serviceId: serviceId,
        rating: rating,
        comment: comment,
      );
      final review = await remoteDataSource.updateReview(id, request);
      return review.toReview();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to update review: $e');
    }
  }

  @override
  Future<void> deleteReview(int id) async {
    try {
      await remoteDataSource.deleteReview(id);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to delete review: $e');
    }
  }
}
