import 'package:flutter/material.dart';
import '../app_routes/app_routs.dart';
import '../core/app_theams.dart';
import '../home/models/job_model.dart';
import '../home/widgets/job_list_tile.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _savedJobTitles = {};

  final List<String> _categories = [
    'All',
    'Development',
    'Design',
    'Marketing',
    'Finance',
    'Internship',
  ];

  final List<JobModel> _allJobs = const [
    JobModel(
      title: 'Full Stack Engineer',
      company: 'CodeCraft Labs',
      location: 'Bengaluru (Hybrid)',
      salary: '₹8 - 12 LPA',
      type: 'Full Time',
      category: 'Development',
      logoText: 'CC',
      logoColor: 0xFF12345A,
      isFeatured: true,
    ),
    JobModel(
      title: 'UI/UX Product Designer',
      company: 'PixelPerfect Studio',
      location: 'Remote',
      salary: '₹6 - 9 LPA',
      type: 'Full Time',
      category: 'Design',
      logoText: 'PP',
      logoColor: 0xFF0CA997,
    ),
    JobModel(
      title: 'Data Analyst Intern',
      company: 'InfoMetrics Tech',
      location: 'Ranchi',
      salary: '₹20,000 / mo',
      type: 'Internship',
      category: 'Finance',
      logoText: 'IM',
      logoColor: 0xFF36B8B7,
    ),
    JobModel(
      title: 'Digital Marketing Lead',
      company: 'GrowthX Media',
      location: 'Delhi NCR',
      salary: '₹7 - 10 LPA',
      type: 'Full Time',
      category: 'Marketing',
      logoText: 'GX',
      logoColor: 0xFF0A858C,
    ),
    JobModel(
      title: 'Flutter App Developer',
      company: 'TechNova Solutions',
      location: 'Remote',
      salary: '₹6 - 10 LPA',
      type: 'Full Time',
      category: 'Development',
      logoText: 'TN',
      logoColor: 0xFF0B757B,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSave(JobModel job) {
    setState(() {
      if (_savedJobTitles.contains(job.title)) {
        _savedJobTitles.remove(job.title);
      } else {
        _savedJobTitles.add(job.title);
      }
    });
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
    final filteredJobs = _allJobs.where((job) {
      final matchesCategory = _selectedCategory == 'All' ||
          job.category.toLowerCase() == _selectedCategory.toLowerCase() ||
          job.type.toLowerCase() == _selectedCategory.toLowerCase();
      final query = _searchController.text.toLowerCase();
      final matchesSearch = query.isEmpty ||
          job.title.toLowerCase().contains(query) ||
          job.company.toLowerCase().contains(query) ||
          job.location.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeModeNotifier,
      builder: (context, mode, child) {
        final isDark = mode == ThemeMode.dark;

        final primaryText = isDark ? Colors.white : AppTheme.darkNavy;
        final iconColor = isDark ? Colors.white : AppTheme.darkNavy;

        final inputBg = isDark
            ? Colors.white.withValues(alpha: 0.15)
            : const Color(0xFFF1F5F9);
        final inputBorder = isDark
            ? Colors.white.withValues(alpha: 0.3)
            : const Color(0xFFCBD5E1);

        return SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 20, 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.menu_rounded, color: iconColor, size: 26),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Explore Jobs',
                        style: TextStyle(
                          color: primaryText,
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.notifications_none_rounded, color: iconColor),
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.notifications),
                    ),
                  ],
                ),
              ),

              // Search Input
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  style: TextStyle(color: primaryText),
                  decoration: InputDecoration(
                    hintText: 'Search title, company or location...',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: isDark ? AppTheme.lightIceTeal : AppTheme.darkTeal,
                    ),
                    filled: true,
                    fillColor: inputBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(color: inputBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(color: inputBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(
                        color:
                            isDark ? AppTheme.lightIceTeal : AppTheme.darkTeal,
                      ),
                    ),
                  ),
                ),
              ),

              // Filter Category Chips
              SizedBox(
                height: 50,
                child: ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _selectedCategory == category;

                    final chipBg = isDark
                        ? Colors.white.withValues(alpha: 0.15)
                        : const Color(0xFFF1F5F9);
                    final chipText = isSelected
                        ? Colors.white
                        : isDark
                            ? Colors.white70
                            : const Color(0xFF334155);

                    return ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        }
                      },
                      selectedColor: AppTheme.vibrantTeal,
                      backgroundColor: chipBg,
                      labelStyle: TextStyle(
                        color: chipText,
                        fontWeight:
                            isSelected ? FontWeight.w800 : FontWeight.w500,
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? (isDark
                                ? AppTheme.lightIceTeal
                                : AppTheme.darkTeal)
                            : (isDark
                                ? Colors.white24
                                : const Color(0xFFCBD5E1)),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              // Job List
              Expanded(
                child: filteredJobs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 50,
                              color: isDark ? Colors.white54 : Colors.black38,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No matching jobs found',
                              style: TextStyle(
                                color: primaryText,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        itemCount: filteredJobs.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final job = filteredJobs[index];
                          return JobListTile(
                            job: job,
                            isSaved: _savedJobTitles.contains(job.title),
                            onSave: () => _toggleSave(job),
                            onTap: () => _showJobDetails(job),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
