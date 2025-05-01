import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomCalendarPicker extends StatefulWidget {
  final DateTime displayedMonth;
  final bool showMonthYearPicker;
  final bool isFromDatePicker;
  final DateTime selectedDate;
  final void Function(DateTime) onDateSelected;
  final void Function() onToggleMonthYearPicker;
  final void Function(DateTime) onMonthYearSelected;
  final void Function(bool next) onMonthChanged;

  const CustomCalendarPicker({
    required this.displayedMonth,
    required this.showMonthYearPicker,
    required this.isFromDatePicker,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onToggleMonthYearPicker,
    required this.onMonthYearSelected,
    required this.onMonthChanged,
    super.key,
  });

  @override
  State<CustomCalendarPicker> createState() => _CustomCalendarPickerState();
}

class _CustomCalendarPickerState extends State<CustomCalendarPicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 12),
        widget.showMonthYearPicker ? _buildMonthYearPicker() : _buildCalendar(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: widget.onToggleMonthYearPicker,
          child: Row(
            children: [
              Text(
                DateFormat('MMMM yyyy').format(widget.displayedMonth),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.blue),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.blue),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => widget.onMonthChanged(false),
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Colors.blue),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => widget.onMonthChanged(true),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    final daysInMonth = DateTime(widget.displayedMonth.year, widget.displayedMonth.month + 1, 0).day;
    final firstDayOfWeek = DateTime(widget.displayedMonth.year, widget.displayedMonth.month, 1).weekday % 7;
    final dayHeaders = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: dayHeaders
              .map((day) => SizedBox(
            width: 30,
            child: Center(
              child: Text(
                day,
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ),
          ))
              .toList(),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
          ),
          itemCount: firstDayOfWeek + daysInMonth,
          itemBuilder: (context, index) {
            if (index < firstDayOfWeek) return const SizedBox.shrink();

            final day = index - firstDayOfWeek + 1;
            final date = DateTime(widget.displayedMonth.year, widget.displayedMonth.month, day);
            final isSelected = widget.selectedDate.year == date.year &&
                widget.selectedDate.month == date.month &&
                widget.selectedDate.day == date.day;

            return GestureDetector(
              onTap: () => widget.onDateSelected(date),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Colors.blue : null,
                ),
                child: Center(
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
  //Todo here we have to configure the month tab as it is closing as soon as scrolled.
  Widget _buildMonthYearPicker() {
    return SizedBox(
      height: 250,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.monthYear,
        initialDateTime: widget.displayedMonth,
        minimumDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
        maximumDate: DateTime.now().add(const Duration(days: 365 * 10)),
        onDateTimeChanged: (val) {
          widget.onMonthYearSelected(val);
        },
      ),
    );
  }


// Widget _buildMonthYearPicker() {
  //   final currentYear = DateTime.now().year;
  //   final List<int> years = List.generate(10, (i) => currentYear + i - 2);
  //   final List<String> months = List.generate(
  //     12,
  //         (i) => DateFormat.MMMM().format(DateTime(0, i + 1)),
  //   );
  //
  //   return SizedBox(
  //     height: 250,
  //     child: CupertinoDatePicker(
  //       mode: CupertinoDatePickerMode.monthYear,
  //       onDateTimeChanged: (val) {
  //         setState(() {
  //           if (isFrom) {
  //             fromTime = TimeOfDay.fromDateTime(val);
  //           } else {
  //             toTime = TimeOfDay.fromDateTime(val);
  //           }
  //         });
  //       },
  //     ),
  //   );
  //
  //   // return SizedBox(
  //   //   height: 250,
  //   //   child: Row(
  //   //     children: [
  //   //       Expanded(
  //   //         child: ListView.builder(
  //   //           itemCount: months.length,
  //   //           itemBuilder: (context, index) {
  //   //             final bool isSelected = index + 1 == displayedMonth.month;
  //   //             return Container(
  //   //               color: isSelected ? Colors.grey[200] : null,
  //   //               child: ListTile(
  //   //                 title: Center(
  //   //                   child: Text(
  //   //                     months[index],
  //   //                     style: TextStyle(
  //   //                       color: isSelected ? Colors.black : Colors.grey[400],
  //   //                       fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
  //   //                     ),
  //   //                   ),
  //   //                 ),
  //   //                 onTap: () => onMonthYearSelected(DateTime(displayedMonth.year, index + 1)),
  //   //               ),
  //   //             );
  //   //           },
  //   //         ),
  //   //       ),
  //   //       Expanded(
  //   //         child: ListView.builder(
  //   //           itemCount: years.length,
  //   //           itemBuilder: (context, index) {
  //   //             final int year = years[index];
  //   //             final bool isSelected = year == displayedMonth.year;
  //   //             return Container(
  //   //               color: isSelected ? Colors.grey[200] : null,
  //   //               child: ListTile(
  //   //                 title: Center(
  //   //                   child: Text(
  //   //                     year.toString(),
  //   //                     style: TextStyle(
  //   //                       color: isSelected ? Colors.black : Colors.grey[400],
  //   //                       fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
  //   //                     ),
  //   //                   ),
  //   //                 ),
  //   //                 onTap: () => onMonthYearSelected(DateTime(year, displayedMonth.month)),
  //   //               ),
  //   //             );
  //   //           },
  //   //         ),
  //   //       ),
  //   //     ],
  //   //   ),
  //   // );
  // }
}
