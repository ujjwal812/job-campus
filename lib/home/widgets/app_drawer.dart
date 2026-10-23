import 'package:flutter/material.dart';
import '../../app_routes/app_routs.dart';
import '../../local_Store/local_store.dart';

class AppDrawer extends StatelessWidget {
  final int currentTabIndex;
  final ValueChanged<int> onTabSelected;

  const AppDrawer({
    super.key,
    required this.currentTabIndex,
    required this.onTabSelected,
  });

  static const Color navy = Color(0xFF12345A);
  static const Color teal = Color(0xFF0CA997);
  static const Color lightTeal = Color(0xFFA5E6E2);

  @override
  Widget build(BuildContext context) {
    final userName = LocalStore.instance.getUserName() ?? 'Job Seeker';
    final userEmail = LocalStore.instance.getUserEmail() ?? 'seeker@jobcampus.in';
    final userHeadline =
        LocalStore.instance.getUserHeadline() ?? 'Fresher | Open to Opportunities';

    return Drawer(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F2B48),
              Color(0xFF12345A),
              Color(0xFF0B5861),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ---------------------------------------------------------------
              // NAUKRI-STYLE USER PROFILE HEADER CARD
              // ---------------------------------------------------------------
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: teal.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            backgroundColor: Color(0xFFE0F2F1),
                            child: Icon(
                              Icons.person_rounded,
                              size: 36,
                              color: teal,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                userHeadline,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: lightTeal,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                userEmail,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Profile Completion Progress Bar
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.stars_rounded,
                            color: lightTeal,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Profile Strength: 88%',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'High response rate from recruiters',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context); // Close drawer
                              onTabSelected(4); // Switch to Profile tab
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              child: Text(
                                'View →',
                                style: TextStyle(
                                  color: lightTeal,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ---------------------------------------------------------------
              // MENU LIST ITEMS
              // ---------------------------------------------------------------
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  children: [
                    _sectionHeader('JOBS & ACTIVITIES'),
                    _drawerTile(
                      icon: Icons.home_rounded,
                      title: 'Home',
                      subtitle: 'Job recommendations & feed',
                      isSelected: currentTabIndex == 0,
                      onTap: () {
                        Navigator.pop(context);
                        onTabSelected(0);
                      },
                    ),
                    _drawerTile(
                      icon: Icons.explore_rounded,
                      title: 'Explore Jobs',
                      subtitle: 'Browse all categories & filters',
                      isSelected: currentTabIndex == 1,
                      onTap: () {
                        Navigator.pop(context);
                        onTabSelected(1);
                      },
                    ),
                    _drawerTile(
                      icon: Icons.bookmark_rounded,
                      title: 'Saved Jobs',
                      subtitle: 'Your bookmarked opportunities',
                      isSelected: currentTabIndex == 2,
                      onTap: () {
                        Navigator.pop(context);
                        onTabSelected(2);
                      },
                    ),
                    _drawerTile(
                      icon: Icons.work_history_rounded,
                      title: 'Applied Jobs',
                      subtitle: 'Track your job application status',
                      isSelected: currentTabIndex == 3,
                      badgeText: '3 Active',
                      onTap: () {
                        Navigator.pop(context);
                        onTabSelected(3);
                      },
                    ),
                    _drawerTile(
                      icon: Icons.assignment_turned_in_rounded,
                      title: 'Application Approvals',
                      subtitle: 'Review, approve & reject submitted forms',
                      badgeText: 'Recruiter',
                      badgeColor: Colors.amberAccent,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                          context,
                          AppRoutes.manageApplications,
                        );
                      },
                    ),

                    const Divider(
                      height: 24,
                      color: Colors.white24,
                      indent: 20,
                      endIndent: 20,
                    ),

                    _sectionHeader('CAREER & SERVICES'),
                    _drawerTile(
                      icon: Icons.manage_accounts_rounded,
                      title: 'Edit Profile & Skills',
                      subtitle: 'Update basic details & career bio',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                          context,
                          AppRoutes.editPersonalDetails,
                        );
                      },
                    ),
                    _drawerTile(
                      icon: Icons.description_rounded,
                      title: 'My Resume',
                      subtitle: 'Upload or view active resume',
                      onTap: () {
                        Navigator.pop(context);
                        _showResumeDialog(context);
                      },
                    ),

                    const Divider(
                      height: 24,
                      color: Colors.white24,
                      indent: 20,
                      endIndent: 20,
                    ),

                    _sectionHeader('HELP & PREFERENCES'),
                    _drawerTile(
                      icon: Icons.notifications_rounded,
                      title: 'Notifications',
                      subtitle: 'Job alerts & application updates',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, AppRoutes.notifications);
                      },
                    ),
                    _drawerTile(
                      icon: Icons.support_agent_rounded,
                      title: 'Help & Live Support 💬',
                      subtitle: 'Chat 24/7 with support team',
                      badgeText: 'Live',
                      badgeColor: Colors.greenAccent,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, AppRoutes.helpSupport);
                      },
                    ),

                    const Divider(
                      height: 24,
                      color: Colors.white24,
                      indent: 20,
                      endIndent: 20,
                    ),

                    _drawerTile(
                      icon: Icons.logout_rounded,
                      title: 'Log Out',
                      subtitle: 'Sign out of your account',
                      iconColor: Colors.redAccent,
                      titleColor: Colors.redAccent,
                      onTap: () {
                        Navigator.pop(context);
                        _confirmLogout(context);
                      },
                    ),
                  ],
                ),
              ),

              // Drawer Footer Branding
              Padding(
                padding: const EdgeInsets.only(bottom: 16, top: 8),
                child: Column(
                  children: [
                    const Text(
                      'JOB CAMPUS v1.0.2',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Bridge to Your Career',
                      style: TextStyle(
                        color: lightTeal.withValues(alpha: 0.8),
                        fontSize: 10,
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
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: lightTeal,
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _drawerTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isSelected = false,
    Color iconColor = lightTeal,
    Color titleColor = Colors.white,
    String? badgeText,
    Color badgeColor = teal,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
        color: isSelected
            ? teal.withValues(alpha: 0.25)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? teal.withValues(alpha: 0.6)
              : Colors.transparent,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        leading: Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: isSelected
                ? teal
                : Colors.white.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.white : iconColor,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 11,
          ),
        ),
        trailing: badgeText != null
            ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: badgeColor.withValues(alpha: 0.6),
                  ),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    color: badgeColor == Colors.greenAccent
                        ? Colors.greenAccent
                        : lightTeal,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              )
            : const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white38,
                size: 20,
              ),
      ),
    );
  }

  void _showResumeDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          icon: const Icon(
            Icons.description_outlined,
            color: teal,
            size: 44,
          ),
          title: const Text('My Resume'),
          content: const Text(
            'Upload, view, and update your CV/Resume to share with prospective employers.',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Log Out?'),
          content: const Text(
            'Are you sure you want to log out of Job Campus?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                await LocalStore.instance.logout();
                if (!context.mounted) return;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }
}
