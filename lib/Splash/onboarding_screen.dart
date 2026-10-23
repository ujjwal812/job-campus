import 'package:flutter/material.dart';
import '../app_routes/app_routs.dart';
import '../core/app_theams.dart';
import '../local_Store/local_store.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.work_outline_rounded,
      'title': 'Discover Opportunities',
      'description':
          'Explore top internships, entry-level jobs, and campus placement drives tailored for you.',
      'color': const Color(0xFF0A858C),
      'iconColor': const Color(0xFFA5E6E2),
    },
    {
      'icon': Icons.school_outlined,
      'title': 'Campus Drives',
      'description':
          'Stay updated with upcoming placement drives, events, and top recruiters visiting your campus.',
      'color': const Color(0xFF0B757B),
      'iconColor': const Color(0xFF77DAD7),
    },
    {
      'icon': Icons.rocket_launch_outlined,
      'title': 'Fast Application',
      'description':
          'Apply to multiple top companies effortlessly and track your job application status in real-time.',
      'color': const Color(0xFF36B8B7),
      'iconColor': Colors.white,
    },
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _openLogin();
    }
  }

  Future<void> _openLogin() async {
    await LocalStore.instance.setOnboardingCompleted(true);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      body: Container(
        decoration: AppTheme.screenBackgroundGradient(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      _pageController.animateToPage(
                        _pages.length - 1,
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text(
                      isLastPage ? '' : 'Skip',
                      style: const TextStyle(
                        color: AppTheme.lightIceTeal,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      final item = _pages[index];

                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        child: Container(
                          key: ValueKey(index),
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          padding: const EdgeInsets.all(28),
                          decoration: AppTheme.glassDecoration(
                            opacity: 0.18,
                            borderOpacity: 0.28,
                            radius: 28,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 180,
                                width: 180,
                                decoration: BoxDecoration(
                                  color: (item['color'] as Color)
                                      .withValues(alpha: 0.35),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.30),
                                    width: 1.5,
                                  ),
                                ),
                                child: Icon(
                                  item['icon'] as IconData,
                                  size: 90,
                                  color: item['iconColor'] as Color,
                                ),
                              ),
                              const SizedBox(height: 38),
                              Text(
                                item['title'] as String,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                item['description'] as String,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.6,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentPage == index ? 28 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? AppTheme.softMintTeal
                            : Colors.white.withValues(alpha: 0.30),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.vibrantTeal,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: AppTheme.darkTeal.withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isLastPage ? 'Get Started' : 'Next',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.arrow_forward_rounded),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
