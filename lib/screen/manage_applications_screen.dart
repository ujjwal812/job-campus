import 'package:flutter/material.dart';
import '../core/app_theams.dart';

class ApplicationItem {
  final String id;
  final String candidateName;
  final String email;
  final String phone;
  final String location;
  final String jobTitle;
  final String company;
  final String experience;
  final String expectedSalary;
  final String noticePeriod;
  final String resumeFileName;
  final String portfolioUrl;
  final String coverLetter;
  final String appliedDate;
  String status; // 'Pending', 'Approved', 'Rejected'
  String? recruiterRemark;

  ApplicationItem({
    required this.id,
    required this.candidateName,
    required this.email,
    required this.phone,
    required this.location,
    required this.jobTitle,
    required this.company,
    required this.experience,
    required this.expectedSalary,
    required this.noticePeriod,
    required this.resumeFileName,
    required this.portfolioUrl,
    required this.coverLetter,
    required this.appliedDate,
    this.status = 'Pending',
    this.recruiterRemark,
  });
}

class ManageApplicationsScreen extends StatefulWidget {
  const ManageApplicationsScreen({super.key});

  @override
  State<ManageApplicationsScreen> createState() =>
      _ManageApplicationsScreenState();
}

class _ManageApplicationsScreenState extends State<ManageApplicationsScreen> {
  static const Color navy = Color(0xFF12345A);
  static const Color teal = AppTheme.vibrantTeal;
  static const Color lightIceTeal = AppTheme.lightIceTeal;

  String _selectedFilter = 'All'; // 'All', 'Pending', 'Approved', 'Rejected'
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filterOptions = [
    'All',
    'Pending',
    'Approved',
    'Rejected',
  ];

