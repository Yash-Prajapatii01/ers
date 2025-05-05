// File: lib/widgets/unified_calendar.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UnifiedCalendar extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? initialToDate;
  final TimeOfDay? initialFromTime;
  final TimeOfDay? initialToTime;
  final bool showTime;
  final bool isRangePicker;
  final ValueChanged<DateTime>? onDateSelected;
  final Function(DateTime fromDate, TimeOfDay fromTime,
      DateTime toDate, TimeOfDay toTime)? onRangeChanged;
  final ValueChanged<String>? onRepeatSelected;
  final List<String>? repeatOptions;

  const UnifiedCalendar({
    Key? key,
    this.initialDate,
    this.initialToDate,
    this.initialFromTime,
    this.initialToTime,
    this.showTime = false,
    this.isRangePicker = false,
    this.onDateSelected,
    this.onRangeChanged,
    this.onRepeatSelected,
    this.repeatOptions,
  }) : super(key: key);

  @override
  State<UnifiedCalendar> createState() => _UnifiedCalendarState();
}

class _UnifiedCalendarState extends State<UnifiedCalendar> {
  // Date/time values
  late DateTime fromDate;
  late TimeOfDay fromTime;
  late DateTime toDate;
  late TimeOfDay toTime;

  // Selection flags for coloring
  bool pickedFromDate = false;
  bool pickedFromTime = false;
  bool pickedToDate = false;
  bool pickedToTime = false;

  // Calendar display state
  late DateTime displayedMonth;
  bool showMonthYearPicker = false;

  // Active picker
  PickerType activePicker = PickerType.none;

  // Repeat option (for range mode)
  String repeat = '';

  // Format helpers
  String _formatDate(DateTime date) => DateFormat('d MMM yyyy').format(date);
  String _formatTime(TimeOfDay time) {
    final dt = DateTime(0, 0, 0, time.hour, time.minute);
    return DateFormat.jm().format(dt);
  }
  String _formatMonthYear(DateTime date) => DateFormat('MMMM yyyy').format(date);

