import 'package:flutter/material.dart';
import '../app_routes/app_routs.dart';
import '../core/app_theams.dart';
import '../home/models/job_model.dart';

class AppliedJobsScreen extends StatefulWidget {
  const AppliedJobsScreen({super.key});

  @override
  State<AppliedJobsScreen> createState() => _AppliedJobsScreenState();
}

class _AppliedJobsScreenState extends State<AppliedJobsScreen> {
  static const Color navy = Color(0xFF12345A);
  static const Color lightIceTeal = Color(0xFFA5E6E2);

  String _selectedStatusFilter = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _statusFilters = [
    'All',
    'Shortlisted',
    'Under Review',
    'Interview',
  ];

  final List<Map<String, dynamic>> _applications = [
    {
      'id': 'app_01',
      'title': 'Flutter App Developer',
      'company': 'TechNova Solutions',
      'location': 'Remote',
      'salary': '₹6–10 LPA',
      'appliedDate': 'Applied 2 days ago',
      'status': 'Shortlisted',
      'statusStep': 2,
      'statusColor': const Color(0xFF36B8B7),
      'icon': Icons.check_circle_rounded,
      'logoText': 'TN',
      'logoColor': 0xFF0A858C,
      'type': 'Full Time',
    },
    {
      'id': 'app_02',
      'title': 'Frontend Developer Intern',
      'company': 'CodeCraft Labs',
      'location': 'Bengaluru (Hybrid)',
      'salary': '₹25,000 / mo',
      'appliedDate': 'Applied 1 week ago',
      'status': 'Under Review',
      'statusStep': 1,
      'statusColor': const Color(0xFFFFB300),
      'icon': Icons.access_time_filled_rounded,
      'logoText': 'CC',
      'logoColor': 0xFF2B78E4,
      'type': 'Internship',
    },
    {
      'id': 'app_03',
      'title': 'Associate Software Engineer',
      'company': 'Wipro Technologies',
      'location': 'Ranchi, Jharkhand',
      'salary': '₹3.5–5 LPA',
      'appliedDate': 'Applied 2 weeks ago',
      'status': 'Interview',
      'statusStep': 3,
      'statusColor': const Color(0xFF00E676),
      'icon': Icons.video_camera_front_rounded,
      'logoText': 'WT',
      'logoColor': 0xFF8E24AA,
      'type': 'Full Time',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredApplications {
    return _applications.where((app) {
      final matchesStatus = _selectedStatusFilter == 'All' ||
          (app['status'] as String).toLowerCase() ==
              _selectedStatusFilter.toLowerCase();
      final query = _searchQuery.toLowerCase().trim();
      final matchesSearch = query.isEmpty ||
          (app['title'] as String).toLowerCase().contains(query) ||
          (app['company'] as String).toLowerCase().contains(query) ||
          (app['location'] as String).toLowerCase().contains(query);
      return matchesStatus && matchesSearch;
    }).toList();
  }

  void _openJobDetails(Map<String, dynamic> app) {
    final companyName = app['company'] as String;
    final job = JobModel(
      title: app['title'] as String,
      company: companyName,
      location: app['location'] as String? ?? 'On-site / Remote',
      salary: app['salary'] as String? ?? '₹4–8 LPA',
      type: app['type'] as String? ?? 'Full Time',
      category: 'Development',
      logoText: app['logoText'] as String? ?? 'TC',
      logoColor: app['logoColor'] as int? ?? 0xFF0A858C,
      posted: app['appliedDate'] as String,
      description:
          'You submitted your application for ${app['title']} at $companyName. '
          'Current application status: ${app['status']}.',
    );

    Navigator.pushNamed(
      context,
      AppRoutes.jobDetails,
      arguments: job,
    );
  }

  void _withdrawApplication(Map<String, dynamic> app) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Withdraw Application?',
            style: TextStyle(color: navy, fontWeight: FontWeight.w800),
          ),
          content: Text(
            'Are you sure you want to withdraw your application for ${app['title']} at ${app['company']}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _applications.removeWhere((item) => item['id'] == app['id']);
                });
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Application for ${app['title']} withdrawn.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Withdraw'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredApplications;

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeModeNotifier,
      builder: (context, mode, child) {
        final isDark = mode == ThemeMode.dark;

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isDark),
              _buildStatsOverview(isDark),
              _buildSearchBar(isDark),
              _buildFilterChips(isDark),
              const SizedBox(height: 10),

