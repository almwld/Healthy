import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _slides = [
    {'icon': Icons.medical_services, 'title': AppStrings.onboarding1Title, 'desc': AppStrings.onboarding1Desc, 'color': AppColors.primary},
    {'icon': Icons.local_shipping, 'title': AppStrings.onboarding2Title, 'desc': AppStrings.onboarding2Desc, 'color': AppColors.secondary},
    {'icon': Icons.favorite, 'title': AppStrings.onboarding3Title, 'desc': AppStrings.onboarding3Desc, 'color': AppColors.accent},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemCount: _slides.length,
              itemBuilder: (context, index) => _buildSlide(_slides[index]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(_slides.length, (i) =>
                  Container(margin: const EdgeInsets.symmetric(horizontal: 4), width: _currentPage == i ? 24 : 8, height: 8,
                    decoration: BoxDecoration(color: _currentPage == i ? AppColors.primary : AppColors.divider, borderRadius: BorderRadius.circular(4)),
                  ),
                )),
                const SizedBox(height: 24),
                if (_currentPage == _slides.length - 1)
                  ElevatedButton(onPressed: () => context.go('/login'), child: const Text(AppStrings.startNow))
                else
                  TextButton(onPressed: () => _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease), child: const Text(AppStrings.next)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(Map<String, dynamic> slide) => Padding(
    padding: const EdgeInsets.all(40),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 200, height: 200, decoration: BoxDecoration(color: slide['color'].withOpacity(0.1), borderRadius: BorderRadius.circular(100)),
        child: Icon(slide['icon'], size: 80, color: slide['color']),
      ),
      const SizedBox(height: 40),
      Text(slide['title'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      const SizedBox(height: 16),
      Text(slide['desc'], textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: AppColors.textSecondary)),
    ]),
  );
}
