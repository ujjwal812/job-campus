import 'package:flutter/material.dart';

class JobSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const JobSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FA),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE9EEF4)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search_rounded,
            color: Color(0xFF0CA997),
            size: 27,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF12345A),
                fontWeight: FontWeight.w600,
              ),
              decoration: const InputDecoration(
                hintText: 'Job title, company or keyword',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: Colors.black45,
                ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
          const Icon(
            Icons.tune_rounded,
            color: Color(0xFF12345A),
          ),
        ],
      ),
    );
  }
}
