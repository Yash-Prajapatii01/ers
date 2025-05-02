

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
          DateTimeRow(
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
          DateTimeRow(
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
          RepeatRow(
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

class DateTimeRow extends StatelessWidget {
  final String label;
  final String? date;
  final String? time;
  final Color? dateColor;
  final Color? timeColor;
  final VoidCallback? onDateTap;
  final VoidCallback? onTimeTap;

  const DateTimeRow({
    required this.label,
    this.date,
    this.time,
    this.dateColor,
    this.timeColor,
    this.onDateTap,
    this.onTimeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          if (date != null)
            GestureDetector(onTap: onDateTap, child: PillText(date!, dateColor ?? Colors.black)),
          if (date != null && time != null) const SizedBox(width: 8),
          if (time != null)
            GestureDetector(onTap: onTimeTap, child: PillText(time!, timeColor ?? Colors.black)),
        ],
      ),
    );
  }
}

class RepeatRow extends StatelessWidget {
  final String label, value;
  final List<String> options;
  final String selectedValue;
  final ValueChanged<String> onSelected;

  const RepeatRow({required this.label, required this.value, required this.options, required this.selectedValue, required this.onSelected});

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

class PillText extends StatelessWidget {
  final String text;
  final Color color;

  const PillText(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFFF4F4F4), borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: color)),
    );
  }
}
