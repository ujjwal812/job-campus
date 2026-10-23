import 'package:flutter/material.dart';
import '../models/job_model.dart';

class FeaturedJobCard extends StatelessWidget {
  final JobModel job;
  final bool isSaved;
  final VoidCallback onSave;
  final VoidCallback onTap;

  const FeaturedJobCard({
    super.key,
    required this.job,
    required this.isSaved,
    required this.onSave,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const white = Colors.white;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, childWidget) {
        return Transform.scale(
          scale: 0.95 + (value * 0.05),
          child: Opacity(
            opacity: value,
            child: childWidget,
          ),
        );
      },
      child: Material(
        color: const Color(0xFF12345A),
        borderRadius: BorderRadius.circular(23),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Hero(
                      tag: 'featured_logo_${job.title}',
                      child: Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          job.logoText,
                          style: TextStyle(
                            color: Color(job.logoColor),
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
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
                            job.company,
                            style: const TextStyle(
                              color: white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'FEATURED OPPORTUNITY',
                            style: TextStyle(
                              color: Color(0xFF8DE4D8),
                              fontSize: 9,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: onSave,
                      icon: AnimatedScale(
                        scale: isSaved ? 1.2 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutBack,
                        child: Icon(
                          isSaved
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          color: white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  job.title,
                  style: const TextStyle(
                    color: white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _infoChip(Icons.location_on_outlined, job.location),
                    _infoChip(Icons.access_time_rounded, job.type),
                  ],
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        job.salary,
                        style: const TextStyle(
                          color: Color(0xFF8DE4D8),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 17,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0CA997),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'View job',
                            style: TextStyle(
                              color: white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: white,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 14),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
