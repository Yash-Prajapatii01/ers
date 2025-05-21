import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class TimePicker extends StatelessWidget {
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const TimePicker({
    Key? key,
    required this.initialTime,
    required this.onTimeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 150,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.time,
          initialDateTime: DateTime(
            0,
            0,
            0,
            initialTime.hour,
            initialTime.minute,
          ),
          onDateTimeChanged:
              (val) => onTimeChanged(TimeOfDay.fromDateTime(val)),
        ),
      ),
    );
  }
}