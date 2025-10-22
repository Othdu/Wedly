/// WEDLY App Constants
/// Application-wide constants and configuration
class AppConstants {
  // App Information
  static const String appName = 'WEDLY';
  static const String appTagline = 'Your Wedding, Our Passion';
  static const String appVersion = '1.0.0';
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // UI Constants
  static const double borderRadius = 8.0; // 0.5rem equivalent
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusSmall = 4.0;
  
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  // Font Sizes
  static const double fontSizeXS = 12.0;
  static const double fontSizeSM = 14.0;
  static const double fontSizeMD = 16.0;
  static const double fontSizeLG = 18.0;
  static const double fontSizeXL = 20.0;
  static const double fontSizeXXL = 24.0;
  static const double fontSizeXXXL = 32.0;
  
  // Icon Sizes
  static const double iconSizeXS = 16.0;
  static const double iconSizeSM = 20.0;
  static const double iconSizeMD = 24.0;
  static const double iconSizeLG = 32.0;
  static const double iconSizeXL = 48.0;
  
  // Card Dimensions
  static const double cardHeight = 120.0;
  static const double cardHeightLarge = 200.0;
  static const double cardPadding = 16.0;
  
  // Button Dimensions
  static const double buttonHeight = 48.0;
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeightLarge = 56.0;
  
  // Input Field Dimensions
  static const double inputHeight = 48.0;
  static const double inputBorderRadius = 8.0;
  
  // App Bar
  static const double appBarHeight = 56.0;
  static const double appBarElevation = 0.0;
  
  // Bottom Navigation
  static const double bottomNavHeight = 60.0;
  static const double bottomNavIconSize = 24.0;
  
  // Image Dimensions
  static const double imageAspectRatio = 16 / 9;
  static const double avatarSize = 40.0;
  static const double avatarSizeLarge = 80.0;
  
  // Service Categories (Arabic)
  static const List<Map<String, String>> serviceCategories = [
    {
      'id': 'venues',
      'name': 'قاعات الأفراح',
      'nameEn': 'Wedding Venues',
      'icon': 'venue',
    },
    {
      'id': 'dresses',
      'name': 'فساتين الزفاف',
      'nameEn': 'Wedding Dresses',
      'icon': 'dress',
    },
    {
      'id': 'photography',
      'name': 'التصوير والفيديو',
      'nameEn': 'Photography & Video',
      'icon': 'camera',
    },
    {
      'id': 'catering',
      'name': 'الضيافة والطعام',
      'nameEn': 'Catering & Food',
      'icon': 'food',
    },
    {
      'id': 'decoration',
      'name': 'الديكور والزينة',
      'nameEn': 'Decoration & Flowers',
      'icon': 'flower',
    },
    {
      'id': 'music',
      'name': 'الموسيقى والترفيه',
      'nameEn': 'Music & Entertainment',
      'icon': 'music',
    },
    {
      'id': 'transportation',
      'name': 'النقل والمواصلات',
      'nameEn': 'Transportation',
      'icon': 'car',
    },
    {
      'id': 'makeup',
      'name': 'التجميل والعناية',
      'nameEn': 'Makeup & Beauty',
      'icon': 'makeup',
    },
  ];
  
  // Navigation Routes
  static const String routeSplash = '/splash';
  static const String routeHome = '/';
  static const String routeAuth = '/auth';
  static const String routeLogin = '/auth/login';
  static const String routeRegister = '/auth/register';
  static const String routeForgotPassword = '/auth/forgot-password';
  static const String routeVendors = '/vendors';
  static const String routeQuickBook = '/quick-book';
  static const String routeFavorites = '/favorites';
  static const String routeFeedback = '/feedback';
  static const String routeProfile = '/profile';
  static const String routeBooking = '/booking';
  static const String routeServiceDetail = '/service';
  static const String routeSearch = '/search';
  static const String routeVendorDashboard = '/vendor/dashboard';
  
  // Storage Keys
  static const String keyUserToken = 'user_token';
  static const String keyUserData = 'user_data';
  static const String keyLanguage = 'language';
  static const String keyTheme = 'theme';
  static const String keyOnboarding = 'onboarding_completed';
  
  // Languages
  static const String languageArabic = 'ar';
  static const String languageEnglish = 'en';
  
  // Default Language
  static const String defaultLanguage = languageArabic;
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // File Upload
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;
  
  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'dd/MM/yyyy';
  static const String displayDateTimeFormat = 'dd/MM/yyyy HH:mm';
}