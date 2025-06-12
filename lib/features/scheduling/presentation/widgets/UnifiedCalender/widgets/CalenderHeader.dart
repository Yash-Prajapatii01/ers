import 'package:ers_linux/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
              Icon(
                showMonthYearPicker
                    ? Icons.keyboard_arrow_down_rounded
                    : Icons.keyboard_arrow_right_rounded,
                color: AppColors.primaryColor,
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
                Icons.chevron_left_rounded,
                color: AppColors.primaryColor,
              ),
              onPressed: onPreviousMonth,
            ),
            IconButton(
              icon: const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.primaryColor,
              ),
              onPressed: onNextMonth,
            ),
          ],
        ),
      ],
    );
  }
}