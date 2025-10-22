import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/api/api_exceptions.dart';
import '../models/reviews_model.dart';

abstract class ReviewsRemoteDataSource {
  Future<List<ReviewModel>> getReviews({int? page, int? pageSize});
  Future<List<ReviewModel>> getReviewsByRating(int rating, {int? page, int? pageSize});
  Future<List<ReviewModel>> getReviewsForService(int? hallId, int? serviceId, {int? page, int? pageSize});
  Future<ReviewModel> createReview(ReviewRequest request);
  Future<ReviewModel> updateReview(int id, ReviewRequest request);
  Future<void> deleteReview(int id);
}

class ReviewsRemoteDataSourceImpl implements ReviewsRemoteDataSource {
  final ApiClient apiClient;

  ReviewsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ReviewModel>> getReviews({int? page, int? pageSize}) async {
    try {
      final response = await apiClient.get(ApiConstants.reviewsEndpoint, queryParameters: {
        if (page != null) 'page': page,
        if (pageSize != null) 'page_size': pageSize,
      });
      return (response.data as List)
          .map((e) => ReviewModel.fromJson(e))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to fetch reviews: $e');
    }
  }

  @override
  Future<List<ReviewModel>> getReviewsByRating(int rating, {int? page, int? pageSize}) async {
    try {
      final response = await apiClient.get(ApiConstants.reviewsEndpoint, queryParameters: {
        'rating': rating,
        if (page != null) 'page': page,
        if (pageSize != null) 'page_size': pageSize,
      });
      return (response.data as List)
          .map((e) => ReviewModel.fromJson(e))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to fetch reviews by rating: $e');
    }
  }

  @override
  Future<List<ReviewModel>> getReviewsForService(int? hallId, int? serviceId, {int? page, int? pageSize}) async {
    try {
      final response = await apiClient.get(ApiConstants.reviewsEndpoint, queryParameters: {
        if (hallId != null) 'hall_id': hallId,
        if (serviceId != null) 'service_id': serviceId,
        if (page != null) 'page': page,
        if (pageSize != null) 'page_size': pageSize,
      });
      return (response.data as List)
          .map((e) => ReviewModel.fromJson(e))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to fetch service reviews: $e');
    }
  }

  @override
  Future<ReviewModel> createReview(ReviewRequest request) async {
    try {
      final response = await apiClient.post(ApiConstants.reviewsEndpoint, data: request.toJson());
      return ReviewModel.fromJson(response.data);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to create review: $e');
    }
  }

  @override
  Future<ReviewModel> updateReview(int id, ReviewRequest request) async {
    try {
      final response = await apiClient.put(ApiConstants.reviewDetailsEndpoint(id.toString()), data: request.toJson());
      return ReviewModel.fromJson(response.data);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to update review: $e');
    }
  }

  @override
  Future<void> deleteReview(int id) async {
    try {
      await apiClient.delete(ApiConstants.reviewDetailsEndpoint(id.toString()));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to delete review: $e');
    }
  }
}
