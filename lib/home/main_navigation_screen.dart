import 'package:flutter/material.dart';

import '../core/app_theams.dart';
import '../screen/home_screen.dart';
import '../screen/explore_screen.dart';
import '../screen/saved_jobs_screen.dart';
import '../screen/applied_jobs_screen.dart';
import '../Profile/profile_screen.dart';
import 'widgets/app_drawer.dart';
import 'widgets/home_bottom_nav.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _screens = const [
    JobCampusHomeScreen(),
    ExploreScreen(),
    SavedJobsScreen(),
    AppliedJobsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeModeNotifier,
      builder: (context, mode, child) {
        final isDark = mode == ThemeMode.dark;

        return Scaffold(
          backgroundColor: isDark ? AppTheme.deepTeal : AppTheme.lightIceTeal,
          drawer: AppDrawer(
            currentTabIndex: _currentIndex,
            onTabSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          body: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: AppTheme.screenBackgroundGradient(isDarkMode: isDark),
            child: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
          ),
          bottomNavigationBar: HomeBottomNav(
            selectedIndex: _currentIndex,
            onItemSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        );
      },
    );
  }
}
