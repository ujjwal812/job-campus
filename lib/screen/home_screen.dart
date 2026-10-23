import 'package:flutter/material.dart';

import '../app_routes/app_routs.dart';
import '../core/app_theams.dart';
import '../local_Store/local_store.dart';
import '../home/models/job_model.dart';
import '../home/widgets/home_header.dart';
import '../home/widgets/job_search_bar.dart';
import '../home/widgets/category_section.dart';
import '../home/widgets/featured_job_card.dart';
import '../home/widgets/job_list_tile.dart';

class JobCampusHomeScreen extends StatefulWidget {
  const JobCampusHomeScreen({super.key});

  @override
  State<JobCampusHomeScreen> createState() => _JobCampusHomeScreenState();
}

class _JobCampusHomeScreenState extends State<JobCampusHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String _selectedCategory = 'All Jobs';

  final Set<String> _savedJobs = {};

  final List<JobModel> _jobs = const [
    JobModel(
      title: 'Flutter Developer',
      company: 'TechNova Solutions',
      location: 'Ranchi, Jharkhand',
      salary: '₹3–6 LPA',
      type: 'Full-time',
      category: 'IT',
      logoText: 'TN',
      logoColor: 0xFFA5E6E2,
      isFeatured: true,
    ),
    JobModel(
      title: 'UI/UX Designer',
      company: 'Creative Studio',
      location: 'Remote',
      salary: '₹3–5 LPA',
      type: 'Full-time',
      category: 'Design',
      logoText: 'CS',
      logoColor: 0xFF77DAD7,
    ),
    JobModel(
      title: 'Digital Marketing Executive',
      company: 'Growth Partners',
      location: 'Ranchi, Jharkhand',
      salary: '₹2–4 LPA',
      type: 'Full-time',
      category: 'Marketing',
      logoText: 'GP',
      logoColor: 0xFF36B8B7,
    ),
    JobModel(
      title: 'Junior Software Developer',
      company: 'CodeCraft',
      location: 'Remote',
      salary: '₹3–5 LPA',
      type: 'Full-time',
      category: 'IT',
      logoText: 'CC',
      logoColor: 0xFFA5E6E2,
    ),
    JobModel(
      title: 'Sales Executive',
      company: 'BrightPath Services',
      location: 'Ranchi, Jharkhand',
      salary: '₹2–3.5 LPA',
      type: 'Full-time',
      category: 'Sales',
      logoText: 'BP',
      logoColor: 0xFF77DAD7,
    ),
  ];

  List<JobModel> get _filteredJobs {
    return _jobs.where((job) {
      final query = _searchQuery.toLowerCase().trim();

      final matchesSearch = query.isEmpty ||
          job.title.toLowerCase().contains(query) ||
          job.company.toLowerCase().contains(query) ||
          job.location.toLowerCase().contains(query) ||
          job.category.toLowerCase().contains(query);

      final matchesCategory = _selectedCategory == 'All Jobs' ||
          job.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  JobModel? get _featuredJob {
    for (final job in _filteredJobs) {
      if (job.isFeatured) return job;
    }
    return _filteredJobs.isNotEmpty ? _filteredJobs.first : null;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSaved(JobModel job) {
    setState(() {
      if (!_savedJobs.add(job.title)) {
        _savedJobs.remove(job.title);
      }
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            _savedJobs.contains(job.title)
                ? 'Job added to Saved Jobs'
                : 'Job removed from Saved Jobs',
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ),
      );
  }

  void _showJobDetails(JobModel job) {
    Navigator.pushNamed(
      context,
      AppRoutes.jobDetails,
      arguments: job,
    );
  }

  @override
  Widget build(BuildContext context) {
    final featured = _featuredJob;
    final recommended = _filteredJobs
        .where((job) => job.title != featured?.title)
        .toList();

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeModeNotifier,
      builder: (context, mode, child) {
        final isDark = mode == ThemeMode.dark;

        final primaryText = isDark ? Colors.white : AppTheme.darkNavy;
        final headlineAccent = isDark ? AppTheme.lightIceTeal : AppTheme.darkTeal;
        final subText = isDark ? Colors.white70 : const Color(0xFF475569);

        return SafeArea(
          bottom: false,
          child: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: HomeHeader(
                    userName: LocalStore.instance.getUserName() ?? 'Job Seeker',
                    onNotificationTap: () {
                      Navigator.pushNamed(context, AppRoutes.notifications);
                    },
                    onProfileTap: () {
                      Navigator.pushNamed(context, AppRoutes.profile);
                    },
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Find your',
                        style: TextStyle(
                          color: primaryText,
                          fontSize: 29,
                          fontWeight: FontWeight.w500,
                          height: 1.15,
                        ),
                      ),
                      Text(
                        'dream career.',
                        style: TextStyle(
                          color: headlineAccent,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        'Discover opportunities made for you.',
                        style: TextStyle(
                          color: subText,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 22),
                      JobSearchBar(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() => _searchQuery = value);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: _sectionHeading(
                    'Job Categories',
                    'Explore fields',
                    isDark,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 17, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: CategorySection(
                    selectedCategory: _selectedCategory,
                    onCategorySelected: (category) {
                      setState(() => _selectedCategory = category);
                    },
                  ),
                ),
              ),
              if (_selectedCategory == 'All Jobs' &&
                  _searchQuery.isEmpty &&
                  featured != null) ...[
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: _sectionHeading(
                      'Featured Opportunity',
                      'Top pick',
                      isDark,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: FeaturedJobCard(
                      job: featured,
                      isSaved: _savedJobs.contains(featured.title),
                      onSave: () => _toggleSaved(featured),
                      onTap: () => _showJobDetails(featured),
                    ),
                  ),
                ),
              ],
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 15),
                sliver: SliverToBoxAdapter(
                  child: _sectionHeading(
                    _searchQuery.isNotEmpty
                        ? 'Search Results'
                        : _selectedCategory == 'All Jobs'
                            ? 'Recommended Jobs'
                            : '$_selectedCategory Jobs',
                    '${_filteredJobs.length} found',
                    isDark,
                  ),
                ),
              ),
              if (recommended.isEmpty)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                  sliver: SliverToBoxAdapter(
                    child: _emptyState(isDark),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final job = recommended[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: JobListTile(
                            job: job,
                            isSaved: _savedJobs.contains(job.title),
                            onSave: () => _toggleSaved(job),
                            onTap: () => _showJobDetails(job),
                          ),
                        );
                      },
                      childCount: recommended.length,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionHeading(String title, String subtitle, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.white : AppTheme.darkNavy,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            color: isDark ? AppTheme.lightIceTeal : AppTheme.darkTeal,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _emptyState(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.15) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.28) : const Color(0xFFCBD5E1),
          width: 1.2,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.work_outline_rounded,
            size: 52,
            color: isDark ? Colors.white : AppTheme.darkNavy,
          ),
          const SizedBox(height: 14),
          Text(
            'No jobs found',
            style: TextStyle(
              color: isDark ? Colors.white : AppTheme.darkNavy,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try another keyword or select a different category.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white70 : const Color(0xFF475569),
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
