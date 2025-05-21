import 'package:flutter/material.dart';

class CalendarHeader extends StatelessWidget {
  final String monthYearText;
  final bool showMonthYearPicker;
  final VoidCallback onToggleMonthYearPicker;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const CalendarHeader({
    Key? key,
    required this.monthYearText,
    required this.showMonthYearPicker,
    required this.onToggleMonthYearPicker,
    required this.onPreviousMonth,
    required this.onNextMonth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Month-year selector with dropdown
        GestureDetector(
          onTap: onToggleMonthYearPicker,
          child: Row(
            children: [
              Text(
                monthYearText,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(28, 121, 212, 1),
                ),
              ),
              Icon(
                showMonthYearPicker
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right,
                color: Color.fromRGBO(28, 121, 212, 1),
              ),
            ],
          ),
        ),
        Spacer(),
        // Previous/next month buttons
        // if(!showMonthYearPicker)
        Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.chevron_left,
                color: Color.fromRGBO(28, 121, 212, 1),
              ),
              onPressed: onPreviousMonth,
            ),
            IconButton(
              icon: const Icon(
                Icons.chevron_right,
                color: Color.fromRGBO(28, 121, 212, 1),
              ),
              onPressed: onNextMonth,
            ),
          ],
        ),
      ],
    );
  }
}