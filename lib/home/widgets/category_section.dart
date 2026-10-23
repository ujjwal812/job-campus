import 'package:flutter/material.dart';
import '../../core/app_theams.dart';

class JobCategory {
  final String title;
  final IconData icon;
  final Color color;

  const JobCategory(this.title, this.icon, this.color);
}

class CategorySection extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategorySection({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  static const categories = [
    JobCategory('All Jobs', Icons.grid_view_rounded, Color(0xFF0CA997)),
    JobCategory('IT', Icons.code_rounded, Color(0xFF4778D5)),
    JobCategory('Design', Icons.palette_outlined, Color(0xFF9B69D8)),
    JobCategory('Marketing', Icons.campaign_outlined, Color(0xFFE69A38)),
    JobCategory('Sales', Icons.trending_up_rounded, Color(0xFFE26F80)),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeModeNotifier,
      builder: (context, mode, child) {
        final isDark = mode == ThemeMode.dark;

        return SizedBox(
          height: 98,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final category = categories[index];
              final selected = selectedCategory == category.title;

              Color unselectedBg;
              Color unselectedIcon;
              Color unselectedText;

              if (isDark) {
                unselectedBg = Colors.white.withValues(alpha: 0.18);
                unselectedIcon = Colors.white;
                unselectedText = Colors.white.withValues(alpha: 0.85);
              } else {
                unselectedBg = const Color(0xFFE2E8F0);
                unselectedIcon = category.color;
                unselectedText = AppTheme.darkNavy;
              }

              return GestureDetector(
                onTap: () => onCategorySelected(category.title),
                child: SizedBox(
                  width: 72,
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: selected ? category.color : unselectedBg,
                          borderRadius: BorderRadius.circular(19),
                          border: Border.all(
                            color: selected
                                ? Colors.white
                                : isDark
                                    ? Colors.white.withValues(alpha: 0.28)
                                    : const Color(0xFFCBD5E1),
                            width: selected ? 1.8 : 1.0,
                          ),
                          boxShadow: selected
                              ? [
                                  BoxShadow(
                                    color: category.color.withValues(alpha: 0.4),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: Icon(
                          category.icon,
                          color: selected ? Colors.white : unselectedIcon,
                          size: 27,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              selected ? FontWeight.w900 : FontWeight.w600,
                          color: selected ? category.color : unselectedText,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
