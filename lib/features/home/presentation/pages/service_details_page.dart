import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/hall_model.dart';
import '../../../booking/presentation/pages/booking_page.dart';

class ServiceDetailsPage extends StatefulWidget {
  final String serviceId;
  final FeaturedService? service;

  const ServiceDetailsPage({
    super.key,
    required this.serviceId,
    this.service,
  });

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final service = widget.service;
    
    if (service == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('تفاصيل الخدمة'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: const Center(
          child: Text('الخدمة غير موجودة'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Service Image
                  service.imageUrl.startsWith('http')
                      ? Image.network(
                          service.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: AppColors.lightGray,
                            child: const Center(
                              child: Icon(
                                Icons.broken_image_outlined,
                                size: 80,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        )
                      : Image.asset(
                          service.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: AppColors.lightGray,
                            child: const Center(
                              child: Icon(
                                Icons.broken_image_outlined,
                                size: 80,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                  
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  
                  // Favorite Button
                  Positioned(
                    top: 50,
                    right: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _isFavorite = !_isFavorite;
                          });
                          // TODO: Implement favorite functionality with backend
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(_isFavorite 
                                ? 'تم إضافة العنصر إلى المفضلة' 
                                : 'تم إزالة العنصر من المفضلة'),
                              backgroundColor: _isFavorite 
                                ? AppColors.successGreen 
                                : AppColors.textSecondary,
                            ),
                          );
                        },
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite ? Colors.red : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  
                  // Back Button
                  Positioned(
                    top: 50,
                    left: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Service Details Content
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.borderRadiusLarge),
                  topRight: Radius.circular(AppConstants.borderRadiusLarge),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingLG),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service Title and Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            service.title,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingMD,
                            vertical: AppConstants.spacingSM,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.goldenGradient,
                            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                          ),
                          child: Text(
                            '${service.price.toStringAsFixed(0)} جنيه',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: AppConstants.fontSizeLG,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppConstants.spacingMD),

                    // Rating
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppColors.primaryGolden,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          service.rating.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(4.5)',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppConstants.spacingLG),

                    // Description
                    Text(
                      'الوصف',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingSM),
                    Text(
                      service.subtitle,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: AppConstants.spacingLG),

                    // Features
                    Text(
                      'المميزات',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingSM),
                    _buildFeatureItem('خدمة متميزة', Icons.star),
                    _buildFeatureItem('أسعار تنافسية', Icons.attach_money),
                    _buildFeatureItem('دعم فني 24/7', Icons.support_agent),
                    _buildFeatureItem('ضمان الجودة', Icons.verified),

                    const SizedBox(height: AppConstants.spacingXXL),

                    // Book Now Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BookingPage(
                                serviceId: service.id,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGolden,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppConstants.spacingLG,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                          ),
                        ),
                        child: const Text(
                          'احجز الآن',
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeLG,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppConstants.spacingLG),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingSM),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primaryGolden,
            size: 20,
          ),
          const SizedBox(width: AppConstants.spacingSM),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