  final List<ApplicationItem> _applications = [
    ApplicationItem(
      id: 'APP-101',
      candidateName: 'Rahul Sharma',
      email: 'rahul.sharma@example.com',
      phone: '+91 98765 43210',
      location: 'Ranchi, Jharkhand',
      jobTitle: 'Flutter App Developer',
      company: 'TechNova Solutions',
      experience: '2.5 Years',
      expectedSalary: '₹6 LPA',
      noticePeriod: 'Immediate (15 Days)',
      resumeFileName: 'Rahul_Flutter_Dev_Resume.pdf',
      portfolioUrl: 'https://github.com/rahul-flutter-dev',
      coverLetter:
          'I have 2.5 years of expertise in building cross-platform apps using Flutter, Provider, and Firebase. I am excited to contribute to TechNova.',
      appliedDate: '10 Feb 2025',
      status: 'Pending',
    ),
    ApplicationItem(
      id: 'APP-102',
      candidateName: 'Ananya Verma',
      email: 'ananya.verma@example.com',
      phone: '+91 91234 56789',
      location: 'Bengaluru, Karnataka',
      jobTitle: 'UI/UX Product Designer',
      company: 'CodeCraft Labs',
      experience: '3 Years',
      expectedSalary: '₹8.5 LPA',
      noticePeriod: '1 Month',
      resumeFileName: 'Ananya_UIUX_Portfolio.pdf',
      portfolioUrl: 'https://behance.net/ananya-designs',
      coverLetter:
          'Specialized in mobile app user experience, high-fidelity Figma design systems, and wireframing for enterprise applications.',
      appliedDate: '08 Feb 2025',
      status: 'Approved',
      recruiterRemark: 'Selected for Technical Interview Round 1',
    ),
    ApplicationItem(
      id: 'APP-103',
      candidateName: 'Vikram Singh',
      email: 'vikram.singh@example.com',
      phone: '+91 99887 76655',
      location: 'Hyderabad, Telangana',
      jobTitle: 'Backend Engineer (Node.js)',
      company: 'Wipro Technologies',
      experience: 'Fresher (0-1 Year)',
      expectedSalary: '₹4.2 LPA',
      noticePeriod: 'Immediate',
      resumeFileName: 'Vikram_Backend_Resume.pdf',
      portfolioUrl: 'https://github.com/vikram-backend',
      coverLetter:
          'Computer Science graduate with strong hands-on knowledge of REST APIs, Node.js, Express, PostgreSQL, and Docker containerization.',
      appliedDate: '05 Feb 2025',
      status: 'Rejected',
      recruiterRemark: 'Position requires 2+ years of production experience',
    ),
    ApplicationItem(
      id: 'APP-104',
      candidateName: 'Priya Kumari',
      email: 'priya.k@example.com',
      phone: '+91 87654 32109',
      location: 'Jamshedpur, Jharkhand',
      jobTitle: 'Frontend Developer Intern',
      company: 'CodeCraft Labs',
      experience: 'Fresher',
      expectedSalary: '₹25,000 / month',
      noticePeriod: 'Immediate',
      resumeFileName: 'Priya_Frontend_Intern.pdf',
      portfolioUrl: 'https://github.com/priya-web',
      coverLetter:
          'Passionate about React.js, HTML5, CSS3, and modern web design. Eager to gain industry exposure as a frontend intern.',
      appliedDate: '12 Feb 2025',
      status: 'Pending',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ApplicationItem> get _filteredApplications {
    return _applications.where((app) {
      final matchesFilter = _selectedFilter == 'All' ||
          app.status.toLowerCase() == _selectedFilter.toLowerCase();

      final q = _searchQuery.toLowerCase().trim();
      final matchesSearch = q.isEmpty ||
          app.candidateName.toLowerCase().contains(q) ||
          app.jobTitle.toLowerCase().contains(q) ||
          app.company.toLowerCase().contains(q) ||
          app.email.toLowerCase().contains(q);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  void _approveApplication(ApplicationItem app) {
    final remarkController = TextEditingController(
      text: 'Application shortlisted for further rounds.',
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Row(
            children: const [
              Icon(Icons.check_circle_rounded, color: Colors.green, size: 28),
              SizedBox(width: 10),
              Text(
                'Approve Application',
                style: TextStyle(
                  color: navy,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to APPROVE candidate "${app.candidateName}" for the "${app.jobTitle}" position?',
                style: const TextStyle(color: Colors.black87, fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 16),
              const Text(
                'Approval Note / Recruiter Remark (Optional):',
                style: TextStyle(
                  color: navy,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: remarkController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'e.g., Shortlisted for interview',
                  filled: true,
                  fillColor: const Color(0xFFF4F8FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  app.status = 'Approved';
                  app.recruiterRemark = remarkController.text.trim();
                });
                Navigator.pop(dialogContext);
                _showToast(
                  'Application Approved! Candidate ${app.candidateName} notified.',
                  Colors.green.shade700,
                );
              },
              icon: const Icon(Icons.check_rounded, size: 18),
              label: const Text('Confirm Approval'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _rejectApplication(ApplicationItem app) {
    final remarkController = TextEditingController(
      text: 'Profile does not match current vacancy requirements.',
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Row(
            children: const [
              Icon(Icons.cancel_rounded, color: Colors.redAccent, size: 28),
              SizedBox(width: 10),
              Text(
                'Reject Application',
                style: TextStyle(
                  color: navy,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to REJECT the application of "${app.candidateName}" for "${app.jobTitle}"?',
                style: const TextStyle(color: Colors.black87, fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 16),
              const Text(
                'Rejection Reason / Feedback for Applicant:',
                style: TextStyle(
                  color: navy,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: remarkController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Provide reason for rejection...',
                  filled: true,
                  fillColor: const Color(0xFFFFF5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  app.status = 'Rejected';
                  app.recruiterRemark = remarkController.text.trim();
                });
                Navigator.pop(dialogContext);
                _showToast(
                  'Application Rejected for ${app.candidateName}.',
                  Colors.redAccent,
                );
              },
              icon: const Icon(Icons.close_rounded, size: 18),
              label: const Text('Reject Application'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _viewFullDetailsModal(ApplicationItem app) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(modalContext).size.height * 0.88,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              // Top drag indicator
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: teal.withValues(alpha: 0.15),
                            child: Text(
                              app.candidateName.isNotEmpty
                                  ? app.candidateName[0].toUpperCase()
                                  : 'C',
                              style: const TextStyle(
                                color: teal,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  app.candidateName,
                                  style: const TextStyle(
                                    color: navy,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Applied for ${app.jobTitle} at ${app.company}',
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildStatusBadge(app.status),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 12),

                      const Text(
                        'Applicant Form Information',
                        style: TextStyle(
                          color: navy,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _detailTile(Icons.email_rounded, 'Email Address', app.email),
                      _detailTile(Icons.phone_rounded, 'Phone Number', app.phone),
                      _detailTile(
                          Icons.location_on_rounded, 'Location', app.location),
                      _detailTile(Icons.badge_rounded, 'Experience', app.experience),
                      _detailTile(
                          Icons.payments_rounded, 'Expected CTC', app.expectedSalary),
                      _detailTile(
                          Icons.access_time_rounded, 'Notice Period', app.noticePeriod),
                      _detailTile(
                          Icons.picture_as_pdf_rounded, 'Resume CV', app.resumeFileName),
                      if (app.portfolioUrl.isNotEmpty)
                        _detailTile(Icons.link_rounded, 'Portfolio / GitHub',
                            app.portfolioUrl),

                      const SizedBox(height: 16),
                      const Text(
                        'Cover Letter / Application Note:',
                        style: TextStyle(
                          color: navy,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F8FA),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Text(
                          app.coverLetter,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ),

                      if (app.recruiterRemark != null &&
                          app.recruiterRemark!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Recruiter Remark / Note:',
                          style: TextStyle(
                            color: navy,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: app.status == 'Approved'
                                ? Colors.green.shade50
                                : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: app.status == 'Approved'
                                  ? Colors.green.shade200
                                  : Colors.red.shade200,
                            ),
                          ),
                          child: Text(
                            app.recruiterRemark!,
                            style: TextStyle(
                              color: app.status == 'Approved'
                                  ? Colors.green.shade900
                                  : Colors.red.shade900,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),

                      // Approve / Reject Modal Actions
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pop(modalContext);
                                _rejectApplication(app);
                              },
                              icon: const Icon(Icons.close_rounded,
                                  color: Colors.redAccent),
                              label: const Text('Reject'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.redAccent,
                                side: const BorderSide(color: Colors.redAccent),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(modalContext);
                                _approveApplication(app);
                              },
                              icon: const Icon(Icons.check_circle_rounded,
                                  color: Colors.white),
                              label: const Text('Approve'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade600,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: teal),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black45,
                    fontSize: 11,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showToast(String message, Color bgColor) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredApplications;
    final totalCount = _applications.length;
    final pendingCount =
        _applications.where((a) => a.status == 'Pending').length;
    final approvedCount =
        _applications.where((a) => a.status == 'Approved').length;
    final rejectedCount =
        _applications.where((a) => a.status == 'Rejected').length;

    return Scaffold(
      backgroundColor: const Color(0xFF0B757B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Application Approvals',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Container(
        decoration: AppTheme.screenBackgroundGradient(),
        child: SafeArea(
          child: Column(
            children: [
              // Metrics Summary Row
              _buildMetricsHeader(
                totalCount,
                pendingCount,
                approvedCount,
                rejectedCount,
              ),

              // Search Bar
              _buildSearchBar(),

              // Filter Chips
              _buildFilterChips(),

              const SizedBox(height: 10),

              // Application Items List
              Expanded(
                child: filtered.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final app = filtered[index];
                          return _buildApplicationCard(app);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsHeader(
    int total,
    int pending,
    int approved,
    int rejected,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: _metricCard('Total', '$total', Colors.blue.shade300),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _metricCard('Pending', '$pending', Colors.amber.shade300),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _metricCard('Approved', '$approved', Colors.greenAccent),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _metricCard('Rejected', '$rejected', Colors.redAccent.shade100),
          ),
        ],
      ),
    );
  }

  Widget _metricCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded, color: lightIceTeal, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() => _searchQuery = val);
                },
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'Search applicant, role, or email...',
                  hintStyle: TextStyle(color: Colors.white54, fontSize: 12),
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
                child: const Icon(Icons.clear_rounded,
                    color: Colors.white70, size: 18),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        scrollDirection: Axis.horizontal,
        itemCount: _filterOptions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filterOptions[index];
          final isSelected = _selectedFilter == filter;

          return ChoiceChip(
            label: Text(filter),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                setState(() => _selectedFilter = filter);
              }
            },
            selectedColor: AppTheme.vibrantTeal,
            backgroundColor: Colors.white.withValues(alpha: 0.15),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
              fontSize: 12,
            ),
            side: BorderSide(
              color: isSelected ? lightIceTeal : Colors.white24,
            ),
          );
        },
      ),
    );
  }

  Widget _buildApplicationCard(ApplicationItem app) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.glassDecoration(
        opacity: 0.18,
        borderOpacity: 0.28,
        radius: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: Text(
                  app.candidateName.isNotEmpty
                      ? app.candidateName[0].toUpperCase()
                      : 'C',
                  style: const TextStyle(
                    color: Colors.white,
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
                      app.candidateName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${app.jobTitle} • ${app.company}',
                      style: const TextStyle(
                        color: lightIceTeal,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(app.status),
            ],
          ),

          const SizedBox(height: 12),

          // Details grid preview
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoText(Icons.location_on_outlined, app.location),
                    _infoText(Icons.badge_outlined, app.experience),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoText(Icons.payments_outlined, app.expectedSalary),
                    _infoText(Icons.calendar_today_rounded, app.appliedDate),
                  ],
                ),
              ],
            ),
          ),

          if (app.recruiterRemark != null &&
              app.recruiterRemark!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.note_alt_rounded,
                    color: lightIceTeal, size: 14),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Remark: ${app.recruiterRemark}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 14),

          // Action Buttons: Approve, Reject, View Details
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _viewFullDetailsModal(app),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white38),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'View Form',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _rejectApplication(app),
                icon: const Icon(Icons.close_rounded, size: 15),
                label: const Text('Reject', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.withValues(alpha: 0.85),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _approveApplication(app),
                icon: const Icon(Icons.check_rounded, size: 15),
                label: const Text('Approve', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoText(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: lightIceTeal, size: 13),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color border;
    IconData icon;

    switch (status) {
      case 'Approved':
        bg = Colors.green.shade600.withValues(alpha: 0.25);
        border = Colors.greenAccent;
        icon = Icons.check_circle_rounded;
        break;
      case 'Rejected':
        bg = Colors.redAccent.withValues(alpha: 0.25);
        border = Colors.redAccent;
        icon = Icons.cancel_rounded;
        break;
      case 'Pending':
      default:
        bg = Colors.amber.withValues(alpha: 0.25);
        border = Colors.amber;
        icon = Icons.access_time_filled_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: border),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: border,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(28),
        padding: const EdgeInsets.all(28),
        decoration: AppTheme.glassDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: lightIceTeal.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment_late_rounded,
                size: 32,
                color: lightIceTeal,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'No Applications Found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'No candidate forms match your active search or selected filter tab.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
