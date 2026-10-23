import 'package:flutter/material.dart';
import '../../core/app_theams.dart';
import '../models/job_model.dart';

class JobListTile extends StatelessWidget {
  final JobModel job;
  final bool isSaved;
  final VoidCallback? onSave;
  final VoidCallback? onTap;

  const JobListTile({
    super.key,
    required this.job,
    this.isSaved = false,
    this.onSave,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeModeNotifier,
      builder: (context, mode, child) {
        final isDark = mode == ThemeMode.dark;

        final titleColor = isDark ? Colors.white : AppTheme.darkNavy;
        final subTextColor =
            isDark ? Colors.white70 : const Color(0xFF475569);
        final accentColor =
            isDark ? AppTheme.lightIceTeal : AppTheme.darkTeal;

        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          tween: Tween<double>(begin: 0.0, end: 1.0),
          builder: (context, value, childWidget) {
            return Transform.translate(
              offset: Offset(0, 12 * (1.0 - value)),
              child: Opacity(
                opacity: value,
                child: childWidget,
              ),
            );
          },
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.glassDecoration(),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: 'job_logo_${job.title}_${job.company}',
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: 48,
                            height: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color(job.logoColor)
                                  .withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Color(job.logoColor)
                                    .withValues(alpha: 0.35),
                              ),
                            ),
                            child: Text(
                              job.logoText,
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white
                                    : Color(job.logoColor),
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
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
                                job.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: titleColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                job.company,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: subTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: onSave,
                          visualDensity: VisualDensity.compact,
                          icon: AnimatedScale(
                            scale: isSaved ? 1.15 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOutBack,
                            child: Icon(
                              isSaved
                                  ? Icons.bookmark_rounded
                                  : Icons.bookmark_border_rounded,
                              color: isSaved
                                  ? AppTheme.vibrantTeal
                                  : (isDark ? Colors.white54 : Colors.black45),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 15,
                          color: accentColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            job.location,
                            style: TextStyle(
                              fontSize: 11,
                              color: subTextColor,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.12)
                                : const Color(0xFFE9F8F5),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Text(
                            job.type,
                            style: TextStyle(
                              color: isDark
                                  ? AppTheme.lightIceTeal
                                  : AppTheme.darkTeal,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Divider(
                      height: 1,
                      color: isDark ? Colors.white24 : const Color(0xFFEAF0F5),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.payments_outlined,
                          color: accentColor,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            job.salary,
                            style: TextStyle(
                              color: titleColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Text(
                          'View details',
                          style: TextStyle(
                            color: accentColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: accentColor,
                          size: 15,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
