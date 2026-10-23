import 'package:flutter/material.dart';
import '../../core/app_theams.dart';

class HomeBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const HomeBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  static const Color lightIceTeal = Color(0xFFA5E6E2);
  static const Color softMintTeal = Color(0xFF77DAD7);
  static const Color darkTeal = Color(0xFF0A858C);
  static const Color darkNavy = Color(0xFF12345A);

  static const items = [
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    _NavItem(
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore_rounded,
      label: 'Explore',
    ),
    _NavItem(
      icon: Icons.bookmark_border_rounded,
      activeIcon: Icons.bookmark_rounded,
      label: 'Saved',
    ),
    _NavItem(
      icon: Icons.work_outline_rounded,
      activeIcon: Icons.work_rounded,
      label: 'Applied',
    ),
    _NavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeModeNotifier,
      builder: (context, mode, child) {
        final isDark = mode == ThemeMode.dark;

        final navBg = isDark
            ? const Color(0xFF075459).withValues(alpha: 0.96)
            : Colors.white;

        final borderColor = isDark
            ? Colors.white.withValues(alpha: 0.15)
            : const Color(0xFFE2E8F0);

        return Container(
          decoration: BoxDecoration(
            color: navBg,
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
            border: Border(
              top: BorderSide(
                color: borderColor,
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  final selected = selectedIndex == index;

                  Color selectedItemBg;
                  Color iconColor;
                  Color textColor;

                  if (isDark) {
                    selectedItemBg = darkTeal.withValues(alpha: 0.85);
                    iconColor = selected ? lightIceTeal : Colors.white70;
                    textColor = selected ? lightIceTeal : Colors.white70;
                  } else {
                    selectedItemBg = const Color(0xFFEAF7F6);
                    iconColor = selected ? darkTeal : const Color(0xFF64748B);
                    textColor = selected ? darkTeal : const Color(0xFF64748B);
                  }

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onItemSelected(index),
                      behavior: HitTestBehavior.opaque,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: selected ? selectedItemBg : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          border: selected
                              ? Border.all(
                                  color: isDark
                                      ? softMintTeal.withValues(alpha: 0.50)
                                      : darkTeal.withValues(alpha: 0.30),
                                  width: 1,
                                )
                              : null,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              selected ? item.activeIcon : item.icon,
                              size: 22,
                              color: iconColor,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: selected
                                    ? FontWeight.w800
                                    : FontWeight.w500,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