  void _togglePicker(PickerType type) {
    setState(() {
      if (activePicker == type) {
        activePicker = PickerType.none;
      } else {
        activePicker = type;
      }
      // Reset sub-picker whenever switching main picker
      showMonthYearPicker = false;

      // Set displayed month based on active picker
      if (type == PickerType.fromDate || type == PickerType.singleDate) {
        displayedMonth = DateTime(fromDate.year, fromDate.month);
      } else if (type == PickerType.toDate) {
        displayedMonth = DateTime(toDate.year, toDate.month);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize dates and times
    fromDate = widget.initialDate ?? DateTime.now();
    fromTime = widget.initialFromTime ?? TimeOfDay.now();
    toDate = widget.initialToDate ?? DateTime.now();
    toTime = widget.initialToTime ?? const TimeOfDay(hour: 17, minute: 0);

    // Initialize displayed month
    displayedMonth = DateTime(fromDate.year, fromDate.month);

    // In standalone mode, automatically show the calendar
    if (!widget.isRangePicker) {
      activePicker = PickerType.singleDate;
    }
  }

  void _toggleMonthYearPicker() {
    setState(() {
      showMonthYearPicker = !showMonthYearPicker;
    });
  }

  void _onRepeatSelected(String value) {
    setState(() {
      repeat = value;
      if (widget.onRepeatSelected != null) {
        widget.onRepeatSelected!(value);
      }
    });
  }

  void _notifyRangeChanged() {
    if (widget.onRangeChanged != null) {
      widget.onRangeChanged!(fromDate, fromTime, toDate, toTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: widget.isRangePicker ? BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD0D5DD), width: 0.5),
      ) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // For range picker mode, show the From row
          if (widget.isRangePicker) ...[
            DateTimeRow(
              label: 'From',
              date: _formatDate(fromDate),
              time: widget.showTime ? _formatTime(fromTime) : null,
              dateColor: pickedFromDate ? Colors.blue : const Color(0xFF444444),
              timeColor: pickedFromTime ? Colors.blue : const Color(0xFF444444),
              onDateTap: () => _togglePicker(PickerType.fromDate),
              onTimeTap: widget.showTime ? () => _togglePicker(PickerType.fromTime) : null,
            ),

            // Calendar for from date (only when activated)
            if (activePicker == PickerType.fromDate)
              _buildCalendar(isFrom: true),

            // Time picker for from time (only when activated)
            if (activePicker == PickerType.fromTime && widget.showTime)
              TimePicker(
                initialTime: fromTime,
                onTimeChanged: (val) {
                  setState(() {
                    fromTime = val;
                    pickedFromTime = true;

                    if (!widget.isRangePicker) {
                      // For standalone mode, we can combine date and time
                      final combinedDateTime = DateTime(
                        fromDate.year,
                        fromDate.month,
                        fromDate.day,
                        fromTime.hour,
                        fromTime.minute,
                      );
                      widget.onDateSelected?.call(combinedDateTime);
                    } else {
                      _notifyRangeChanged();
                    }
                  });
                },
              ),
          ]
          // For standalone mode, always show the calendar first
          else ...[
            // Always show the calendar in standalone mode
            _buildCalendar(isFrom: true),

            // Time section with divider if time is enabled
            if (widget.showTime) ...[
              const Divider(thickness: 0.7),
              DateTimeRow(
                label: 'Time',
                time: _formatTime(fromTime),
                timeColor: pickedFromTime ? Colors.blue : const Color(0xFF444444),
                onTimeTap: () => _togglePicker(PickerType.singleTime),
              ),

              // Time picker (only when activated)
              if (activePicker == PickerType.singleTime)
                TimePicker(
                  initialTime: fromTime,
                  onTimeChanged: (val) {
                    setState(() {
                      fromTime = val;
                      pickedFromTime = true;

                      final combinedDateTime = DateTime(
                        fromDate.year,
                        fromDate.month,
                        fromDate.day,
                        fromTime.hour,
                        fromTime.minute,
                      );
                      widget.onDateSelected?.call(combinedDateTime);
                    });
                  },
                ),

              const Divider(thickness: 0.7),
            ],
          ],

          // Only show To section and Repeat options in range picker mode
          if (widget.isRangePicker) ...[
            const Divider(thickness: 0.7),
            // To row
            DateTimeRow(
              label: 'To',
              date: _formatDate(toDate),
              time: widget.showTime ? _formatTime(toTime) : null,
              dateColor: pickedToDate ? Colors.blue : const Color(0xFF444444),
              timeColor: pickedToTime ? Colors.blue : const Color(0xFF444444),
              onDateTap: () => _togglePicker(PickerType.toDate),
              onTimeTap: widget.showTime ? () => _togglePicker(PickerType.toTime) : null,
            ),

            // Calendar for to date
            if (activePicker == PickerType.toDate)
              _buildCalendar(isFrom: false),

            // Time picker for to time
            if (activePicker == PickerType.toTime && widget.showTime)
              TimePicker(
                initialTime: toTime,
                onTimeChanged: (val) {
                  setState(() {
                    toTime = val;
                    pickedToTime = true;
                    _notifyRangeChanged();
                  });
                },
              ),

            // Only show repeat options if provided
            if (widget.repeatOptions != null && widget.repeatOptions!.isNotEmpty) ...[
              const Divider(thickness: 0.7),
              RepeatRow(
                label: 'Repeat',
                value: repeat.isEmpty ? 'None' : repeat,
                options: widget.repeatOptions!,
                selectedValue: repeat.isEmpty ? 'None' : repeat,
                onSelected: _onRepeatSelected,
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildCalendar({required bool isFrom}) {
    return Column(
      children: [
        // Month navigation header
        CalendarHeader(
          monthYearText: _formatMonthYear(displayedMonth),
          showMonthYearPicker: showMonthYearPicker,
          onToggleMonthYearPicker: _toggleMonthYearPicker,
          onPreviousMonth: () => setState(() {
            displayedMonth = DateTime(
                displayedMonth.year,
                displayedMonth.month - 1
            );
          }),
          onNextMonth: () => setState(() {
            displayedMonth = DateTime(
                displayedMonth.year,
                displayedMonth.month + 1
            );
          }),
        ),

        const SizedBox(height: 12),

        // Month-year picker shown when toggled
        if (showMonthYearPicker)
          MonthYearPicker(
            initialDate: displayedMonth,
            onDateChanged: (newDate) => setState(() {
              displayedMonth = DateTime(newDate.year, newDate.month);

              if (isFrom) {
                // Preserve the day when changing month/year
                fromDate = DateTime(
                    newDate.year,
                    newDate.month,
                    min(
                        fromDate.day,
                        DateTime(newDate.year, newDate.month + 1, 0).day
                    )
                );
                pickedFromDate = true;

                if (!widget.isRangePicker) {
                  widget.onDateSelected?.call(fromDate);
                } else {
                  _notifyRangeChanged();
                }
              } else {
                // Preserve the day when changing month/year
                toDate = DateTime(
                    newDate.year,
                    newDate.month,
                    min(
                        toDate.day,
                        DateTime(newDate.year, newDate.month + 1, 0).day
                    )
                );
                pickedToDate = true;
                _notifyRangeChanged();
              }
            }),
          )
        else
        // Calendar grid for day selection
          CalendarGrid(
            month: displayedMonth.month,
            year: displayedMonth.year,
            selected: isFrom ? fromDate : toDate,
            onDaySelected: (day) => setState(() {
              final date = DateTime(displayedMonth.year, displayedMonth.month, day);

              if (isFrom) {
                fromDate = date;
                pickedFromDate = true;

                if (!widget.isRangePicker) {
                  widget.onDateSelected?.call(fromDate);
                } else {
                  _notifyRangeChanged();
                }
              } else {
                toDate = date;
                pickedToDate = true;
                _notifyRangeChanged();
              }
            }),
          ),
      ],
    );
  }

  // Return the smaller of two integers
  int min(int a, int b) => a < b ? a : b;
}


/// Enum to track which picker is currently active
enum PickerType { none, fromDate, toDate, fromTime, toTime, singleDate, singleTime }


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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Month-year selector with dropdown
        GestureDetector(
          onTap: onToggleMonthYearPicker,
          child: Row(
            children: [
              Text(
                monthYearText,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue
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

        // Previous/next month buttons
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.blue),
              onPressed: onPreviousMonth,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Colors.blue),
              onPressed: onNextMonth,
            ),
          ],
        ),
      ],
    );
  }
}

class CalendarGrid extends StatelessWidget {
  final int month, year;
  final DateTime selected;
  final ValueChanged<int> onDaySelected;

