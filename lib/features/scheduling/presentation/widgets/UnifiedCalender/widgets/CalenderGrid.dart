import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../shared/theme/app_colors.dart';

// class CalendarGrid extends StatelessWidget {
//   final int month, year;
//   final DateTime selected;
//   final ValueChanged<int> onDaySelected;
//   final bool showWeekdayLabels;
//
//   const CalendarGrid({
//     Key? key,
//     required this.month,
//     required this.year,
//     required this.selected,
//     required this.onDaySelected,
//     this.showWeekdayLabels = true,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // Number of days in the month
//     final daysInMonth = DateTime(year, month + 1, 0).day;
//
//     // Calculate the index of the first weekday (Sunday = 0, Monday = 1, ...)
//     final firstWeekday = (DateTime(year, month, 1).weekday % 7);
//
//     // Days of week labels starting from Sunday
//     final daysOfWeek = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
//
//     return Column(
//       children: [
//         if (showWeekdayLabels)
//           Padding(
//             padding: const EdgeInsets.only(bottom: 6.0, top: 2.0),
//             child: Row(
//               children: daysOfWeek.asMap().entries.map((entry) {
//                 final index = entry.key;
//                 final day = entry.value;
//                 // Apply bleeding offset for weekday labels on extremes
//                 final offsetX = index == 0 ? -8.0 : (index == 6 ? 8.0 : 0.0);
//                 return Expanded(
//                   child: Transform.translate(
//                     offset: Offset(offsetX, 0),
//                     child: Center(
//                       child: Text(
//                         day,
//                         style:  TextStyle(
//                           color: AppColors.calenderHeaderColor,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 12.sp,
//                           letterSpacing: 0.2.w,
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//         GridView.builder(
//           padding:  EdgeInsets.fromLTRB(0, 0, 0, 4.h),
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 7,
//             childAspectRatio: 1.0, // Adjusted to ensure tight fit
//             crossAxisSpacing: 0,
//             mainAxisSpacing: 4, // Reduced to minimize vertical space
//           ),
//           itemCount: firstWeekday + daysInMonth,
//           itemBuilder: (context, index) {
//             if (index < firstWeekday) return const SizedBox.shrink();
//
//             final day = index - firstWeekday + 1;
//             final isSelected = selected.year == year &&
//                 selected.month == month &&
//                 selected.day == day;
//
//             // Calculate column index for bleeding
//             final columnIndex = index % 7;
//             final offsetX = columnIndex == 0 ? -12.0 : (columnIndex == 6 ? 12.0 : 0.0);
//
//             return GestureDetector(
//               onTap: () => onDaySelected(day),
//               child: Transform.translate(
//                 offset: Offset(offsetX, 0),
//                 child: Container(
//                   width: 32,
//                   height: 32,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: isSelected ? AppColors.primaryColor : Colors.transparent,
//                   ),
//                   alignment: Alignment.center,
//                   child: Text(
//                     '$day',
//                     style: TextStyle(
//                       color: isSelected ? Colors.white : AppColors.darkBlack,
//                       fontWeight: FontWeight.w400,
//                       fontSize: 17.sp,
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
class CalendarGrid extends StatelessWidget {
  final int month, year;
  final DateTime selected;
  final ValueChanged<int> onDaySelected;
  final bool showWeekdayLabels;
  final DateTime? minSelectableDate; // New parameter for minimum selectable date
  final bool isEndDatePicker; // New parameter to identify if this is for end date

  const CalendarGrid({
    Key? key,
    required this.month,
    required this.year,
    required this.selected,
    required this.onDaySelected,
    this.showWeekdayLabels = true,
    this.minSelectableDate,
    this.isEndDatePicker = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Number of days in the month
    final daysInMonth = DateTime(year, month + 1, 0).day;

    // Calculate the index of the first weekday (Sunday = 0, Monday = 1, ...)
    final firstWeekday = (DateTime(year, month, 1).weekday % 7);

    // Days of week labels starting from Sunday
    final daysOfWeek = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

    return Column(
      children: [
        if (showWeekdayLabels)
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0, top: 2.0),
            child: Row(
              children: daysOfWeek.asMap().entries.map((entry) {
                final index = entry.key;
                final day = entry.value;
                // Apply bleeding offset for weekday labels on extremes
                final offsetX = index == 0 ? -8.0 : (index == 6 ? 8.0 : 0.0);
                return Expanded(
                  child: Transform.translate(
                    offset: Offset(offsetX, 0),
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(
                          color: AppColors.calenderHeaderColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                          letterSpacing: 0.2.w,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        GridView.builder(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 4.h),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.0,
            crossAxisSpacing: 0,
            mainAxisSpacing: 4,
          ),
          itemCount: firstWeekday + daysInMonth,
          itemBuilder: (context, index) {
            if (index < firstWeekday) return const SizedBox.shrink();

            final day = index - firstWeekday + 1;
            final currentDate = DateTime(year, month, day);

            final isSelected = selected.year == year &&
                selected.month == month &&
                selected.day == day;

            // Check if date is selectable
            bool isSelectable = true;
            if (minSelectableDate != null) {
              // For end date picker, date must be after or equal to minSelectableDate
              // For start date picker, date must be today or after
              if (isEndDatePicker) {
                isSelectable = currentDate.isAfter(minSelectableDate!) ||
                    _isSameDate(currentDate, minSelectableDate!);
              } else {
                final today = DateTime.now();
                final todayStart = DateTime(today.year, today.month, today.day);
                isSelectable = currentDate.isAfter(todayStart) ||
                    _isSameDate(currentDate, todayStart);
              }
            }

            // Calculate column index for bleeding
            final columnIndex = index % 7;
            final offsetX = columnIndex == 0 ? -12.0 : (columnIndex == 6 ? 12.0 : 0.0);

            return GestureDetector(
              onTap: isSelectable ? () => onDaySelected(day) : null,
              child: Transform.translate(
                offset: Offset(offsetX, 0),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? AppColors.primaryColor
                        : Colors.transparent,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$day',
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : isSelectable
                          ? AppColors.darkBlack
                          : AppColors.darkBlack.withOpacity(0.3),
                      fontWeight: FontWeight.w400,
                      fontSize: 17.sp,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}