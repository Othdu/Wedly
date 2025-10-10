import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class QuickServiceCard extends StatelessWidget {
  final Map<String, dynamic> service;
  final VoidCallback onTap;

  const QuickServiceCard({
    super.key,
    required this.service,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          boxShadow: [
            BoxShadow(
              color: (service['color'] as Color).withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with gradient
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: service['gradient'] as LinearGradient,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppConstants.borderRadiusLarge),
                    topRight: Radius.circular(AppConstants.borderRadiusLarge),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppConstants.spacingMD),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                      ),
                      child: Icon(
                        service['icon'] as IconData,
                        size: AppConstants.iconSizeXL,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingSM),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingSM,
                        vertical: AppConstants.spacingXS,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                      ),
                      child: const Text(
                        'سريع',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: AppConstants.fontSizeXS,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Content
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingMD),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service['title'] as String,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: AppConstants.spacingSM),
                    
                    Expanded(
                      child: Text(
                        service['subtitle'] as String,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    const SizedBox(height: AppConstants.spacingMD),
                    
                    // Price and Book Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingSM,
                            vertical: AppConstants.spacingXS,
                          ),
                          decoration: BoxDecoration(
                            color: (service['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                          ),
                          child: Text(
                            '${service['price']} ج.م',
                            style: TextStyle(
                              color: service['color'] as Color,
                              fontSize: AppConstants.fontSizeSM,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        
                        Container(
                          padding: const EdgeInsets.all(AppConstants.spacingXS),
                          decoration: BoxDecoration(
                            gradient: service['gradient'] as LinearGradient,
                            borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: AppColors.white,
                            size: AppConstants.iconSizeSM,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