  const CalendarGrid({
    Key? key,
    required this.month,
    required this.year,
    required this.selected,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstWeekday = DateTime(year, month, 1).weekday % 7;

    // Days of week labels
    final List<String> daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Column(
      children: [
        // Days of week header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: daysOfWeek.map((day) => Expanded(
            child: Center(
              child: Text(
                day,
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          )).toList(),
        ),
        const SizedBox(height: 8),
        // Calendar grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
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
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSel ? Colors.blue : null,
                ),
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
        ),
      ],
    );
  }
}

// File: lib/widgets/picker_widgets.dart

class PillText extends StatelessWidget {
  final String text;
  final Color color;

  const PillText(this.text, this.color, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
          color: const Color(0xFFF4F4F4),
          borderRadius: BorderRadius.circular(8)
      ),
      child: Text(
          text,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: color
          )
      ),
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
    Key? key,
    required this.label,
    this.date,
    this.time,
    this.dateColor,
    this.timeColor,
    this.onDateTap,
    this.onTimeTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          if (date != null)
            GestureDetector(
              onTap: onDateTap,
              child: PillText(date!, dateColor ?? Colors.black),
            ),
          if (date != null && time != null) const SizedBox(width: 8),
          if (time != null)
            GestureDetector(
              onTap: onTimeTap,
              child: PillText(time!, timeColor ?? Colors.black),
            ),
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

  const RepeatRow({
    Key? key,
    required this.label,
    required this.value,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final Offset offset = box.localToGlobal(Offset.zero);
        final Size size = box.size;
        final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

        // Popup menu positioned above the widget
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
            Text(
                value,
                style: const TextStyle(fontSize: 16, color: Color(0xFF444444))
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, size: 20),
          ],
        ),
      ),
    );
  }
}

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
        minimumDate: DateTime(DateTime.now().year - 5),
        maximumDate: DateTime(DateTime.now().year + 5, 12),
        onDateTimeChanged: onDateChanged,
      ),
    );
  }
}

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
              0, 0, 0,
              initialTime.hour,
              initialTime.minute
          ),
          onDateTimeChanged: (val) => onTimeChanged(TimeOfDay.fromDateTime(val)),
        ),
      ),
    );
  }
}