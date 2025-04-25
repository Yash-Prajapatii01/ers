import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import 'nav_items.dart';

class FancyBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  FancyBottomBar({super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final List<NavItem> _items = [
    NavItem(icon: 'assets/icons/dashboard/schedule.png', label: 'Schedule'),
    NavItem(icon: 'assets/icons/dashboard/timesheet.png', label: 'Timesheet'),
    NavItem(icon: 'assets/icons/dashboard/setting.png', label: 'Settings'),
    NavItem(icon: 'assets/icons/dashboard/search.png', label: 'Search'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_items.length, (index) {
            final selected = index == currentIndex;
            final item = _items[index];
      
            return GestureDetector(
              onTap: () => onTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: selected
                    ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
                    : const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFF1C79D4) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: selected
                      ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ]
                      : [],
                ),
                child: Row(
                  children: [
                    Image.asset(
                      item.icon,
                      scale: 3.5,
                      color: selected ? Colors.white : const Color(0xFF1C79D4),
                    ),
                    if (selected) ...[
                      const SizedBox(width: 8),
                      Text(
                        item.label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.white,fontWeight: FontWeight.w500),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}