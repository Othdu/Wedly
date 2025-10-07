import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class GoldenButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final double? width;
  final double? height;

  const GoldenButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final buttonHeight = height ?? AppConstants.buttonHeight;
    
    if (isOutlined) {
      return SizedBox(
        width: width,
        height: buttonHeight,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(
              color: AppColors.primaryGolden,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
          ),
          child: _buildButtonContent(),
        ),
      );
    }

    return Container(
      width: width,
      height: buttonHeight,
      decoration: BoxDecoration(
        gradient: onPressed != null && !isLoading
            ? AppColors.goldenGradient
            : LinearGradient(
                colors: [
                  AppColors.primaryGolden.withOpacity(0.5),
                  AppColors.goldenLight.withOpacity(0.5),
                ],
              ),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: onPressed != null && !isLoading
            ? AppColors.goldenShadowMedium
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          child: _buildButtonContent(),
        ),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isOutlined ? AppColors.primaryGolden : AppColors.white,
            size: AppConstants.iconSizeSM,
          ),
          const SizedBox(width: AppConstants.spacingSM),
          Text(
            text,
            style: TextStyle(
              fontSize: AppConstants.fontSizeMD,
              fontWeight: FontWeight.w600,
              color: isOutlined ? AppColors.primaryGolden : AppColors.white,
            ),
          ),
        ],
      );
    }

    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: AppConstants.fontSizeMD,
          fontWeight: FontWeight.w600,
          color: isOutlined ? AppColors.primaryGolden : AppColors.white,
        ),
      ),
    );
  }
}