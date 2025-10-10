import 'package:flutter/material.dart';

/// Model for onboarding slide content
class OnboardingModel {
  final String title;
  final String description;
  final IconData icon;
  final String? imagePath;
  final Color? backgroundColor;

  const OnboardingModel({
    required this.title,
    required this.description,
    required this.icon,
    this.imagePath,
    this.backgroundColor,
  });
}

/// Static data for onboarding slides
class OnboardingData {
  static const List<OnboardingModel> slides = [
    OnboardingModel(
      title: 'احجز قاعة أحلامك',
      description: 'اكتشف أفضل قاعات الأفراح الفاخرة واحجز قاعة أحلامك بسهولة وأمان',
      icon: Icons.event_seat,
    ),
    OnboardingModel(
      title: 'خطط لزفاف مثالي',
      description: 'احصل على خدمات التخطيط الشاملة لزفافك من أفضل الخبراء في المملكة',
      icon: Icons.event_note,
    ),
    OnboardingModel(
      title: 'اكتشف أفضل المزودين',
      description: 'تصفح سوق واسع من مزودي الخدمات الموثوقين لجميع احتياجات زفافك',
      icon: Icons.store,
    ),
  ];
}
