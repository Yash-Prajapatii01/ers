//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class DateTimeSelector extends StatefulWidget {
//   const DateTimeSelector({super.key});
//
//   @override
//   State<DateTimeSelector> createState() => _DateTimeSelectorState();
// }
//
// class _DateTimeSelectorState extends State<DateTimeSelector> {
//   DateTime fromDate = DateTime.now();
//   TimeOfDay fromTime = TimeOfDay(hour: 9, minute: 0);
//   DateTime toDate = DateTime.now();
//   TimeOfDay toTime = TimeOfDay(hour: 17, minute: 0);
//   String repeat = '';
//
//   bool showFromCalendar = false;
//   bool showToCalendar = false;
//   bool showFromTimePicker = false;
//   bool showToTimePicker = false;
//   bool showMonthYearPicker = false;
//   bool isFromDatePicker = true; // Track if we're picking From or To date
//   DateTime displayedMonth = DateTime.now();
//   DateTime tempMonthYear = DateTime.now();
//
//   void _toggleTimePicker(bool isFrom) {
//     setState(() {
//       showFromCalendar = false;
//       showToCalendar = false;
//       showMonthYearPicker = false;
//
//       if (isFrom) {
//         showFromTimePicker = !showFromTimePicker;
//         showToTimePicker = false;
//       } else {
//         showToTimePicker = !showToTimePicker;
//         showFromTimePicker = false;
//       }
//     });
//   }
//
//   void showCustomMenu({
//     required BuildContext triggerContext,
//     required BuildContext parentContext,
//     required List<String> options,
//     required String selectedValue,
//     required void Function(String selected) onSelected,
//   }) async {
//     final RenderBox button = triggerContext.findRenderObject() as RenderBox;
//     final RenderBox overlay = Overlay.of(parentContext).context.findRenderObject() as RenderBox;
//     final Offset position = button.localToGlobal(
//       Offset.zero,
//       ancestor: overlay,
//     );
//
//     // Calculate the position to align to the right and above the Repeat field
//     final selected = await showMenu<String>(
//       context: parentContext,
//       position: RelativeRect.fromLTRB(
//         overlay.size.width - 200,  // Right-aligned with fixed width
//         position.dy - 48 * options.length - 16,  // Position above the Repeat field with padding
//         20,  // Right margin
//         overlay.size.height - position.dy,  // Space from bottom edge
//       ),
//       elevation: 4.0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       items: options.map((option) {
//         return PopupMenuItem<String>(
//           value: option,
//           height: 48.0, // Match the height in the image
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 option,
//                 style: TextStyle(
//                   fontSize: 16.0,
//                   fontWeight: option == selectedValue ? FontWeight.w500 : FontWeight.normal,
//                 ),
//               ),
//               if (option == selectedValue) const Icon(Icons.check, color: Colors.blue, size: 20.0),
//             ],
//           ),
//         );
//       }).toList(),
//     );
//
//     if (selected != null) {
//       onSelected(selected);
//     }
//   }
//
//   String formatDate(DateTime date) {
//     return DateFormat('d MMM yyyy').format(date);
//   }
//
//   String formatTime(TimeOfDay time) {
//     final dt = DateTime(0, 0, 0, time.hour, time.minute);
//     return DateFormat.jm().format(dt);
//   }
//
//   String formatMonthYear(DateTime date) {
//     return DateFormat('MMMM yyyy').format(date);
//   }
//
//   void _toggleCalendar({bool isFrom = true}) {
//     setState(() {
//       if (isFrom) {
//         showFromCalendar = !showFromCalendar;
//         showToCalendar = false;
//         isFromDatePicker = true;
//       } else {
//         showToCalendar = !showToCalendar;
//         showFromCalendar = false;
//         isFromDatePicker = false;
//       }
//
//       showFromTimePicker = false;
//       showToTimePicker = false;
//       showMonthYearPicker = false;
//       displayedMonth = isFrom ? fromDate : toDate;
//     });
//   }
//
//   void _toggleMonthYearPicker() {
//     setState(() {
//       tempMonthYear = displayedMonth;
//       showMonthYearPicker = !showMonthYearPicker;
//     });
//   }
//
//   void _selectMonth(int month, int year) {
//     setState(() {
//       displayedMonth = DateTime(year, month);
//       showMonthYearPicker = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: const Color.fromRGBO(208, 213, 221, 1),
//           width: 0.5,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _DateTimeRow(
//             label: 'From',
//             date: formatDate(fromDate),
//             time: formatTime(fromTime),
//             onDateTap: () => _toggleCalendar(isFrom: true),
//             onTimeTap: () => _toggleTimePicker(true),
//           ),
//           if (showFromCalendar) _buildCalendarSection(),
//           if (showFromTimePicker) _buildTimePicker(isFrom: true),
//           const Divider(thickness: 0.7),
//           _DateTimeRow(
//             label: 'To',
//             date: formatDate(toDate),
//             time: formatTime(toTime),
//             onDateTap: () => _toggleCalendar(isFrom: false),
//             onTimeTap: () => _toggleTimePicker(false),
//           ),
//           if (showToCalendar) _buildCalendarSection(),
//           if (showToTimePicker) _buildTimePicker(isFrom: false),
//           const Divider(thickness: 0.7),
//           Builder(
//             builder: (context) => _RepeatRow(
//               label: 'Repeat',
//               value: repeat.isEmpty ? 'None' : repeat,
//               onTap: () => showCustomMenu(
//                 triggerContext: context,
//                 parentContext: this.context,
//                 options: [
//                   'None',
//                   'Daily',
//                   'Weekly',
//                   'Monthly',
//                   'Yearly',
//                   'Custom',
//                 ],
//                 selectedValue: repeat.isEmpty ? 'None' : repeat,
//                 onSelected: (selected) {
//                   setState(() {
//                     repeat = selected;
//                   });
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTimePicker({required bool isFrom}) {
//     return SizedBox(
//       height: 200,
//       child: CupertinoDatePicker(
//         mode: CupertinoDatePickerMode.time,
//         initialDateTime: DateTime(
//           2025,
//           1,
//           1,
//           isFrom ? fromTime.hour : toTime.hour,
//           isFrom ? fromTime.minute : toTime.minute,
//         ),
//         onDateTimeChanged: (val) {
//           setState(() {
//             if (isFrom) {
//               fromTime = TimeOfDay.fromDateTime(val);
//             } else {
//               toTime = TimeOfDay.fromDateTime(val);
//             }
//           });
//         },
//       ),
//     );
//   }
//   Widget _buildCalendarSection() {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             GestureDetector(
//               onTap: _toggleMonthYearPicker,
//               child: Row(
//                 children: [
//                   Text(
//                     formatMonthYear(displayedMonth),
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue,
//                     ),
//                   ),
//                   const Icon(Icons.chevron_right, color: Colors.blue),
//                 ],
//               ),
//             ),
//             // Navigation arrows
//             Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.chevron_left, color: Colors.blue),
//                   padding: EdgeInsets.zero,
//                   constraints: const BoxConstraints(),
//                   onPressed: () {
//                     setState(() {
//                       displayedMonth = DateTime(
//                         displayedMonth.year,
//                         displayedMonth.month - 1,
//                       );
//                     });
//                   },
//                 ),
//                 const SizedBox(width: 16),
//                 IconButton(
//                   icon: const Icon(Icons.chevron_right, color: Colors.blue),
//                   padding: EdgeInsets.zero,
//                   constraints: const BoxConstraints(),
//                   onPressed: () {
//                     setState(() {
//                       displayedMonth = DateTime(
//                         displayedMonth.year,
//                         displayedMonth.month + 1,
//                       );
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         if (showMonthYearPicker) _buildMonthYearPicker() else _buildCalendar(),
//       ],
//     );
//   }
//   Widget _buildMonthYearPicker() {
//     final int currentYear = DateTime.now().year;
//     final DateTime minimumDate = DateTime(currentYear - 50);
//     final DateTime maximumDate = DateTime(currentYear + 50, 12);
//
//     return Column(
//       children: [
//         SizedBox(
//           height: 200,
//           child: CupertinoDatePicker(
//             mode: CupertinoDatePickerMode.monthYear,
//             initialDateTime: tempMonthYear,
//             minimumDate: minimumDate,
//             maximumDate: maximumDate,
//             onDateTimeChanged: (DateTime newDate) {
//               setState(() {
//                 tempMonthYear = DateTime(newDate.year, newDate.month);
//               });
//             },
//           ),
//         ),
//         Align(
//           alignment: Alignment.centerRight,
//           child: TextButton(
//             onPressed: () {
//               _selectMonth(tempMonthYear.month, tempMonthYear.year);
//             },
//             child: const Text("Done"),
//           ),
//         ),
//       ],
//     );
//   }
//
//
//
//   Widget _buildCalendar() {
//     final daysInMonth = DateTime(displayedMonth.year, displayedMonth.month + 1, 0).day;
//     final firstDayOfWeek = DateTime(displayedMonth.year, displayedMonth.month, 1).weekday % 7;
//
//     // Headers for the days of the week
//     final dayHeaders = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
//
//     return Column(
//       children: [
//         // Day headers
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: dayHeaders
//               .map(
//                 (day) => SizedBox(
//               width: 30,
//               child: Center(
//                 child: Text(
//                   day,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[500],
//                   ),
//                 ),
//               ),
//             ),
//           )
//               .toList(),
//         ),
//         const SizedBox(height: 8),
//         // Calendar grid
//         GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 7,
//             childAspectRatio: 1,
//           ),
//           itemCount: firstDayOfWeek + daysInMonth,
//           itemBuilder: (context, index) {
//             if (index < firstDayOfWeek) {
//               return const SizedBox.shrink(); // Empty space for days before the 1st of the month
//             }
//
//             final day = index - firstDayOfWeek + 1;
//             final date = DateTime(
//               displayedMonth.year,
//               displayedMonth.month,
//               day,
//             );
//             DateTime compareDate = isFromDatePicker ? fromDate : toDate;
//             final isSelected = date.year == compareDate.year &&
//                 date.month == compareDate.month &&
//                 date.day == compareDate.day;
//
//             return GestureDetector(
//               onTap: () {
//                 setState(() {
//                   if (isFromDatePicker) {
//                     fromDate = date;
//                   } else {
//                     toDate = date;
//                   }
//                 });
//               },
//               child: Container(
//                 margin: const EdgeInsets.all(2),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: isSelected ? Colors.blue : null,
//                 ),
//                 child: Center(
//                   child: Text(
//                     day.toString(),
//                     style: TextStyle(
//                       color: isSelected ? Colors.white : Colors.black,
//                       fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
//
// class _DateTimeRow extends StatelessWidget {
//   final String label;
//   final String date;
//   final String time;
//   final VoidCallback onDateTap;
//   final VoidCallback onTimeTap;
//
//   const _DateTimeRow({
//     required this.label,
//     required this.date,
//     required this.time,
//     required this.onDateTap,
//     required this.onTimeTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Text(label, style: const TextStyle(fontSize: 16)),
//           const Spacer(),
//           GestureDetector(onTap: onDateTap, child: _PillText(date)),
//           const SizedBox(width: 8),
//           GestureDetector(onTap: onTimeTap, child: _PillText(time)),
//         ],
//       ),
//     );
//   }
// }
//
// class _RepeatRow extends StatelessWidget {
//   final String label;
//   final String value;
//   final VoidCallback onTap;
//
//   const _RepeatRow({
//     required this.label,
//     required this.value,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       behavior: HitTestBehavior.opaque,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         child: Row(
//           children: [
//             Text(label, style: const TextStyle(fontSize: 16)),
//             const Spacer(),
//             Text(
//               value,
//               style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//             ),
//             const SizedBox(width: 4),
//             Icon(Icons.keyboard_arrow_down, color: Colors.grey[600], size: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _PillText extends StatelessWidget {
//   final String text;
//
//   const _PillText(this.text);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//       decoration: BoxDecoration(
//         color: const Color.fromRGBO(244, 244, 244, 1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
//       ),
//     );
//   }
// }


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum PickerType { none, fromDate, toDate, fromTime, toTime }

class DateTimeSelector extends StatefulWidget {
  const DateTimeSelector({Key? key}) : super(key: key);

  @override
  State<DateTimeSelector> createState() => _DateTimeSelectorState();
}

class _DateTimeSelectorState extends State<DateTimeSelector> {
  // Date/time values
  DateTime fromDate = DateTime.now();
  TimeOfDay fromTime = const TimeOfDay(hour: 9, minute: 0);
  DateTime toDate = DateTime.now();
  TimeOfDay toTime = const TimeOfDay(hour: 17, minute: 0);

  // Selection flags for coloring
  bool pickedFromDate = false;
  bool pickedFromTime = false;
  bool pickedToDate = false;
  bool pickedToTime = false;

  // Repeat option
  String repeat = '';

  // Active picker
  PickerType activePicker = PickerType.none;
  DateTime displayedMonth = DateTime.now();
  bool showMonthYearPicker = false;

  void _togglePicker(PickerType type) {
    setState(() {
      if (activePicker == type) {
        activePicker = PickerType.none;
      } else {
        activePicker = type;
      }
      // reset sub-picker whenever switching main picker
      showMonthYearPicker = false;
      if (type == PickerType.fromDate) displayedMonth = fromDate;
      if (type == PickerType.toDate) displayedMonth = toDate;
    });
  }

  void _toggleMonthYearPicker() {
    setState(() {
      showMonthYearPicker = !showMonthYearPicker;
    });
  }

  void _onRepeatSelected(String value) {
    setState(() { repeat = value; });
  }

  String _formatDate(DateTime date) => DateFormat('d MMM yyyy').format(date);
  String _formatTime(TimeOfDay time) {
    final dt = DateTime(0, 0, 0, time.hour, time.minute);
    return DateFormat.jm().format(dt);
  }
  String _formatMonthYear(DateTime date) => DateFormat('MMMM yyyy').format(date);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD0D5DD), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // From row
          _DateTimeRow(
            label: 'From',
            date: _formatDate(fromDate),
            time: _formatTime(fromTime),
            dateColor: pickedFromDate ? Colors.blue : const Color(0xFF444444),
            timeColor: pickedFromTime ? Colors.blue : const Color(0xFF444444),
            onDateTap: () => _togglePicker(PickerType.fromDate),
            onTimeTap: () => _togglePicker(PickerType.fromTime),
          ),
          if (activePicker == PickerType.fromDate) _buildCalendar(isFrom: true),
          if (activePicker == PickerType.fromTime) _buildTimePicker(isFrom: true),
          const Divider(thickness: 0.7),

          // To row
          _DateTimeRow(
            label: 'To',
            date: _formatDate(toDate),
            time: _formatTime(toTime),
            dateColor: pickedToDate ? Colors.blue : const Color(0xFF444444),
            timeColor: pickedToTime ? Colors.blue : const Color(0xFF444444),
            onDateTap: () => _togglePicker(PickerType.toDate),
            onTimeTap: () => _togglePicker(PickerType.toTime),
          ),
          if (activePicker == PickerType.toDate) _buildCalendar(isFrom: false),
          if (activePicker == PickerType.toTime) _buildTimePicker(isFrom: false),
          const Divider(thickness: 0.7),

          // Repeat row
          _RepeatRow(
            label: 'Repeat',
            value: repeat.isEmpty ? 'None' : repeat,
            options: const ['None', 'Daily', 'Weekly', 'Monthly', 'Yearly', 'Custom'],
            selectedValue: repeat.isEmpty ? 'None' : repeat,
            onSelected: _onRepeatSelected,
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker({required bool isFrom}) => SizedBox(
    height: 200,
    child: CupertinoDatePicker(
      mode: CupertinoDatePickerMode.time,
      initialDateTime: DateTime(0, 0, 0, isFrom ? fromTime.hour : toTime.hour, isFrom ? fromTime.minute : toTime.minute),
      onDateTimeChanged: (val) => setState(() {
        if (isFrom) {
          fromTime = TimeOfDay.fromDateTime(val);
          pickedFromTime = true;
        } else {
          toTime = TimeOfDay.fromDateTime(val);
          pickedToTime = true;
        }
      }),
    ),
  );

  Widget _buildCalendar({required bool isFrom}) => Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _toggleMonthYearPicker,
            child: Row(
              children: [
                Text(
                  _formatMonthYear(displayedMonth),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                Icon(
                  showMonthYearPicker ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.blue),
                onPressed: () => setState(() => displayedMonth = DateTime(displayedMonth.year, displayedMonth.month - 1)),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.blue),
                onPressed: () => setState(() => displayedMonth = DateTime(displayedMonth.year, displayedMonth.month + 1)),
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
            onDateTimeChanged: (newDate) => setState(() {
              displayedMonth = DateTime(newDate.year, newDate.month);
              if (isFrom) {
                fromDate = DateTime(newDate.year, newDate.month, fromDate.day);
                pickedFromDate = true;
              } else {
                toDate = DateTime(newDate.year, newDate.month, toDate.day);
                pickedToDate = true;
              }
            }),
          ),
        )
      else
        _CalendarGrid(
          month: displayedMonth.month,
          year: displayedMonth.year,
          selected: isFrom ? fromDate : toDate,
          onDaySelected: (day) => setState(() {
            final date = DateTime(displayedMonth.year, displayedMonth.month, day);
            if (isFrom) {
              fromDate = date;
              pickedFromDate = true;
            } else {
              toDate = date;
              pickedToDate = true;
            }
          }),
        ),
    ],
  );
}

