import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/api/api_exceptions.dart';
import '../models/hall_model.dart';

/// Remote data source for halls and services operations
/// Handles all API calls related to halls, services, and categories
abstract class HomeRemoteDataSource {
  Future<List<HallModel>> getHalls({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? category,
  });
  Future<List<HallModel>> getFeaturedHalls();
  Future<HallModel> getHallDetails(int id);
  
  Future<List<ServiceModel>> getServices({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? category,
  });
  Future<List<ServiceModel>> getFeaturedServices();
  Future<ServiceModel> getServiceDetails(int id);
  
  Future<List<ServiceCategoryModel>> getServiceCategories();
  Future<List<ServiceModel>> getServicesByCategory(String categoryId);
  Future<List<ServiceModel>> searchServices(String query);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient _apiClient;

  HomeRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<HallModel>> getHalls({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? category,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        ApiConstants.pageParam: page,
        ApiConstants.pageSizeParam: pageSize,
      };
      
      if (search != null && search.isNotEmpty) {
        queryParams[ApiConstants.searchParam] = search;
      }
      
      if (category != null && category.isNotEmpty) {
        queryParams[ApiConstants.categoryParam] = category;
      }

      final response = await _apiClient.get(
        ApiConstants.hallsEndpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'] ?? response.data;
        return data.map((json) => HallModel.fromJson(json)).toList();
      } else {
        throw ApiExceptionFactory.createException(
          statusCode: response.statusCode ?? 0,
          message: ApiExceptionFactory.parseErrorMessage(response.data),
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException(message: 'Failed to fetch halls');
    }
  }

  @override
  Future<List<HallModel>> getFeaturedHalls() async {
    try {
      final response = await _apiClient.get(ApiConstants.featuredHallsEndpoint);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'] ?? response.data;
        return data.map((json) => HallModel.fromJson(json)).toList();
      } else {
        throw ApiExceptionFactory.createException(
          statusCode: response.statusCode ?? 0,
          message: ApiExceptionFactory.parseErrorMessage(response.data),
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      // Return fake data as fallback
      return _getFakeFeaturedHalls();
    }
  }

  @override
  Future<HallModel> getHallDetails(int id) async {
    try {
      final response = await _apiClient.get(ApiConstants.hallDetailsEndpoint(id.toString()));

      if (response.statusCode == 200) {
        return HallModel.fromJson(response.data);
      } else {
        throw ApiExceptionFactory.createException(
          statusCode: response.statusCode ?? 0,
          message: ApiExceptionFactory.parseErrorMessage(response.data),
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException(message: 'Failed to fetch hall details');
    }
  }

  @override
  Future<List<ServiceModel>> getServices({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? category,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        ApiConstants.pageParam: page,
        ApiConstants.pageSizeParam: pageSize,
      };
      
      if (search != null && search.isNotEmpty) {
        queryParams[ApiConstants.searchParam] = search;
      }
      
      if (category != null && category.isNotEmpty) {
        queryParams[ApiConstants.categoryParam] = category;
      }

      final response = await _apiClient.get(
        ApiConstants.servicesEndpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'] ?? response.data;
        return data.map((json) => ServiceModel.fromJson(json)).toList();
      } else {
        throw ApiExceptionFactory.createException(
          statusCode: response.statusCode ?? 0,
          message: ApiExceptionFactory.parseErrorMessage(response.data),
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException(message: 'Failed to fetch services');
    }
  }

  @override
  Future<List<ServiceModel>> getFeaturedServices() async {
    try {
      final response = await _apiClient.get(ApiConstants.servicesStorefrontEndpoint);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'] ?? response.data;
        return data.map((json) => ServiceModel.fromJson(json)).toList();
      } else {
        throw ApiExceptionFactory.createException(
          statusCode: response.statusCode ?? 0,
          message: ApiExceptionFactory.parseErrorMessage(response.data),
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException(message: 'Failed to fetch featured services');
    }
  }

  @override
  Future<ServiceModel> getServiceDetails(int id) async {
    try {
      final response = await _apiClient.get(ApiConstants.serviceDetailsEndpoint(id.toString()));

      if (response.statusCode == 200) {
        return ServiceModel.fromJson(response.data);
      } else {
        throw ApiExceptionFactory.createException(
          statusCode: response.statusCode ?? 0,
          message: ApiExceptionFactory.parseErrorMessage(response.data),
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException(message: 'Failed to fetch service details');
    }
  }

  @override
  Future<List<ServiceCategoryModel>> getServiceCategories() async {
    try {
      // Since the backend doesn't have a specific categories endpoint,
      // we'll return mock categories for now
      return _getMockCategories();
    } catch (e) {
      throw const NetworkException(message: 'Failed to fetch service categories');
    }
  }

  @override
  Future<List<ServiceModel>> getServicesByCategory(String categoryId) async {
    try {
      return await getServices(category: categoryId);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException(message: 'Failed to fetch services by category');
    }
  }

  @override
  Future<List<ServiceModel>> searchServices(String query) async {
    try {
      return await getServices(search: query);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException(message: 'Failed to search services');
    }
  }

  /// Get fake featured halls data
  List<HallModel> _getFakeFeaturedHalls() {
    return [
      const HallModel(
        id: 1,
        name: 'قاعة الأفراح الذهبية',
        description: 'قاعة فاخرة للاحتفالات والمناسبات الخاصة',
        location: 'الرياض',
        address: 'شارع الملك فهد، الرياض',
        capacity: 500,
        price: 15000,
        images: ['assets/images/004-wedding-arch.png'],
        rating: 4.8,
        reviewCount: 120,
        features: ['تكييف', 'موقف سيارات', 'ديكور فاخر'],
        isFeatured: true,
      ),
      const HallModel(
        id: 2,
        name: 'قاعة الأحلام',
        description: 'قاعة أنيقة مع إطلالة رائعة',
        location: 'جدة',
        address: 'الكورنيش، جدة',
        capacity: 300,
        price: 12000,
        images: ['assets/images/004-wedding-arch.png'],
        rating: 4.6,
        reviewCount: 85,
        features: ['إطلالة بحرية', 'ديكور حديث', 'خدمة ممتازة'],
        isFeatured: true,
      ),
      const HallModel(
        id: 3,
        name: 'قاعة القصر الملكي',
        description: 'قاعة فاخرة بتصميم كلاسيكي أنيق',
        location: 'الدمام',
        address: 'الواجهة البحرية، الدمام',
        capacity: 400,
        price: 18000,
        images: ['assets/images/004-wedding-arch.png'],
        rating: 4.9,
        reviewCount: 95,
        features: ['تصميم كلاسيكي', 'خدمة VIP', 'موقف واسع'],
        isFeatured: true,
      ),
      const HallModel(
        id: 4,
        name: 'قاعة النجوم',
        description: 'قاعة حديثة بتقنيات متطورة',
        location: 'الرياض',
        address: 'حي النرجس، الرياض',
        capacity: 600,
        price: 20000,
        images: ['assets/images/004-wedding-arch.png'],
        rating: 4.7,
        reviewCount: 150,
        features: ['شاشات LED', 'إضاءة متطورة', 'صوتيات احترافية'],
        isFeatured: true,
      ),
      const HallModel(
        id: 5,
        name: 'قاعة الزهور',
        description: 'قاعة رومانسية بتصميم طبيعي',
        location: 'جدة',
        address: 'حي الروضة، جدة',
        capacity: 250,
        price: 10000,
        images: ['assets/images/004-wedding-arch.png'],
        rating: 4.5,
        reviewCount: 70,
        features: ['حديقة خارجية', 'ديكور طبيعي', 'إطلالة جميلة'],
        isFeatured: true,
      ),
      const HallModel(
        id: 6,
        name: 'قاعة الأماني',
        description: 'قاعة فاخرة بتصميم عصري',
        location: 'الدمام',
        address: 'حي الفيصلية، الدمام',
        capacity: 350,
        price: 14000,
        images: ['assets/images/004-wedding-arch.png'],
        rating: 4.6,
        reviewCount: 90,
        features: ['تصميم عصري', 'خدمة راقية', 'موقف مجاني'],
        isFeatured: true,
      ),
    ];
  }

  /// Get mock service categories (since backend doesn't have categories endpoint)
  List<ServiceCategoryModel> _getMockCategories() {
    return [
      const ServiceCategoryModel(
        id: 1,
        name: 'Wedding Venues',
        nameAr: 'قاعات الأفراح',
        description: 'Beautiful wedding venues',
        image: 'assets/images/004-wedding-arch.png',
        serviceCount: 25,
      ),
      const ServiceCategoryModel(
        id: 2,
        name: 'Wedding Dresses',
        nameAr: 'فساتين الزفاف',
        description: 'Elegant wedding dresses',
        serviceCount: 18,
      ),
      const ServiceCategoryModel(
        id: 3,
        name: 'Photography & Video',
        nameAr: 'التصوير والفيديو',
        description: 'Professional photography services',
        image: 'assets/images/017-photography.png',
        serviceCount: 32,
      ),
      const ServiceCategoryModel(
        id: 4,
        name: 'Catering & Food',
        nameAr: 'الضيافة والطعام',
        description: 'Delicious catering services',
        image: 'assets/images/011-wedding-dinner.png',
        serviceCount: 15,
      ),
      const ServiceCategoryModel(
        id: 5,
        name: 'Decoration & Flowers',
        nameAr: 'الديكور والزينة',
        description: 'Beautiful decorations',
        serviceCount: 22,
      ),
      const ServiceCategoryModel(
        id: 6,
        name: 'Music & Entertainment',
        nameAr: 'الموسيقى والترفيه',
        description: 'Music and entertainment',
        serviceCount: 12,
      ),
      const ServiceCategoryModel(
        id: 7,
        name: 'Transportation',
        nameAr: 'عربيات زفاف',
        description: 'Wedding transportation',
        image: 'assets/images/008-wedding-car.png',
        serviceCount: 12,
      ),
      const ServiceCategoryModel(
        id: 8,
        name: 'Makeup & Beauty',
        nameAr: 'ميكب ارتست',
        description: 'Beauty and makeup services',
        serviceCount: 12,
      ),
    ];
  }
}