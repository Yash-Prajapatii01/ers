import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// class TimePicker extends StatelessWidget {
//   final TimeOfDay initialTime;
//   final ValueChanged<TimeOfDay> onTimeChanged;
//
//   const TimePicker({
//     Key? key,
//     required this.initialTime,
//     required this.onTimeChanged,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: SizedBox(
//         height: 150.h,
//         child: CupertinoDatePicker(
//           mode: CupertinoDatePickerMode.time,
//           initialDateTime: DateTime(
//             0,
//             0,
//             0,
//             initialTime.hour,
//             initialTime.minute,
//           ),
//           onDateTimeChanged:
//               (val) => onTimeChanged(TimeOfDay.fromDateTime(val)),
//         ),
//       ),
//     );
//   }
// }

class TimePicker extends StatelessWidget {
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onTimeChanged;
  final DateTime? selectedDate; // New parameter for selected date
  final DateTime? minSelectableDate; // New parameter for minimum selectable date
  final bool isEndTimePicker; // New parameter to identify if this is for end time

  const TimePicker({
    Key? key,
    required this.initialTime,
    required this.onTimeChanged,
    this.selectedDate,
    this.minSelectableDate,
    this.isEndTimePicker = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime? minimumDateTime;
    DateTime? maximumDateTime;

    // Set time restrictions based on context
    if (selectedDate != null && minSelectableDate != null) {
      if (isEndTimePicker && _isSameDate(selectedDate!, minSelectableDate!)) {
        // If it's end time picker and same date as start date,
        // minimum time should be start time + 1 minute
        final minTime = TimeOfDay.fromDateTime(minSelectableDate!);
        minimumDateTime = DateTime(
          selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day,
          minTime.hour,
          minTime.minute + 1,
        );
      } else if (!isEndTimePicker) {
        // For start time picker, if it's today, minimum time is current time
        final now = DateTime.now();
        if (_isSameDate(selectedDate!, now)) {
          minimumDateTime = now;
        }
      }
    }

    return SingleChildScrollView(
      child: SizedBox(
        height: 150.h,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.time,
          initialDateTime: DateTime(
            selectedDate?.year ?? 0,
            selectedDate?.month ?? 0,
            selectedDate?.day ?? 0,
            initialTime.hour,
            initialTime.minute,
          ),
          minimumDate: minimumDateTime,
          maximumDate: maximumDateTime,
          onDateTimeChanged: (val) => onTimeChanged(TimeOfDay.fromDateTime(val)),
        ),
      ),
    );
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

// Enhanced MonthYearPicker with date restrictions
// class MonthYearPicker extends StatelessWidget {
//   final DateTime initialDate;
//   final ValueChanged<DateTime> onDateChanged;
//   final DateTime? minSelectableDate; // New parameter for minimum selectable date
//   final bool isEndDatePicker; // New parameter to identify if this is for end date
//
//   const MonthYearPicker({
//     Key? key,
//     required this.initialDate,
//     required this.onDateChanged,
//     this.minSelectableDate,
//     this.isEndDatePicker = false,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     DateTime minimumDate;
//
//     if (isEndDatePicker && minSelectableDate != null) {
//       // For end date picker, minimum should be the start date's month/year
//       minimumDate = DateTime(minSelectableDate!.year, minSelectableDate!.month);
//     } else {
//       // For start date picker, minimum should be current month/year
//       final now = DateTime.now();
//       minimumDate = DateTime(now.year, now.month);
//     }
//
//     return SizedBox(
//       height: 190.h,
//       child: CupertinoDatePicker(
//         mode: CupertinoDatePickerMode.monthYear,
//         initialDateTime: initialDate,
//         minimumDate: minimumDate,
//         maximumDate: DateTime(2099, 12),
//         onDateTimeChanged: onDateChanged,
//       ),
//     );
//   }
// }