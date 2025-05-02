import 'package:flutter/material.dart';

class CalendarGrid extends StatelessWidget {
  final int month, year;
  final DateTime selected;
  final ValueChanged<int> onDaySelected;

  const CalendarGrid({
    required this.month,
    required this.year,
    required this.selected,
    required this.onDaySelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstWeekday = DateTime(year, month, 1).weekday % 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: firstWeekday + daysInMonth,
      itemBuilder: (context, index) {
        if (index < firstWeekday) return const SizedBox.shrink();
        final day = index - firstWeekday + 1;
        final isSel = selected.year == year && selected.month == month && selected.day == day;
        return GestureDetector(
          onTap: () => onDaySelected(day),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSel ? Colors.blue : null,
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  color: isSel ? Colors.white : Colors.black,
                  fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
