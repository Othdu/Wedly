import 'package:flutter/material.dart';

/// Model for onboarding slide content
class OnboardingModel {
  final String title;
  final String description;
  final IconData? icon;
  final String? imagePath;
  final Color? backgroundColor;

  const OnboardingModel({
    required this.title,
    required this.description,
    this.icon,
    this.imagePath,
    this.backgroundColor,
  });
}

/// Static data for onboarding slides
class OnboardingData {
  static const List<OnboardingModel> slides = [
    OnboardingModel(
      icon: Icons.auto_awesome,
      title: 'مرحباً بك في ويدلي', // Welcome to Wedly
      description: 'حيث تبدأ حكاية حبك بلمسة من الفخامة والذهب.',
        imagePath: 'assets/images/welcome.png', // minimalist sparkles for logo settling
    ),
    OnboardingModel(
      title: 'خطط ليومك المميز بسهولة', // Plan your dream wedding effortlessly
      description: 'من التفاصيل الصغيرة إلى اللحظات الكبيرة، كل شيء في مكان واحد.',
      imagePath: 'assets/images/planing.png', // elegant icons will be composed
    ),
    OnboardingModel(
      title: 'احتفظ بسحر كل لحظة', // Capture every magical moment
      description: 'ذكريات يومك الجميل تبقى خالدة مع ويدلي.',
      imagePath: 'assets/images/memories.png',
    ),
  ];
}
