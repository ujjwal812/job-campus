import 'package:flutter/material.dart';
import '../app_routes/app_routs.dart';
import '../core/app_theams.dart';
import '../home/models/job_model.dart';

class ViewDetailsScreen extends StatefulWidget {
  final JobModel? job;

  const ViewDetailsScreen({super.key, this.job});

  @override
  State<ViewDetailsScreen> createState() => _ViewDetailsScreenState();
}

class _ViewDetailsScreenState extends State<ViewDetailsScreen> {
  bool isSaved = false;
  late JobModel currentJob;

  static const JobModel _defaultJob = JobModel(
    title: 'Flutter Developer',
    company: 'Tech Solutions Pvt. Ltd.',
    location: 'Bengaluru, India',
    salary: '₹3–6 LPA',
    type: 'Full Time',
    category: 'Development',
    logoText: 'TS',
    logoColor: 0xFF0A858C,
    experience: '0–2 Years',
    posted: 'Recently',
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routeJob = ModalRoute.of(context)?.settings.arguments as JobModel?;
    currentJob = widget.job ?? routeJob ?? _defaultJob;
  }

  List<String> get _effectiveResponsibilities {
    if (currentJob.responsibilities.isNotEmpty) {
      return currentJob.responsibilities;
    }
    return [
      'Develop and maintain high-quality application features for ${currentJob.title}.',
      'Collaborate with team members at ${currentJob.company} to design scalable solutions.',
      'Identify, debug, and resolve performance bottlenecks and bugs.',
      'Write clean, reusable, and efficient code adhering to modern standards.',
    ];
  }

  List<String> get _effectiveRequirements {
    if (currentJob.requirements.isNotEmpty) {
      return currentJob.requirements;
    }
    return [
      'Bachelor degree or equivalent practical experience in ${currentJob.category}.',
      'Solid understanding of core concepts and best practices.',
      'Strong problem-solving ability and attention to detail.',
      'Good communication and team collaboration skills.',
    ];
  }

  List<String> get _effectiveSkills {
    if (currentJob.skills.isNotEmpty) {
      return currentJob.skills;
    }
    final cat = currentJob.category.toLowerCase();
    if (cat.contains('design')) {
      return ['Figma', 'UI/UX', 'Wireframing', 'Prototyping', 'User Research'];
    } else if (cat.contains('market')) {
      return ['SEO', 'Content Marketing', 'Analytics', 'Social Media', 'Ad Campaigns'];
    } else if (cat.contains('sales') || cat.contains('finance')) {
      return ['Communication', 'Negotiation', 'Financial Analysis', 'Excel', 'CRM'];
    }
    return ['Flutter', 'Dart', 'Firebase', 'Git', 'API Integration'];
  }

  String get _effectiveDescription {
    if (currentJob.description.isNotEmpty) {
      return currentJob.description;
    }
    return 'We are looking for a motivated ${currentJob.title} to join ${currentJob.company}. '
        'In this role, you will work closely with cross-functional teams in ${currentJob.location} '
        'to build high-impact products and deliver exceptional user experiences.';
  }

  String get _effectiveAboutCompany {
    if (currentJob.aboutCompany.isNotEmpty) {
      return currentJob.aboutCompany;
    }
    return '${currentJob.company} builds innovative digital products and solutions. '
        'The company focuses on technology excellence, growth, and fostering a collaborative culture.';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeModeNotifier,
      builder: (context, mode, child) {
        final isDark = mode == ThemeMode.dark;

        final primaryColor =
            isDark ? AppTheme.vibrantTeal : AppTheme.darkTeal;
        final titleColor = isDark ? Colors.white : AppTheme.darkNavy;
        final subTextColor =
            isDark ? Colors.white70 : const Color(0xFF475569);

        return Scaffold(
          appBar: _buildAppBar(isDark, titleColor, primaryColor),
          body: Container(
            decoration: AppTheme.screenBackgroundGradient(isDarkMode: isDark),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCompanyCard(isDark, titleColor, subTextColor, primaryColor),
                  const SizedBox(height: 20),
                  _buildJobOverview(isDark, titleColor, subTextColor, primaryColor),
                  const SizedBox(height: 24),
                  _buildSectionTitle('About the Job', titleColor),
                  const SizedBox(height: 10),
                  _buildDescription(subTextColor),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Job Responsibilities', titleColor),
                  const SizedBox(height: 10),
                  ..._effectiveResponsibilities
                      .map((item) => _buildBullet(item, subTextColor, primaryColor)),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Requirements', titleColor),
                  const SizedBox(height: 10),
                  ..._effectiveRequirements
                      .map((item) => _buildRequirement(item, subTextColor, primaryColor)),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Required Skills', titleColor),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _effectiveSkills
                        .map((s) => _buildSkill(s, isDark, primaryColor))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  _buildCompanyInfo(isDark, titleColor, subTextColor, primaryColor),
                  const SizedBox(height: 90),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomBar(isDark, primaryColor),
        );
      },
    );
  }

