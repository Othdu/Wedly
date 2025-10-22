import '../../../../core/api/api_exceptions.dart';
import '../datasources/home_remote_datasource.dart';
import '../models/hall_model.dart';

/// Repository interface for home operations
abstract class HomeRepository {
  Future<List<FeaturedService>> getFeaturedServices();
  Future<List<ServiceCategory>> getServiceCategories();
  Future<List<FeaturedService>> getAllServices();
  Future<List<HallModel>> getFeaturedHalls();
  Future<List<FeaturedService>> searchServices(String query);
  Future<List<FeaturedService>> getServicesByCategory(String categoryId);
  Future<HallModel> getHallDetails(int id);
  Future<ServiceModel> getServiceDetails(int id);
}

/// Implementation of HomeRepository
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl({required HomeRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<FeaturedService>> getFeaturedServices() async {
    try {
      // Get featured halls and services
      final featuredHalls = await _remoteDataSource.getFeaturedHalls();
      final featuredServices = await _remoteDataSource.getFeaturedServices();
      
      // Convert to FeaturedService entities
      final List<FeaturedService> result = [];
      
      // Add featured halls
      result.addAll(featuredHalls.map((hall) => hall.toFeaturedService()));
      
      // Add featured services
      result.addAll(featuredServices.map((service) => service.toFeaturedService()));
      
      // Limit to 8 items for home display
      return result.take(8).toList();
    } catch (e) {
      // Return fake data as fallback
      return _getFakeFeaturedServices();
    }
  }

  @override
  Future<List<ServiceCategory>> getServiceCategories() async {
    try {
      final categories = await _remoteDataSource.getServiceCategories();
      return categories.map((category) => category.toServiceCategory()).toList();
    } catch (e) {
      // Return fake data as fallback
      return _getFakeServiceCategories();
    }
  }

  @override
  Future<List<HallModel>> getFeaturedHalls() async {
    try {
      return await _remoteDataSource.getFeaturedHalls();
    } catch (e) {
      // Return fake data as fallback
      return _getFakeFeaturedHalls();
    }
  }

  @override
  Future<List<FeaturedService>> getAllServices() async {
    try {
      // Get all halls and services
      final halls = await _remoteDataSource.getHalls();
      final services = await _remoteDataSource.getServices();
      
      // Convert to FeaturedService entities
      final List<FeaturedService> result = [];
      
      // Add halls
      result.addAll(halls.map((hall) => hall.toFeaturedService()));
      
      // Add services
      result.addAll(services.map((service) => service.toFeaturedService()));
      
      return result;
    } catch (e) {
      // Return fake data as fallback
      return _getFakeAllServices();
    }
  }

  @override
  Future<List<FeaturedService>> searchServices(String query) async {
    try {
      final services = await _remoteDataSource.searchServices(query);
      return services.map((service) => service.toFeaturedService()).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException();
    }
  }

  @override
  Future<List<FeaturedService>> getServicesByCategory(String categoryId) async {
    try {
      final services = await _remoteDataSource.getServicesByCategory(categoryId);
      return services.map((service) => service.toFeaturedService()).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException();
    }
  }

  @override
  Future<HallModel> getHallDetails(int id) async {
    try {
      return await _remoteDataSource.getHallDetails(id);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException();
    }
  }

  @override
  Future<ServiceModel> getServiceDetails(int id) async {
    try {
      return await _remoteDataSource.getServiceDetails(id);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const NetworkException();
    }
  }

  /// Get fake featured services data
  List<FeaturedService> _getFakeFeaturedServices() {
    return [
      const FeaturedService(
        id: '1',
        title: 'خدمة التصوير الاحترافية',
        subtitle: 'تصوير احترافي للزفاف والمناسبات',
        imageUrl: 'assets/images/017-photography.png',
        price: 5000,
        rating: 4.7,
      ),
      const FeaturedService(
        id: '2',
        title: 'خدمة الضيافة الفاخرة',
        subtitle: 'وجبات فاخرة ومتنوعة للمناسبات',
        imageUrl: 'assets/images/011-wedding-dinner.png',
        price: 8000,
        rating: 4.5,
      ),
      const FeaturedService(
        id: '3',
        title: 'عربيات زفاف فاخرة',
        subtitle: 'عربيات زفاف أنيقة ومريحة',
        imageUrl: 'assets/images/008-wedding-car.png',
        price: 3000,
        rating: 4.6,
      ),
      const FeaturedService(
        id: '4',
        title: 'خدمة الديكور والزينة',
        subtitle: 'ديكورات رائعة ومتنوعة',
        imageUrl: 'assets/images/004-wedding-arch.png',
        price: 6000,
        rating: 4.8,
      ),
    ];
  }

  /// Get fake service categories data
  List<ServiceCategory> _getFakeServiceCategories() {
    return [
      const ServiceCategory(
        id: '1',
        name: 'قاعات الأفراح',
        image: 'assets/images/004-wedding-arch.png',
        serviceCount: 25,
      ),
      const ServiceCategory(
        id: '2',
        name: 'فساتين الزفاف',
        image: 'assets/images/004-wedding-arch.png',
        serviceCount: 18,
      ),
      const ServiceCategory(
        id: '3',
        name: 'التصوير والفيديو',
        image: 'assets/images/017-photography.png',
        serviceCount: 32,
      ),
      const ServiceCategory(
        id: '4',
        name: 'الضيافة والطعام',
        image: 'assets/images/011-wedding-dinner.png',
        serviceCount: 15,
      ),
      const ServiceCategory(
        id: '5',
        name: 'الديكور والزينة',
        image: 'assets/images/004-wedding-arch.png',
        serviceCount: 22,
      ),
      const ServiceCategory(
        id: '6',
        name: 'الموسيقى والترفيه',
        image: 'assets/images/004-wedding-arch.png',
        serviceCount: 12,
      ),
      const ServiceCategory(
        id: '7',
        name: 'عربيات زفاف',
        image: 'assets/images/008-wedding-car.png',
        serviceCount: 12,
      ),
      const ServiceCategory(
        id: '8',
        name: 'ميكب ارتست',
        image: 'assets/images/004-wedding-arch.png',
        serviceCount: 12,
      ),
    ];
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

  /// Get fake all services data
  List<FeaturedService> _getFakeAllServices() {
    return [
      ..._getFakeFeaturedServices(),
      const FeaturedService(
        id: '5',
        title: 'خدمة الميكب والجمال',
        subtitle: 'ميكب احترافي للعروس',
        imageUrl: 'assets/images/004-wedding-arch.png',
        price: 2500,
        rating: 4.4,
      ),
      const FeaturedService(
        id: '6',
        title: 'خدمة الموسيقى والترفيه',
        subtitle: 'فرق موسيقية وترفيهية',
        imageUrl: 'assets/images/004-wedding-arch.png',
        price: 4000,
        rating: 4.3,
      ),
    ];
  }
}
