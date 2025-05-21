import 'package:ers_linux/features/scheduling/presentation/widgets/UnifiedCalender/widgets/PickerType.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../CustomCupertinoPicker.dart';
import '../PillText.dart';
import 'UI/DateTimeRow.dart';
import 'UI/EndRepeatRow.dart';
import 'UI/RepeatRow.dart';
import 'widgets/CalenderGrid.dart';
import 'widgets/CalenderHeader.dart';
import 'widgets/MonthPicker.dart';
import 'widgets/TimePicker.dart';

class UnifiedCalendar extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? initialToDate;
  final TimeOfDay? initialFromTime;
  final TimeOfDay? initialToTime;
  final bool showTime;
  final bool isRangePicker;
  final ValueChanged<DateTime>? onDateSelected;
  final Function(
    DateTime fromDate,
    TimeOfDay fromTime,
    DateTime toDate,
    TimeOfDay toTime,
  )?
  onRangeChanged;
  final ValueChanged<String>? onRepeatSelected;
  final List<String>? repeatOptions;
  final bool showWeekdayLabels;
  final bool topheader;
  final bool remmoveInternalPadding;

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
    this.showWeekdayLabels = true,
    this.topheader = true,
    this.remmoveInternalPadding = false,
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
  List<String> endRepeatOption = ['After', 'On Date'];

  // Selection flags for coloring
  bool pickedFromDate = false;
  bool pickedFromTime = false;
  bool pickedToDate = false;
  bool pickedToTime = false;
  bool pickedOnDate = false;

  // Calendar display state
  late DateTime displayedMonth;
  bool showMonthYearPicker = false;
  DateTime AfterDate = DateTime.now();

  // Active picker
  PickerType activePicker = PickerType.none;

  // Repeat option (for range mode)
  String repeatRow = '';

  String endRepeat = '';
  String afterRow = '1';

  bool isActiveCalender = false;
  bool isAfterSlider = false;

  // Format helpers
  String _formatDate(DateTime date) => DateFormat('d MMM yyyy').format(date);

  String _formatTime(TimeOfDay time) {
    final dt = DateTime(0, 0, 0, time.hour, time.minute);
    return DateFormat.jm().format(dt);
  }

  String _formatMonthYear(DateTime date) =>
      DateFormat('MMMM yyyy').format(date);

  void _togglePicker(PickerType type) {
    setState(() {
      if (activePicker == type) {
        activePicker = PickerType.none;
      } else {
        activePicker = type;
        // Mark as picked immediately upon opening the picker
        switch (type) {
          case PickerType.fromDate:
            pickedFromDate = true;
            break;
          case PickerType.fromTime:
            pickedFromTime = true;
            break;
          case PickerType.toDate:
            pickedToDate = true;
            break;
          case PickerType.toTime:
            pickedToTime = true;
            break;
          case PickerType.singleDate:
            pickedFromDate = true;
            break;
          case PickerType.singleTime:
            pickedFromTime = true;
            break;
          default:
            break;
        }

        // Set displayed month
        if (type == PickerType.fromDate || type == PickerType.singleDate) {
          displayedMonth = DateTime(fromDate.year, fromDate.month);
        } else if (type == PickerType.toDate) {
          displayedMonth = DateTime(toDate.year, toDate.month);
        }

        // Hide month-year picker when switching pickers
        showMonthYearPicker = false;
      }
    });
  }


  // void _togglePicker(PickerType type) {
  //   setState(() {
  //     if (activePicker == type) {
  //       activePicker = PickerType.none;
  //
  //     } else {
  //       activePicker = type;
  //     }
  //     // Reset sub-picker whenever switching main picker
  //     showMonthYearPicker = false;
  //
  //     // Set displayed month based on active picker
  //     if (type == PickerType.fromDate || type == PickerType.singleDate) {
  //       displayedMonth = DateTime(fromDate.year, fromDate.month);
  //     } else if (type == PickerType.toDate) {
  //       displayedMonth = DateTime(toDate.year, toDate.month);
  //     }
  //   });
  // }

  List<int> _getOptionsBasedOnRepeat(String repeat) {
    switch (repeat) {
      case 'Daily':
        return List.generate(90, (i) => i + 1);
      case 'Weekly':
        return List.generate(52, (i) => i + 1);
      case 'Monthly':
        return List.generate(24, (i) => i + 1);
      case 'Yearly':
        return List.generate(5, (i) => i + 1);
      default:
        // Default to daily options if no repeat is selected
        return List.generate(90, (i) => i + 1);
    }
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
      repeatRow = value;
      if (widget.onRepeatSelected != null) {
        widget.onRepeatSelected!(value);
      }
    });
  }

  void _onEndRepeatSelected(String value) {
    setState(() {
      endRepeat = value;
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
      padding:
          widget.remmoveInternalPadding ? EdgeInsets.zero : EdgeInsets.symmetric(horizontal: 15.5, vertical: 11.5),
      decoration:
          widget.isRangePicker && !widget.remmoveInternalPadding
              ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFCFCFCF), width: 0.5),
              )
              : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // For range picker mode, show the From row
          if (widget.isRangePicker) ...[
            DateTimeRow(
              label: 'From',
              date: _formatDate(fromDate),
              time: widget.showTime ? _formatTime(fromTime) : null,
              dateColor: pickedFromDate ? Colors.blue : const Color(0xFF333333),
              timeColor: pickedFromTime ? Colors.blue : const Color(0xFF333333),
              onDateTap: () => _togglePicker(PickerType.fromDate),
              onTimeTap:
                  widget.showTime
                      ? () => _togglePicker(PickerType.fromTime)
                      : null,
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
              const Divider(
                thickness: 0.7,
                color: Color.fromRGBO(102, 112, 133, 0.2),
              ),
              DateTimeRow(
                label: 'Time',
                time: _formatTime(fromTime),
                timeColor:
                    pickedFromTime ? Colors.blue : const Color(0xff333333),
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

              const Divider(
                thickness: 0.7,
                color: Color.fromRGBO(102, 112, 133, 0.2),
              ),
            ],
          ],

          // Only show To section and Repeat options in range picker mode
          if (widget.isRangePicker) ...[
            const Divider(
              height: 1,
              thickness: 0.7,
              color: Color.fromRGBO(102, 112, 133, 0.2),
            ),
            // To row
            DateTimeRow(
              label: 'To',
              date: _formatDate(toDate),
              time: widget.showTime ? _formatTime(toTime) : null,
              dateColor: pickedToDate ? Colors.blue : const Color(0xFF333333),
              timeColor: pickedToTime ? Colors.blue : const Color(0xFF333333),
              onDateTap: () => _togglePicker(PickerType.toDate),
              onTimeTap:
                  widget.showTime
                      ? () => _togglePicker(PickerType.toTime)
                      : null,
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
            if (widget.repeatOptions != null &&
                widget.repeatOptions!.isNotEmpty) ...[
              const Divider(
                height: 1,
                thickness: 0.7,
                color: Color.fromRGBO(102, 112, 133, 0.2),
              ),
              RepeatRow(
                label: 'Repeat',
                value: repeatRow.isEmpty ? '' : repeatRow,
                options: widget.repeatOptions!,
                selectedValue: repeatRow.isEmpty ? '' : repeatRow,
                onSelected: _onRepeatSelected,
              ),
            ],
            if (repeatRow.isNotEmpty &&
                repeatRow != 'None' &&
                repeatRow != 'Custom') ...[
              const Divider(
                height: 1,
                thickness: 0.7,
                color: Color.fromRGBO(102, 112, 133, 0.2),
              ),
              EndRepeatRow(
                label: 'End Repeat',
                value: endRepeat.isEmpty ? '' : endRepeat,
                options: endRepeatOption,
                selectedValue: endRepeat.isEmpty ? '' : endRepeat,
                onSelected: _onEndRepeatSelected,
              ),
            ],
            if (endRepeat == 'After' && repeatRow != 'Custom' && repeatRow != 'None') ...[
              const Divider(
                height: 1,
                thickness: 0.7,
                color: Color.fromRGBO(102, 112, 133, 0.2),
              ),
              Container(
                height: 40,
                padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                child: Row(
                  children: [
                    Text('After',style: TextStyle(
                      fontFamily: 'Inter'
                    ),),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isAfterSlider = !isAfterSlider;
                        });
                        print(isAfterSlider);
                      },
                      child: PillText(width:38,height: 36, afterRow, Color.fromRGBO(39, 39, 39, 1) ,radius: 8, isCalender: false,),
                    ),
                  ],
                ),
              ),

              // This is the key change - move the picker inside the After section
              if (isAfterSlider) ...[
                SizedBox(height: 4,),
                const Divider(
                  height: 1,
                  thickness: 0.7,
                  color: Color.fromRGBO(102, 112, 133, 0.2),
                ),
                Center(
                  child: CustomCupertinoPicker(
                    singleColumnOptions: _getOptionsBasedOnRepeat(repeatRow),
                    onSingleColumnSelected: (date) {
                      setState(() {
                        // Add setState here
                        afterRow = date.toString();
                      });
                    },
                  ),
                ),
              ],

            ],
            // Then, the On Date section without the CustomCupertinoPicker
            if (endRepeat == 'On Date' && repeatRow != 'Custom' && repeatRow != 'None') ...[
              const Divider(
                height: 1,
                thickness: 0.7,
                color: Color.fromRGBO(102, 112, 133, 0.2),
              ),
              // SizedBox(height: 4),
              Container(
                height: 40,
                padding: const EdgeInsets.fromLTRB(0,4,0,0),
                child: Row(
                  children: [
                    Text('On Date', style: TextStyle(
                      fontFamily: 'Inter'
                    ),),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isActiveCalender = !isActiveCalender;
                          if (isActiveCalender) {
                            pickedOnDate = true;
                          }
                        });
                      },
                      child: PillText(
                        //todo we have to make the padding and sizing work good PillText have some fault here !!
                        width: 128,
                        // height: 48,
                        radius: 8,
                        (DateFormat('d MMMM y').format(AfterDate).toString()),
                        (pickedOnDate || isActiveCalender) ? Colors.blue : Colors.black,
                        isCalender: true,
                      ),
                    ),
                  ],
                ),
              ),
              if (isActiveCalender) ...[
                SizedBox(height: 4,),
                const Divider(
                  height: 1,
                  thickness: 0.7,
                  color: Color.fromRGBO(102, 112, 133, 0.2),
                ),
                UnifiedCalendar(
                  initialDate: DateTime.now(),
                  onDateSelected: (date) {
                    setState(() {
                      pickedOnDate = true;
                      AfterDate = date;
                    });
                  },
                  remmoveInternalPadding: true,
                ),
              ],
            ],
            // if (endRepeat == 'After') ...[
            //   const Divider(
            //     thickness: 0.7,
            //     color: Color.fromRGBO(102, 112, 133, 0.2),
            //   ),
            //   SizedBox(height: 8),
            //   Row(
            //     children: [
            //       Text('After'),
            //       Spacer(),
            //       GestureDetector(
            //         onTap: () {
            //           setState(() {
            //             isAfterSlider = !isAfterSlider;
            //           });
            //           print(isAfterSlider);
            //         },
            //         child: PillText( afterRow, Colors.white),
            //       ),
            //     ],
            //   ),
            // ],
            // if (endRepeat == 'On Date') ...[
            //   const Divider(
            //     thickness: 0.7,
            //     color: Color.fromRGBO(102, 112, 133, 0.2),
            //   ),
            //   SizedBox(height: 8),
            //   Row(
            //     children: [
            //       Text('On Date'),
            //       Spacer(),
            //       GestureDetector(
            //         onTap: () {
            //           setState(() {
            //             isActiveCalender = !isActiveCalender;
            //           });
            //           // CalendarGrid(month: 5, year: 2025, selected: DateTime.now(), onDaySelected: (int value) {  },);
            //         },
            //         child: PillText(
            //           (DateFormat(
            //             //todo Solve the problem of the Text Color
            //             'd MMMM y',
            //           ).format(AfterDate).toString()),
            //           Colors.blue,
            //           isCalender: true,
            //         ),
            //       ),
            //     ],
            //   ),
            //   if (isActiveCalender) ...[
            //     const Divider(
            //       thickness: 0.7,
            //       color: Color.fromRGBO(102, 112, 133, 0.2),
            //     ),
            //     UnifiedCalendar(
            //       initialDate: DateTime.now(),
            //       onDateSelected: (date) {
            //         setState(() {
            //           AfterDate = date;
            //         });
            //       },
            //     ),
            //   ],
            //   if(isAfterSlider) ...[
            //     const Divider(
            //       thickness: 0.7,
            //       color: Color.fromRGBO(102, 112, 133, 0.2),
            //     ),
            //     CustomCupertinoPicker(
            //       singleColumnOptions: List.generate(90, (i) => i + 1),
            //       onSingleColumnSelected: (date){
            //         afterRow = date;
            //       },
            //     )
            //   ]
            // ],
          ],
        ],
      ),
    );
  }

  Widget _buildCalendar({required bool isFrom}) {
    return Column(
      children: [
        // Month navigation header
        if (widget.topheader)
          CalendarHeader(
            monthYearText: _formatMonthYear(displayedMonth),
            showMonthYearPicker: showMonthYearPicker,
            onToggleMonthYearPicker: _toggleMonthYearPicker,
            onPreviousMonth:
                () => setState(() {
                  displayedMonth = DateTime(
                    displayedMonth.year,
                    displayedMonth.month - 1,
                  );

                }),
            onNextMonth:
                () => setState(() {
                  displayedMonth = DateTime(
                    displayedMonth.year,
                    displayedMonth.month + 1,
                  );
                }),
          ),

        const SizedBox(height: 12),

        // Month-year picker shown when toggled
        if (showMonthYearPicker)
          MonthYearPicker(
            // key: ValueKey(displayedMonth.toIso8601String()), //it is for syncing the Picker with < & >
            initialDate: displayedMonth,
            onDateChanged:
                (newDate) => setState(() {
                  displayedMonth = DateTime(newDate.year, newDate.month);

                  if (isFrom) {
                    // Preserve the day when changing month/year
                    fromDate = DateTime(
                      newDate.year,
                      newDate.month,
                      min(
                        fromDate.day,
                        DateTime(newDate.year, newDate.month + 1, 0).day,
                      ),
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
                        DateTime(newDate.year, newDate.month + 1, 0).day,
                      ),
                    );
                    pickedToDate = true;
                    _notifyRangeChanged();
                  }
                }),
          )
        else
          // Calendar grid for day selection
          CalendarGrid(
            showWeekdayLabels: widget.showWeekdayLabels,
            month: displayedMonth.month,
            year: displayedMonth.year,
            selected: isFrom ? fromDate : toDate,
            onDaySelected:
                (day) => setState(() {
                  final date = DateTime(
                    displayedMonth.year,
                    displayedMonth.month,
                    day,
                  );
                  pickedOnDate = true;
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

/*
It is For the syncing the < & > with the time Picker
class MonthYearPicker extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;

  const MonthYearPicker({
    Key? key,
    required this.initialDate,
    required this.onDateChanged,
  }) : super(key: key);

  @override
  State<MonthYearPicker> createState() => _MonthYearPickerState();
}

class _MonthYearPickerState extends State<MonthYearPicker> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  @override
  void didUpdateWidget(covariant MonthYearPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialDate != widget.initialDate) {
      setState(() {
        selectedDate = widget.initialDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.monthYear,
        initialDateTime: selectedDate,
        minimumDate: DateTime(DateTime.now().year - 100),
        maximumDate: DateTime(2099, 12),
        onDateTimeChanged: (newDate) {
          widget.onDateChanged(newDate);
          setState(() => selectedDate = newDate);
        },
      ),
    );
  }
}
 */