  // App Bar
  PreferredSizeWidget _buildAppBar(
    bool isDark,
    Color titleColor,
    Color primaryColor,
  ) {
    return AppBar(
      backgroundColor: isDark ? AppTheme.deepTeal : Colors.white,
      elevation: isDark ? 0 : 0.5,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: titleColor,
          size: 20,
        ),
      ),
      title: Text(
        'Job Details',
        style: TextStyle(
          color: titleColor,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              isSaved = !isSaved;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isSaved
                      ? 'Job added to saved jobs'
                      : 'Job removed from saved jobs',
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          icon: Icon(
            isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            color: isDark ? AppTheme.lightIceTeal : primaryColor,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // Company and Job Card
  Widget _buildCompanyCard(
    bool isDark,
    Color titleColor,
    Color subTextColor,
    Color primaryColor,
  ) {
    final logoBgColor = Color(currentJob.logoColor);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.glassDecoration(),
      child: Column(
        children: [
          Container(
            height: 68,
            width: 68,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: logoBgColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              currentJob.logoText,
              style: TextStyle(
                color: isDark ? Colors.white : logoBgColor,
                fontWeight: FontWeight.w900,
                fontSize: 22,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            currentJob.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: titleColor,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            currentJob.company,
            style: TextStyle(
              fontSize: 14,
              color: subTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTag(currentJob.type, isDark, subTextColor),
              _buildTag(currentJob.category, isDark, subTextColor),
              if (currentJob.isFeatured)
                _buildTag('Featured ⭐', isDark, subTextColor)
              else
                _buildTag('Fresher Friendly ✨', isDark, subTextColor),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: isDark ? Colors.white24 : const Color(0xFFE2E8F0)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 18,
                color: isDark ? AppTheme.lightIceTeal : primaryColor,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  currentJob.location,
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Job Overview
  Widget _buildJobOverview(
    bool isDark,
    Color titleColor,
    Color subTextColor,
    Color primaryColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.glassDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildOverviewItem(
                  Icons.currency_rupee,
                  'Salary',
                  currentJob.salary,
                  isDark,
                  titleColor,
                  subTextColor,
                  primaryColor,
                ),
              ),
              Container(
                height: 48,
                width: 1,
                color: isDark ? Colors.white24 : const Color(0xFFE2E8F0),
              ),
              Expanded(
                child: _buildOverviewItem(
                  Icons.work_outline,
                  'Experience',
                  currentJob.experience,
                  isDark,
                  titleColor,
                  subTextColor,
                  primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: isDark ? Colors.white24 : const Color(0xFFE2E8F0)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildOverviewItem(
                  Icons.access_time,
                  'Job Type',
                  currentJob.type,
                  isDark,
                  titleColor,
                  subTextColor,
                  primaryColor,
                ),
              ),
              Container(
                height: 48,
                width: 1,
                color: isDark ? Colors.white24 : const Color(0xFFE2E8F0),
              ),
              Expanded(
                child: _buildOverviewItem(
                  Icons.calendar_month_outlined,
                  'Posted',
                  currentJob.posted,
                  isDark,
                  titleColor,
                  subTextColor,
                  primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewItem(
    IconData icon,
    String title,
    String value,
    bool isDark,
    Color titleColor,
    Color subTextColor,
    Color primaryColor,
  ) {
    return Column(
      children: [
        Icon(icon, color: isDark ? AppTheme.lightIceTeal : primaryColor, size: 24),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            color: subTextColor,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: titleColor,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, Color titleColor) {
    return Text(
      title,
      style: TextStyle(
        color: titleColor,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _buildDescription(Color subTextColor) {
    return Text(
      _effectiveDescription,
      style: TextStyle(
        color: subTextColor,
        fontSize: 13,
        height: 1.7,
      ),
    );
  }

  Widget _buildBullet(String text, Color subTextColor, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: primaryColor,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: subTextColor,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirement(String text, Color subTextColor, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: primaryColor,
            size: 17,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: subTextColor,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkill(String skill, bool isDark, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.15)
            : const Color(0xFFEAF7F5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? Colors.white24 : AppTheme.lightIceTeal,
        ),
      ),
      child: Text(
        skill,
        style: TextStyle(
          color: isDark ? Colors.white : AppTheme.darkNavy,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildTag(String text, bool isDark, Color subTextColor) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.12)
            : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isDark ? Colors.white70 : subTextColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCompanyInfo(
    bool isDark,
    Color titleColor,
    Color subTextColor,
    Color primaryColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.glassDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('About Company', titleColor),
          const SizedBox(height: 10),
          Text(
            _effectiveAboutCompany,
            style: TextStyle(
              color: subTextColor,
              fontSize: 13,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(
                Icons.language_rounded,
                color: isDark ? AppTheme.lightIceTeal : primaryColor,
                size: 19,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  currentJob.industry,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(bool isDark, Color primaryColor) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.deepTeal : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
          border: Border(
            top: BorderSide(
              color: isDark ? Colors.white24 : const Color(0xFFE2E8F0),
            ),
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _applyForJob,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDark ? AppTheme.vibrantTeal : AppTheme.darkTeal,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Apply Now',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_rounded, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _applyForJob() {
    Navigator.pushNamed(
      context,
      AppRoutes.applyJob,
      arguments: currentJob,
    );
  }
}
