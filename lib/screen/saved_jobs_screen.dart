import 'package:flutter/material.dart';
import '../app_routes/app_routs.dart';
import '../core/app_theams.dart';
import '../home/models/job_model.dart';
import '../home/widgets/job_list_tile.dart';

class SavedJobsScreen extends StatefulWidget {
  const SavedJobsScreen({super.key});

  @override
  State<SavedJobsScreen> createState() => _SavedJobsScreenState();
}

class _SavedJobsScreenState extends State<SavedJobsScreen> {
  final List<JobModel> _savedJobs = [
    const JobModel(
      title: 'Senior Flutter Engineer',
      company: 'TechNova Solutions',
      location: 'Bengaluru / Remote',
      salary: '₹12 - 18 LPA',
      type: 'Full Time',
      category: 'Development',
      logoText: 'TN',
      logoColor: 0xFF0B757B,
    ),
    const JobModel(
      title: 'UI/UX Designer',
      company: 'Creative Studio',
      location: 'Hybrid, Delhi NCR',
      salary: '₹6 - 9 LPA',
      type: 'Full Time',
      category: 'Design',
      logoText: 'CS',
      logoColor: 0xFF36B8B7,
    ),
  ];

  void _removeJob(int index) {
    final removed = _savedJobs.removeAt(index);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${removed.title} removed from saved jobs.'),
        behavior: SnackBarBehavior.floating,
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
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeModeNotifier,
      builder: (context, mode, child) {
        final isDark = mode == ThemeMode.dark;
        final primaryText = isDark ? Colors.white : AppTheme.darkNavy;
        final subText = isDark ? Colors.white70 : const Color(0xFF475569);

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Text(
                  'Saved Jobs',
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              // Job List or Empty State
              Expanded(
                child: _savedJobs.isEmpty
                    ? Center(
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
                                  color: (isDark
                                          ? AppTheme.lightIceTeal
                                          : AppTheme.darkTeal)
                                      .withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.bookmark_border_rounded,
                                  size: 36,
                                  color: isDark
                                      ? AppTheme.lightIceTeal
                                      : AppTheme.darkTeal,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No Saved Jobs Yet',
                                style: TextStyle(
                                  color: primaryText,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Bookmark jobs while exploring to save them for later.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: subText,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        itemCount: _savedJobs.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final job = _savedJobs[index];
                          return Dismissible(
                            key: Key(job.title + job.company),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) => _removeJob(index),
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: Colors.redAccent.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Icon(Icons.delete_outline,
                                  color: Colors.white),
                            ),
                            child: JobListTile(
                              job: job,
                              isSaved: true,
                              onSave: () => _removeJob(index),
                              onTap: () => _showJobDetails(job),
                            ),
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
