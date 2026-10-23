import 'package:flutter/material.dart';
import '../../core/app_theams.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onNotificationTap;
  final VoidCallback? onProfileTap;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeModeNotifier,
      builder: (context, mode, child) {
        final isDark = mode == ThemeMode.dark;

        final menuBtnBg = isDark
            ? Colors.white.withValues(alpha: 0.18)
            : const Color(0xFFE2E8F0);
        final menuBtnBorder = isDark
            ? Colors.white.withValues(alpha: 0.3)
            : const Color(0xFFCBD5E1);
        final menuBtnIcon = isDark ? Colors.white : AppTheme.darkNavy;

        final subText = isDark ? Colors.white70 : const Color(0xFF475569);
        final titleText = isDark ? Colors.white : AppTheme.darkNavy;

        return Row(
          children: [
            Material(
              color: menuBtnBg,
              borderRadius: BorderRadius.circular(15),
              child: InkWell(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: menuBtnBorder),
                  ),
                  child: Icon(
                    Icons.menu_rounded,
                    color: menuBtnIcon,
                    size: 26,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back 👋',
                    style: TextStyle(
                      color: subText,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    userName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                      color: titleText,
                    ),
                  ),
                ],
              ),
            ),
            Material(
              color: isDark ? Colors.white : AppTheme.darkTeal,
              borderRadius: BorderRadius.circular(15),
              child: InkWell(
                onTap: onNotificationTap,
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  width: 46,
                  height: 46,
                  child: Icon(
                    Icons.notifications_none_rounded,
                    color: isDark ? AppTheme.deepTeal : Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
