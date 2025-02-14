import 'package:flutter/material.dart';
import '../../config/constants.dart';

class OnboardingContent {
  final String title;
  final String description;
  final String imagePath;
  final IconData icon;
  final Color backgroundColor;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.icon,
    required this.backgroundColor,
  });
}

final List<OnboardingContent> onboardingContents = [
  OnboardingContent(
    title: 'Track Your Vitals',
    description: 'Monitor your blood pressure and pulse rate easily with our intuitive interface.',
    imagePath: 'assets/images/onboarding1.png',
    icon: Icons.favorite,
    backgroundColor: AppColors.lightGreen,
  ),
  OnboardingContent(
    title: 'View History',
    description: 'Check your health progress over time with detailed history and trends.',
    imagePath: 'assets/images/onboarding2.png',
    icon: Icons.insert_chart,
    backgroundColor: AppColors.lime,
  ),
  OnboardingContent(
    title: 'Stay Healthy',
    description: 'Get insights and recommendations based on your health data.',
    imagePath: 'assets/images/onboarding3.png',
    icon: Icons.health_and_safety,
    backgroundColor: AppColors.lightPurple,
  ),
];