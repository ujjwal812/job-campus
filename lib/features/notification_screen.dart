import 'package:flutter/material.dart';
import '../core/app_theams.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'Application Shortlisted! 🎉',
      'subtitle':
          'TechNova Solutions has shortlisted your resume for Flutter Developer.',
      'time': '2h ago',
      'isRead': false,
      'type': 'status',
      'icon': Icons.check_circle_outline_rounded,
      'color': const Color(0xFF77DAD7),
    },
    {
      'id': '2',
      'title': 'New Placement Drive Alert 🏫',
      'subtitle': 'Wipro Campus Drive announced for 2025 batch graduates.',
      'time': '5h ago',
      'isRead': false,
      'type': 'drive',
      'icon': Icons.school_outlined,
      'color': const Color(0xFFA5E6E2),
    },
    {
      'id': '3',
      'title': 'New Recommended Job 💼',
      'subtitle':
          'Creative Studio posted UI/UX Designer role matching your profile.',
      'time': '1d ago',
      'isRead': true,
      'type': 'job',
      'icon': Icons.work_outline_rounded,
      'color': const Color(0xFF36B8B7),
    },
    {
      'id': '4',
      'title': 'Profile Strength Tip 💡',
      'subtitle':
          'Add 2 more skills to get 3x higher profile views from employers.',
      'time': '2d ago',
      'isRead': true,
      'type': 'tip',
      'icon': Icons.lightbulb_outline_rounded,
      'color': const Color(0xFFE69A38),
    },
  ];

  void _markAllAsRead() {
    setState(() {
      for (var item in _notifications) {
        item['isRead'] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleNotificationRead(int index) {
    setState(() {
      _notifications[index]['isRead'] =
          !(_notifications[index]['isRead'] as bool);
    });
  }

  void _clearNotifications() {
    setState(() {
      _notifications.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notifications cleared.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount =
        _notifications.where((n) => !(n['isRead'] as bool)).length;

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeModeNotifier,
      builder: (context, mode, child) {
        final isDark = mode == ThemeMode.dark;
        final primaryText = isDark ? Colors.white : AppTheme.darkNavy;
        final subText = isDark ? Colors.white70 : const Color(0xFF475569);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: isDark ? Colors.transparent : Colors.white,
            elevation: isDark ? 0 : 0.5,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: primaryText,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Notifications',
              style: TextStyle(
                color: primaryText,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            actions: [
              if (_notifications.isNotEmpty) ...[
                TextButton(
                  onPressed: _markAllAsRead,
                  child: Text(
                    'Mark read',
                    style: TextStyle(
                      color: isDark ? AppTheme.lightIceTeal : AppTheme.darkTeal,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: isDark ? Colors.white70 : AppTheme.darkNavy,
                  ),
                  onPressed: _clearNotifications,
                ),
              ],
            ],
          ),
          body: Container(
            decoration: AppTheme.screenBackgroundGradient(isDarkMode: isDark),
            child: SafeArea(
              child: _notifications.isEmpty
                  ? Center(
                      child: Container(
                        margin: const EdgeInsets.all(28),
                        padding: const EdgeInsets.all(28),
                        decoration: AppTheme.glassDecoration(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: (isDark
                                        ? AppTheme.lightIceTeal
                                        : AppTheme.darkTeal)
                                    .withValues(alpha: 0.20),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.notifications_off_outlined,
                                size: 40,
                                color: isDark
                                    ? AppTheme.lightIceTeal
                                    : AppTheme.darkTeal,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              'No Notifications',
                              style: TextStyle(
                                color: primaryText,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'You are all caught up! Check back later.',
                              style: TextStyle(color: subText, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        if (unreadCount > 0)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            color: isDark
                                ? Colors.black.withValues(alpha: 0.20)
                                : const Color(0xFFE2E8F0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.mark_email_unread_outlined,
                                  size: 18,
                                  color: isDark
                                      ? AppTheme.lightIceTeal
                                      : AppTheme.darkTeal,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '$unreadCount unread notification${unreadCount > 1 ? 's' : ''}',
                                  style: TextStyle(
                                    color: primaryText,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.all(18),
                            itemCount: _notifications.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final item = _notifications[index];
                              final isRead = item['isRead'] as bool;
                              final color = item['color'] as Color;

                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => _toggleNotificationRead(index),
                                  borderRadius: BorderRadius.circular(18),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: AppTheme.glassDecoration(),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: color.withValues(alpha: 0.20),
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            border: Border.all(
                                              color: color.withValues(alpha: 0.40),
                                            ),
                                          ),
                                          child: Icon(
                                            item['icon'] as IconData,
                                            color: color,
                                            size: 22,
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      item['title'] as String,
                                                      style: TextStyle(
                                                        color: primaryText,
                                                        fontSize: 14,
                                                        fontWeight: isRead
                                                            ? FontWeight.w700
                                                            : FontWeight.w900,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    item['time'] as String,
                                                    style: TextStyle(
                                                      color: isDark
                                                          ? Colors.white54
                                                          : const Color(
                                                              0xFF64748B),
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                item['subtitle'] as String,
                                                style: TextStyle(
                                                  color: subText,
                                                  fontSize: 12,
                                                  height: 1.4,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
