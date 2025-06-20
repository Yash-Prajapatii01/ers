import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// class MonthYearPicker extends StatelessWidget {
//   final DateTime initialDate;
//   final ValueChanged<DateTime> onDateChanged;
//
//   const MonthYearPicker({
//     Key? key,
//     required this.initialDate,
//     required this.onDateChanged,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 190.h,
//       child: CupertinoDatePicker( //todo here we have to work for the dialer radius and implement the custom if possible.
//         mode: CupertinoDatePickerMode.monthYear,
//         initialDateTime: initialDate,
//         minimumDate: DateTime(DateTime.now().year - 100),
//         maximumDate: DateTime(2099, 12),
//         onDateTimeChanged: onDateChanged,
//       ),
//     );
//   }
// }

// class MonthYearPicker extends StatelessWidget {
//   final DateTime initialDate;
//   final ValueChanged<DateTime> onDateChanged;
//   final DateTime? minSelectableDate; // Add this parameter
//   final bool isEndDatePicker; // Add this parameter
//
//   const MonthYearPicker({
//     Key? key,
//     required this.initialDate,
//     required this.onDateChanged,
//     this.minSelectableDate, // Optional constraint
//     this.isEndDatePicker = false, // Default to false for "From" picker
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 190.h,
//       child: CupertinoDatePicker(
//         mode: CupertinoDatePickerMode.monthYear,
//         initialDateTime: initialDate,
//         minimumDate: isEndDatePicker
//             ? minSelectableDate
//             : null, // No limit for "From" picker
//         maximumDate: DateTime(2099, 12),
//         onDateTimeChanged: onDateChanged,
//       ),
//     );
//   }
// }
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../../CustomCupertinoPicker.dart';
//
// class MonthYearPickerWidget extends StatefulWidget {
//   final DateTime initialDate;
//   final ValueChanged<DateTime> onDateChanged;
//
//   const MonthYearPickerWidget({
//     super.key,
//     required this.initialDate,
//     required this.onDateChanged,
//   });
//
//   @override
//   State<MonthYearPickerWidget> createState() => _MonthYearPickerWidgetState();
// }
//
// class _MonthYearPickerWidgetState extends State<MonthYearPickerWidget> {
//   late DateTime _selectedDate;
//   DateTime minimumDate = DateTime(DateTime.now().year - 100);
//   DateTime maximumDate =  DateTime(DateTime.now().year + 100);
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedDate = widget.initialDate;
//   }
//
//   List<String> get _monthOptions {
//     return List.generate(12, (index) {
//       return DateFormat.MMMM().format(DateTime(2000, index + 1));
//     });
//   }
//
//   List<int> get _yearOptions {
//     final startYear = minimumDate.year;
//     final endYear = maximumDate.year;
//     return List.generate(endYear - startYear + 1, (index) => startYear + index);
//   }
//
//   void _onSelectionChanged(dynamic month, String year) {
//     // month will be the month name string, year will be the year string
//     final monthIndex = _monthOptions.indexOf(month.toString()) + 1;
//     final yearValue = int.parse(year);
//
//     final newDate = DateTime(yearValue, monthIndex);
//     setState(() {
//       _selectedDate = newDate;
//     });
//     widget.onDateChanged(newDate);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomCupertinoPicker(
//       firstColumnOptions: _monthOptions,
//       secondColumnOptions: _yearOptions.map((year) => year.toString()).toList(),
//       onDualColumnSelected: _onSelectionChanged,
//     );
//   }
// }

class MonthYearPicker extends StatelessWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;
  final DateTime? minSelectableDate;
  final bool isEndDatePicker;

  const MonthYearPicker({
    Key? key,
    required this.initialDate,
    required this.onDateChanged,
    this.minSelectableDate,
    this.isEndDatePicker = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the effective initial date
    DateTime effectiveInitialDate = initialDate;

    // If this is an end date picker and we have a minimum date constraint
    if (isEndDatePicker && minSelectableDate != null) {
      // Ensure the initial date is not before the minimum selectable date
      if (initialDate.isBefore(minSelectableDate!)) {
        effectiveInitialDate = DateTime(
          minSelectableDate!.year,
          minSelectableDate!.month,
          1, // Set to first day of the month for monthYear mode
        );
      }
    }

    return SizedBox(
      height: 190.h,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.monthYear,
        initialDateTime: effectiveInitialDate,
        minimumDate: isEndDatePicker
            ? (minSelectableDate != null
            ? DateTime(minSelectableDate!.year, minSelectableDate!.month, 1)
            : null)
            : null,
        maximumDate: DateTime(2099, 12),
        onDateTimeChanged: onDateChanged,
      ),
    );
  }
}