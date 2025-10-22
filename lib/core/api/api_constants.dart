/// API Constants for WEDLY Backend Integration
/// Contains all API endpoints and configuration constants
class ApiConstants {
  // Base URL for the wedly-app backend
  static const String baseUrl = 'https://wedly-app-258355634687.me-central1.run.app';
  
  // API Version (if needed)
  static const String apiVersion = 'v1';
  
  // Request Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // Headers
  static const String contentType = 'application/json';
  static const String acceptHeader = 'application/json';
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
  
  // Authentication Endpoints
  static const String registerEndpoint = '/accounts/register/';
  static const String loginEndpoint = '/accounts/login/';
  static const String profileEndpoint = '/accounts/profile/';
  static const String logoutEndpoint = '/accounts/logout/';
  static const String tokenRefreshEndpoint = '/token/refresh/';
  static const String passwordResetEndpoint = '/accounts/password-reset/';
  static const String passwordResetConfirmEndpoint = '/accounts/password-reset-confirm/';
  
  // Halls Endpoints
  static const String hallsEndpoint = '/halls/';
  static const String featuredHallsEndpoint = '/halls/featured/';
  static String hallDetailsEndpoint(String id) => '/halls/$id/';
  
  // Services Endpoints
  static const String servicesEndpoint = '/services/';
  static const String servicesStorefrontEndpoint = '/services/storefront/';
  static const String servicesSchemaEndpoint = '/services/schema/';
  static String serviceDetailsEndpoint(String id) => '/services/$id/';
  
  // Bookings Endpoints
  static const String bookingsEndpoint = '/bookings/';
  static const String myBookingsEndpoint = '/bookings/my-bookings/';
  static String bookingDetailsEndpoint(String id) => '/bookings/$id/';
  
  // Reviews Endpoints
  static const String reviewsEndpoint = '/reviews/';
  static String reviewDetailsEndpoint(String id) => '/reviews/$id/';
  
  // Payments Endpoints
  static const String paymentsEndpoint = '/payments/';
  static String paymentReceiptEndpoint(String id) => '/payments/receipt/$id/';
  
  // Notifications Endpoints
  static const String notificationsEndpoint = '/notifications/';
  static String markNotificationReadEndpoint(String id) => '/notifications/mark-read/$id/';
  
  // Cloud/Firebase Endpoints
  static const String cloudCollectionsEndpoint = '/cloud/collections/';
  static const String cloudUsersEndpoint = '/cloud/collections/users/';
  
  // Dashboard Endpoints
  static const String userDashboardEndpoint = '/accounts/dashboard/user/';
  static const String adminDashboardEndpoint = '/accounts/dashboard/admin/';
  static const String ownerDashboardEndpoint = '/accounts/dashboard/owner/';
  static const String serviceDashboardEndpoint = '/accounts/dashboard/service/';
  
  // Query Parameters
  static const String searchParam = 'search';
  static const String categoryParam = 'category';
  static const String pageParam = 'page';
  static const String pageSizeParam = 'page_size';
  static const String orderingParam = 'ordering';
  static const String statusParam = 'status';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Error Messages
  static const String networkErrorMessage = 'تحقق من اتصال الإنترنت';
  static const String serverErrorMessage = 'خطأ في الخادم، حاول مرة أخرى';
  static const String unauthorizedErrorMessage = 'انتهت صلاحية الجلسة، يرجى تسجيل الدخول مرة أخرى';
  static const String notFoundErrorMessage = 'البيانات المطلوبة غير موجودة';
  static const String validationErrorMessage = 'البيانات المدخلة غير صحيحة';
  
  // Success Messages
  static const String loginSuccessMessage = 'تم تسجيل الدخول بنجاح';
  static const String registerSuccessMessage = 'تم إنشاء الحساب بنجاح';
  static const String bookingSuccessMessage = 'تم الحجز بنجاح';
  static const String updateSuccessMessage = 'تم التحديث بنجاح';
  static const String deleteSuccessMessage = 'تم الحذف بنجاح';
}
