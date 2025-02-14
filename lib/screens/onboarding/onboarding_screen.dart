import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../config/constants.dart';
import 'onboarding_content.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: onboardingContents.length,
                itemBuilder: (context, index) {
                  return _OnboardingPage(content: onboardingContents[index]);
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: onboardingContents.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: AppColors.primary,
                      dotColor: AppColors.lightPurple.withOpacity(0.5),
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 4,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                            );
                          },
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_currentPage == onboardingContents.length - 1) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (_) => const LoginScreen()),
                              );
                            } else {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            _currentPage == onboardingContents.length - 1 ? 'Get Started' : 'Next',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingContent content;

  const _OnboardingPage({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              color: content.backgroundColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                content.icon,
                size: 100,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            content.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            content.description,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}