class _CalendarGrid extends StatelessWidget {
  final int month, year;
  final DateTime selected;
  final ValueChanged<int> onDaySelected;

  const _CalendarGrid({required this.month, required this.year, required this.selected, required this.onDaySelected});

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstWeekday = DateTime(year, month, 1).weekday % 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7, childAspectRatio: 1
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
            decoration: BoxDecoration(shape: BoxShape.circle, color: isSel ? Colors.blue : null),
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

class _DateTimeRow extends StatelessWidget {
  final String label, date, time;
  final Color dateColor, timeColor;
  final VoidCallback onDateTap, onTimeTap;

  const _DateTimeRow({required this.label, required this.date, required this.time, required this.dateColor, required this.timeColor, required this.onDateTap, required this.onTimeTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          GestureDetector(onTap: onDateTap, child: _PillText(date, dateColor)),
          const SizedBox(width: 8),
          GestureDetector(onTap: onTimeTap, child: _PillText(time, timeColor)),
        ],
      ),
    );
  }
}

class _RepeatRow extends StatelessWidget {
  final String label, value;
  final List<String> options;
  final String selectedValue;
  final ValueChanged<String> onSelected;

  const _RepeatRow({required this.label, required this.value, required this.options, required this.selectedValue, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final Offset offset = box.localToGlobal(Offset.zero);
        final Size size = box.size;
        final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

        // Popup menu will be positioned just above the widget
        final RelativeRect pos = RelativeRect.fromLTRB(
          offset.dx + size.width - 200,
          offset.dy - (65.0 * options.length) - 5.0,
          overlay.size.width - offset.dx - size.width,
          offset.dy,
        );


        final items = <PopupMenuEntry<String>>[];
        for (var i = 0; i < options.length; i++) {
          if (i > 0) items.add(const PopupMenuDivider());
          items.add(
            PopupMenuItem<String>(
              value: options[i],
              child: Text(
                options[i],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: options[i] == selectedValue ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
          );
        }

        final choice = await showMenu<String>(
          context: context,
          position: pos,
          items: items,
        );

        if (choice != null) onSelected(choice);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Text(label, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            Text(value, style: const TextStyle(fontSize: 16, color: Color(0xFF444444))),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, size: 20),
          ],
        ),
      ),
    );

  }
}

class _PillText extends StatelessWidget {
  final String text;
  final Color color;

  const _PillText(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFFF4F4F4), borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: color)),
    );
  }
}
