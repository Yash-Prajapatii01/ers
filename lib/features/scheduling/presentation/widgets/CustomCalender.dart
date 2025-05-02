import 'package:ers_linux/features/scheduling/presentation/widgets/DateSelector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'CalenderGrid.dart';

class StandaloneCalendar extends StatefulWidget {
  final DateTime? initialDate;
  final bool isTimeShow;
  final ValueChanged<DateTime>? onDateSelected;

  const StandaloneCalendar({
    Key? key,
    this.initialDate,
    this.onDateSelected,
    required this.isTimeShow,
  }) : super(key: key);

  @override
  State<StandaloneCalendar> createState() => _StandaloneCalendarState();
}

class _StandaloneCalendarState extends State<StandaloneCalendar> {
  late DateTime selectedDate;
  late DateTime displayedMonth;
  bool showMonthYearPicker = false;
  TimeOfDay selectedTime = TimeOfDay.now();
  bool showTimePicker = false;

  String _formatTime(TimeOfDay time) {
    final dt = DateTime(0, 0, 0, time.hour, time.minute);
    return DateFormat.jm().format(dt);
  }

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate ?? DateTime.now();
    displayedMonth = DateTime(selectedDate.year, selectedDate.month);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Header: Month-Year + navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap:
                    () => setState(() {
                      showMonthYearPicker = !showMonthYearPicker;
                    }),
                child: Row(
                  children: [
                    Text(
                      DateFormat('MMMM yyyy').format(displayedMonth),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Icon(
                      showMonthYearPicker
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.blue),
                    onPressed:
                        () => setState(() {
                          displayedMonth = DateTime(
                            displayedMonth.year,
                            displayedMonth.month - 1,
                          );
                        }),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, color: Colors.blue),
                    onPressed:
                        () => setState(() {
                          displayedMonth = DateTime(
                            displayedMonth.year,
                            displayedMonth.month + 1,
                          );
                        }),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (showMonthYearPicker)
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.monthYear,
                initialDateTime: displayedMonth,
                minimumDate: DateTime(DateTime.now().year - 5),
                maximumDate: DateTime(DateTime.now().year + 5, 12),
                onDateTimeChanged:
                    (newDate) => setState(() {
                      displayedMonth = DateTime(newDate.year, newDate.month);
                    }),
              ),
            )
          else
            Column(
              children: [
                CalendarGrid(
                  month: displayedMonth.month,
                  year: displayedMonth.year,
                  selected: selectedDate,
                  onDaySelected: (day) {
                    final picked = DateTime(
                      displayedMonth.year,
                      displayedMonth.month,
                      day,
                    );
                    setState(() => selectedDate = picked);
                    widget.onDateSelected?.call(picked);
                  },
                ),
                if (widget.isTimeShow)...[
                  const Divider(thickness: 1),
                  DateTimeRow(
                    label: 'Time',
                    time: _formatTime(selectedTime),
                    onTimeTap: () {
                      setState(() {
                        showTimePicker = !showTimePicker;
                      });
                    },
                  ),
                  if (showTimePicker)
                    SingleChildScrollView(
                      child: SizedBox(
                        height: 150,
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.time,
                          initialDateTime: DateTime(0, 0, 0, selectedTime.hour, selectedTime.minute),
                          onDateTimeChanged: (dateTime) {
                            setState(() {
                              selectedTime = TimeOfDay.fromDateTime(dateTime);
                            });
                          },
                        ),
                      ),
                    ),
                  Divider(thickness: 1,)
                ]
              ],
            ),
        ],
      ),
    );
  }
}
