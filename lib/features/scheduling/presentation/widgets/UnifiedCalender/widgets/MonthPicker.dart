import 'package:flutter/cupertino.dart';
class MonthYearPicker extends StatelessWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;

  const MonthYearPicker({
    Key? key,
    required this.initialDate,
    required this.onDateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.monthYear,
        initialDateTime: initialDate,
        minimumDate: DateTime(DateTime.now().year - 100),
        maximumDate: DateTime(2099, 12),
        onDateTimeChanged: onDateChanged,
      ),
    );
  }
}