              Expanded(
                child: filtered.isEmpty
                    ? _buildEmptyState(isDark)
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final app = filtered[index];
                          return _buildApplicationCard(app, isDark);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  // HEADER
  Widget _buildHeader(bool isDark) {
    final primaryText = isDark ? Colors.white : AppTheme.darkNavy;
    final iconColor = isDark ? Colors.white : AppTheme.darkNavy;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 20, 10),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.menu_rounded, color: iconColor, size: 26),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Applied Jobs',
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'Track your real-time application progress',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : const Color(0xFF475569),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.manageApplications);
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDark
                    ? AppTheme.vibrantTeal.withValues(alpha: 0.35)
                    : AppTheme.darkTeal,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppTheme.lightIceTeal : AppTheme.darkTeal,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.approval_rounded, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'Approvals',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // METRICS STATS
  Widget _buildStatsOverview(bool isDark) {
    final total = _applications.length;
    final shortlisted = _applications
        .where((a) => a['status'] == 'Shortlisted')
        .length;
    final interviews = _applications
        .where((a) => a['status'] == 'Interview')
        .length;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          _statCard('Total Applied', '$total', Icons.assignment_turned_in_rounded,
              const Color(0xFF2196F3), isDark),
          const SizedBox(width: 10),
          _statCard('Shortlisted', '$shortlisted', Icons.star_rounded,
              const Color(0xFF00E676), isDark),
          const SizedBox(width: 10),
          _statCard('Interviews', '$interviews', Icons.video_camera_front_rounded,
              const Color(0xFFFFB300), isDark),
        ],
      ),
    );
  }

  Widget _statCard(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.15)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.25)
              : const Color(0xFFE2E8F0),
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: isDark ? Colors.white : AppTheme.darkNavy,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: isDark ? Colors.white70 : const Color(0xFF64748B),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // SEARCH BAR
  Widget _buildSearchBar(bool isDark) {
    final inputBg = isDark
        ? Colors.white.withValues(alpha: 0.18)
        : const Color(0xFFF1F5F9);
    final inputBorder = isDark
        ? Colors.white.withValues(alpha: 0.28)
        : const Color(0xFFCBD5E1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: inputBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: inputBorder),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              color: isDark ? lightIceTeal : AppTheme.darkTeal,
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() => _searchQuery = val);
                },
                style: TextStyle(
                  color: isDark ? Colors.white : AppTheme.darkNavy,
                  fontSize: 13,
                ),
                decoration: InputDecoration(
                  hintText: 'Search applied job or company...',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white54 : Colors.black45,
                    fontSize: 12,
                  ),
                  border: InputBorder.none,
                  isCollapsed: true,
                ),
              ),
            ),
            if (_searchQuery.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
                child: Icon(
                  Icons.clear_rounded,
                  color: isDark ? Colors.white70 : Colors.black54,
                  size: 18,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // FILTER CHIPS
  Widget _buildFilterChips(bool isDark) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        scrollDirection: Axis.horizontal,
        itemCount: _statusFilters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _statusFilters[index];
          final isSelected = _selectedStatusFilter == filter;

          final chipBg = isDark
              ? Colors.white.withValues(alpha: 0.15)
              : const Color(0xFFF1F5F9);
          final chipText = isSelected
              ? Colors.white
              : isDark
                  ? Colors.white70
                  : const Color(0xFF334155);

          return ChoiceChip(
            label: Text(filter),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                setState(() {
                  _selectedStatusFilter = filter;
                });
              }
            },
            selectedColor: AppTheme.vibrantTeal,
            backgroundColor: chipBg,
            labelStyle: TextStyle(
              color: chipText,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
              fontSize: 12,
            ),
            side: BorderSide(
              color: isSelected
                  ? (isDark ? lightIceTeal : AppTheme.darkTeal)
                  : (isDark ? Colors.white24 : const Color(0xFFCBD5E1)),
            ),
          );
        },
      ),
    );
  }

  // APPLICATION CARD
  Widget _buildApplicationCard(Map<String, dynamic> app, bool isDark) {
    final statusColor = app['statusColor'] as Color;
    final currentStep = app['statusStep'] as int;
    final logoBg = Color(app['logoColor'] as int);

    final titleText = isDark ? Colors.white : AppTheme.darkNavy;
    final subText = isDark ? lightIceTeal : AppTheme.darkTeal;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.glassDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: logoBg.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: logoBg.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  app['logoText'] as String,
                  style: TextStyle(
                    color: isDark ? Colors.white : logoBg,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app['title'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: titleText,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      app['company'] as String,
                      style: TextStyle(
                        color: subText,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                onSelected: (val) {
                  if (val == 'details') {
                    _openJobDetails(app);
                  } else if (val == 'withdraw') {
                    _withdrawApplication(app);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'details',
                    child: Text('View Details'),
                  ),
                  const PopupMenuItem(
                    value: 'withdraw',
                    child: Text(
                      'Withdraw Application',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              _infoBadge(
                Icons.location_on_rounded,
                app['location'] as String,
                isDark,
              ),
              const SizedBox(width: 8),
              _infoBadge(
                Icons.payments_rounded,
                app['salary'] as String,
                isDark,
              ),
            ],
          ),

          const SizedBox(height: 16),
          Divider(
            height: 1,
            color: isDark ? Colors.white24 : const Color(0xFFE2E8F0),
          ),
          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.6),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      app['icon'] as IconData,
                      size: 14,
                      color: statusColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      app['status'] as String,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                app['appliedDate'] as String,
                style: TextStyle(
                  color: isDark ? Colors.white54 : const Color(0xFF64748B),
                  fontSize: 11,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          _buildProgressTracker(currentStep, isDark),
          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            height: 42,
            child: OutlinedButton.icon(
              onPressed: () => _openJobDetails(app),
              icon: const Icon(Icons.visibility_rounded, size: 16),
              label: const Text('View Application Details'),
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? Colors.white : AppTheme.darkNavy,
                side: BorderSide(
                  color: isDark ? Colors.white38 : AppTheme.darkNavy,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBadge(IconData icon, String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.12)
            : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isDark ? lightIceTeal : AppTheme.darkTeal,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: isDark ? Colors.white70 : AppTheme.darkNavy,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTracker(int step, bool isDark) {
    final steps = ['Applied', 'In Review', 'Shortlisted', 'Interview'];

    return Column(
      children: [
        Row(
          children: List.generate(steps.length, (index) {
            final isCompleted = index <= step;

            return Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 9,
                    backgroundColor: isCompleted
                        ? AppTheme.vibrantTeal
                        : (isDark ? Colors.white24 : const Color(0xFFCBD5E1)),
                    child: Icon(
                      Icons.check,
                      size: 11,
                      color: isCompleted ? Colors.white : Colors.transparent,
                    ),
                  ),
                  if (index < steps.length - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: index < step
                            ? AppTheme.vibrantTeal
                            : (isDark
                                ? Colors.white24
                                : const Color(0xFFCBD5E1)),
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(steps.length, (index) {
            final isCurrent = index == step;
            return Text(
              steps[index],
              style: TextStyle(
                color: isCurrent
                    ? (isDark ? lightIceTeal : AppTheme.darkTeal)
                    : (isDark ? Colors.white54 : const Color(0xFF64748B)),
                fontSize: 10,
                fontWeight: isCurrent ? FontWeight.w800 : FontWeight.normal,
              ),
            );
          }),
        ),
      ],
    );
  }

  // EMPTY STATE
  Widget _buildEmptyState(bool isDark) {
    final primaryText = isDark ? Colors.white : AppTheme.darkNavy;
    final subText = isDark ? Colors.white70 : const Color(0xFF475569);

    return Center(
      child: Container(
        margin: const EdgeInsets.all(28),
        padding: const EdgeInsets.all(28),
        decoration: AppTheme.glassDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: (isDark ? lightIceTeal : AppTheme.darkTeal)
                    .withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.work_outline_rounded,
                size: 36,
                color: isDark ? lightIceTeal : AppTheme.darkTeal,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No Applications Found',
              style: TextStyle(
                color: primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No job applications matching your current filter. Browse jobs and start applying!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: subText,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
