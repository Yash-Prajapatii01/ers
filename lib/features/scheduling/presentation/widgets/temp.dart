// Widget _buildCalendarSection() {
//   return CustomCalendarPicker(
//     displayedMonth: displayedMonth,
//     showMonthYearPicker: showMonthYearPicker,
//     isFromDatePicker: isFromDatePicker,
//     selectedDate: isFromDatePicker ? fromDate : toDate,
//     onDateSelected: (date) {
//       setState(() {
//         if (isFromDatePicker) {
//           fromDate = date;
//         } else {
//           toDate = date;
//         }
//       });
//     },
//     onToggleMonthYearPicker: _toggleMonthYearPicker,
//     onMonthYearSelected: (date) {
//       setState(() {
//         displayedMonth = date;
//         showMonthYearPicker = false;
//       });
//     },
//     onMonthChanged: (bool next) {
//       setState(() {
//         displayedMonth = DateTime(
//           displayedMonth.year,
//           displayedMonth.month + (next ? 1 : -1),
//         );
//       });
//     },
//   );
// }


// -------------------------custom calnder widegt above----------------------------?


// import 'package:flutter/material.dart';
//
// import '../../../../shared/constants/text_sizes.dart';
//
// class DateTimeSelector extends StatelessWidget {
//   final String fromDate;
//   final String fromTime;
//   final String toDate;
//   final String toTime;
//   final String repeat;
//
//   const DateTimeSelector({
//     super.key,
//     this.fromDate = '7 Jan 2025',
//     this.fromTime = '2:00 PM',
//     this.toDate = '8 Jan 2025',
//     this.toTime = '4:00 PM',
//     this.repeat = 'Week',
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//             color: const Color.fromRGBO(208, 213, 221, 1),
//             width: 0.5
//         ),
//       ),
//       child: Column(
//         children: [
//           _DateTimeRow(label: 'From', date: fromDate, time: fromTime),
//           SizedBox(height: 8,),
//           const Divider(thickness: 0.7,),
//           SizedBox(height: 8,),
//           _DateTimeRow(label: 'To', date: toDate, time: toTime),
//           SizedBox(height: 8,),
//           const Divider(thickness: 0.7,),
//           SizedBox(height: 8,),
//           _RepeatRow(label: 'Repeat', value: repeat),
//         ],
//       ),
//     );
//   }
// }
//
// class _DateTimeRow extends StatelessWidget {
//   final String label;
//   final String date;
//   final String time;
//
//   const _DateTimeRow({
//     required this.label,
//     required this.date,
//     required this.time,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Text(label, style: const TextStyle(fontSize: 16)),
//         const Spacer(),
//         _PillText(date),
//         const SizedBox(width: 8),
//         _PillText(time),
//       ],
//     );
//   }
// }
//
// class _RepeatRow extends StatelessWidget {
//   final String label;
//   final String value;
//
//   const _RepeatRow({
//     required this.label,
//     required this.value,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Text(label, style: const TextStyle(fontSize: 16)),
//         const Spacer(),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 16,
//             color: Colors.grey[500],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
//           child: Column(
//             children: [
//             Icon(Icons.keyboard_arrow_up_outlined),
//             Icon(Icons.keyboard_arrow_down_outlined)
//           ],),
//         )
//       ],
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
//       padding:  EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//       decoration: BoxDecoration(
//         color: Color.fromRGBO(244, 244, 244, 1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(
//         text,
//         style:  TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
//       ),
//     );
//   }
// }

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
//   DateTime fromDate = DateTime(2025, 1, 7);
//   TimeOfDay fromTime = TimeOfDay(hour: 14, minute: 0);
//   DateTime toDate = DateTime(2025, 1, 8);
//   TimeOfDay toTime = TimeOfDay(hour: 16, minute: 0);
//   String repeat = 'Week';
//
//   bool showCalendar = false;
//
//   void _pickTime(BuildContext context, bool isFrom) {
//     showCupertinoModalPopup(
//       context: context,
//       builder: (_) => Container(
//         height: 250,
//         color: Colors.white,
//         child: CupertinoDatePicker(
//           mode: CupertinoDatePickerMode.time,
//           initialDateTime: DateTime.now(),
//           onDateTimeChanged: (val) {
//             setState(() {
//               if (isFrom) {
//                 fromTime = TimeOfDay.fromDateTime(val);
//               } else {
//                 toTime = TimeOfDay.fromDateTime(val);
//               }
//             });
//           },
//         ),
//       ),
//     );
//   }
//
//   void _pickRepeat(BuildContext context) {
//     final options = ['Never', 'Daily', 'Week', 'Month'];
//     showModalBottomSheet(
//       context: context,
//       builder: (_) => ListView.separated(
//         shrinkWrap: true,
//         itemCount: options.length,
//         separatorBuilder: (_, __) => const Divider(height: 1),
//         itemBuilder: (_, index) => ListTile(
//           title: Text(options[index]),
//           trailing: repeat == options[index]
//               ? const Icon(Icons.check, color: Colors.blue)
//               : null,
//           onTap: () {
//             setState(() {
//               repeat = options[index];
//             });
//             Navigator.pop(context);
//           },
//         ),
//       ),
//     );
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
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//             color: const Color.fromRGBO(208, 213, 221, 1), width: 0.5),
//       ),
//       child: Column(
//         children: [
//           _DateTimeRow(
//             label: 'From',
//             date: formatDate(fromDate),
//             time: formatTime(fromTime),
//             onDateTap: () => setState(() => showCalendar = !showCalendar),
//             onTimeTap: () => _pickTime(context, true),
//           ),
//           if (showCalendar)
//             CalendarDatePicker(
//               initialDate: fromDate,
//               firstDate: DateTime(2000),
//               lastDate: DateTime(2100),
//               onDateChanged: (newDate) {
//                 setState(() => fromDate = newDate);
//               },
//             ),
//           const Divider(thickness: 0.7),
//           _DateTimeRow(
//             label: 'To',
//             date: formatDate(toDate),
//             time: formatTime(toTime),
//             onDateTap: () {}, // Add calendar for "To" if needed
//             onTimeTap: () => _pickTime(context, false),
//           ),
//           const Divider(thickness: 0.7),
//           _RepeatRow(
//             label: 'Repeat',
//             value: repeat,
//             onTap: () => _pickRepeat(context),
//           ),
//         ],
//       ),
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
//             const Icon(Icons.keyboard_arrow_down),
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
//   DateTime fromDate = DateTime(2025, 1, 7);
//   TimeOfDay fromTime = TimeOfDay(hour: 14, minute: 0);
//   DateTime toDate = DateTime(2025, 1, 8);
//   TimeOfDay toTime = TimeOfDay(hour: 16, minute: 0);
//   String repeat = '';
//
//   bool showCalendar = false;
//   bool showMonthYearPicker = false;
//   bool showTimePicker = false;
//   bool isFromTimePicker = true;
//   bool isFromDatePicker = true; // Track if we're picking From or To date
//   DateTime displayedMonth =
//   DateTime.now(); // To match the image showing June 2025
//
//   void _toggleTimePicker(bool isFrom) {
//     setState(() {
//       showCalendar = false;
//       showMonthYearPicker = false;
//       showTimePicker = !showTimePicker;
//       isFromTimePicker = isFrom;
//     });
//   }
//
//   void showCustomMenu({
//     required BuildContext triggerContext,
//     required BuildContext parentContext,
//     required List<String> options,
//     required String selectedValue,
//     required void Function(String selected) onSelected,
//   }) async
//   {
//     final RenderBox button = triggerContext.findRenderObject() as RenderBox;
//     final RenderBox overlay =
//     Overlay
//         .of(parentContext)
//         .context
//         .findRenderObject() as RenderBox;
//     final Offset position = button.localToGlobal(
//       Offset.zero,
//       ancestor: overlay,
//     );
//
//     final selected = await showMenu<String>(
//       context: parentContext,
//       position: RelativeRect.fromLTRB(
//           250,
//           position.dy + button.size.height,
//           20,
//           position.dx + button.size.height,
//       ),
//       items:
//       options.map((option) {
//         return PopupMenuItem<String>(
//           value: option,
//           child: Row(
//             children: [
//               Text(
//                 option,
//                 style: TextStyle(
//                   fontWeight:
//                   option == selectedValue
//                       ? FontWeight.w500
//                       : FontWeight.normal,
//                 ),
//               ),
//               const Spacer(),
//               if (option == selectedValue)
//                 const Icon(Icons.check, color: Colors.blue),
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
//       showCalendar = !showCalendar;
//       showMonthYearPicker = false;
//       showTimePicker = false;
//       isFromDatePicker = isFrom;
//       displayedMonth = isFrom ? fromDate : toDate;
//     });
//   }
//
//   void _toggleMonthYearPicker() {
//     setState(() {
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
//         children: [
//           _DateTimeRow(
//             label: 'From',
//             date: formatDate(fromDate),
//             time: formatTime(fromTime),
//             onDateTap: () => _toggleCalendar(isFrom: true),
//             onTimeTap: () => _toggleTimePicker(true),
//           ),
//           if (showCalendar) _buildCalendarSection(),
//           if (showTimePicker) _buildTimePicker(),
//           const Divider(thickness: 0.7),
//           _DateTimeRow(
//             label: 'To',
//             date: formatDate(toDate),
//             time: formatTime(toTime),
//             onDateTap: () => _toggleCalendar(isFrom: false),
//             onTimeTap: () => _toggleTimePicker(false),
//           ),
//           const Divider(thickness: 0.7),
//           _RepeatRow(
//             label: 'Repeat',
//             value: repeat,
//             onTap:
//                 () =>
//                 showCustomMenu(
//                   triggerContext: context,
//                   parentContext: this.context,
//                   // usually from your State class
//                   options: [
//                     'None',
//                     'Daily',
//                     'Weekly',
//                     'Monthly',
//                     'Yearly',
//                     'Custom',
//                   ],
//                   selectedValue: repeat,
//                   onSelected: (selected) {
//                     setState(() {
//                       repeat = selected;
//                     });
//                   },
//                 ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTimePicker() {
//     return SizedBox(
//       height: 200,
//       child: CupertinoDatePicker(
//         mode: CupertinoDatePickerMode.time,
//         initialDateTime: DateTime(
//           2025,
//           1,
//           1,
//           isFromTimePicker ? fromTime.hour : toTime.hour,
//           isFromTimePicker ? fromTime.minute : toTime.minute,
//         ),
//         onDateTimeChanged: (val) {
//           setState(() {
//             if (isFromTimePicker) {
//               fromTime = TimeOfDay.fromDateTime(val);
//             } else {
//               toTime = TimeOfDay.fromDateTime(val);
//             }
//           });
//         },
//       ),
//     );
//   }
//
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
//                   const Icon(Icons.arrow_drop_down, color: Colors.blue),
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
//         if (showMonthYearPicker) _buildMonthYearPicker() else
//           _buildCalendar(),
//       ],
//     );
//   }
//
//   Widget _buildMonthYearPicker() {
//     // Generate year list (from current year - 5 to current year + 5)
//     final int currentYear = DateTime
//         .now()
//         .year;
//     final List<int> years = List.generate(10, (i) => currentYear + i - 2);
//
//     // Generate months
//     final List<String> months = List.generate(
//       12,
//           (i) => DateFormat.MMMM().format(DateTime(0, i + 1)),
//     );
//
//     return SizedBox(
//       height: 250,
//       child: Row(
//         children: [
//           // Months column
//           Expanded(
//             child: ListView.builder(
//               itemCount: months.length,
//               itemBuilder: (context, index) {
//                 final bool isSelected = index + 1 == displayedMonth.month;
//                 return Container(
//                   color: isSelected ? Colors.grey[200] : null,
//                   child: ListTile(
//                     title: Center(
//                       child: Text(
//                         months[index],
//                         style: TextStyle(
//                           color: isSelected ? Colors.black : Colors.grey[400],
//                           fontWeight:
//                           isSelected ? FontWeight.bold : FontWeight.normal,
//                         ),
//                       ),
//                     ),
//                     onTap: () => _selectMonth(index + 1, displayedMonth.year),
//                   ),
//                 );
//               },
//             ),
//           ),
//           // Years column
//           Expanded(
//             child: ListView.builder(
//               itemCount: years.length,
//               itemBuilder: (context, index) {
//                 final int year = years[index];
//                 final bool isSelected = year == displayedMonth.year;
//                 return Container(
//                   color: isSelected ? Colors.grey[200] : null,
//                   child: ListTile(
//                     title: Center(
//                       child: Text(
//                         year.toString(),
//                         style: TextStyle(
//                           color: isSelected ? Colors.black : Colors.grey[400],
//                           fontWeight:
//                           isSelected ? FontWeight.bold : FontWeight.normal,
//                         ),
//                       ),
//                     ),
//                     onTap: () => _selectMonth(displayedMonth.month, year),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCalendar() {
//     final daysInMonth =
//         DateTime(displayedMonth.year, displayedMonth.month + 1, 0).day;
//     final firstDayOfWeek =
//         DateTime(displayedMonth.year, displayedMonth.month, 1).weekday % 7;
//
//     // Headers for the days of the week
//     final dayHeaders = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
//
//     return Column(
//       children: [
//         // Day headers
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children:
//           dayHeaders
//               .map(
//                 (day) =>
//                 SizedBox(
//                   width: 30,
//                   child: Center(
//                     child: Text(
//                       day,
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[500],
//                       ),
//                     ),
//                   ),
//                 ),
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
//               return const SizedBox
//                   .shrink(); // Empty space for days before the 1st of the month
//             }
//
//             final day = index - firstDayOfWeek + 1;
//             final date = DateTime(
//               displayedMonth.year,
//               displayedMonth.month,
//               day,
//             );
//             DateTime compareDate = isFromDatePicker ? fromDate : toDate;
//             final isSelected =
//                 date.year == compareDate.year &&
//                     date.month == compareDate.month &&
//                     date.day == compareDate.day;
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
//                       fontWeight:
//                       isSelected ? FontWeight.bold : FontWeight.normal,
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
//             const Icon(Icons.keyboard_arrow_down),
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

//------------------------------v---------------------------------------
// Widget _buildMonthYearPicker() {
//   return SizedBox(
//     height: 250,
//     child: CupertinoDatePicker(
//       mode: CupertinoDatePickerMode.monthYear,
//       initialDateTime: widget.displayedMonth,
//       minimumDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
//       maximumDate: DateTime.now().add(const Duration(days: 365 * 10)),
//       onDateTimeChanged: (val) {
//         widget.onMonthYearSelected(val);
//       },
//     ),
//   );
// }
// Widget _buildMonthYearPicker() {
//   // Generate year list (from current year - 5 to current year + 5)
//   final int currentYear = DateTime.now().year;
//   final List<int> years = List.generate(10, (i) => currentYear + i - 2);
//
//   // Generate months
//   final List<String> months = List.generate(
//     12,
//         (i) => DateFormat.MMMM().format(DateTime(0, i + 1)),
//   );
//
//   return SizedBox(
//     height: 250,
//     child: Row(
//       children: [
//         // Months column
//         Expanded(
//           child: ListView.builder(
//             itemCount: months.length,
//             itemBuilder: (context, index) {
//               final bool isSelected = index + 1 == displayedMonth.month;
//               return Container(
//                 color: isSelected ? Colors.grey[200] : null,
//                 child: ListTile(
//                   title: Center(
//                     child: Text(
//                       months[index],
//                       style: TextStyle(
//                         color: isSelected ? Colors.black : Colors.grey[400],
//                         fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                       ),
//                     ),
//                   ),
//                   onTap: () => _selectMonth(index + 1, displayedMonth.year),
//                 ),
//               );
//             },
//           ),
//         ),
//         // Years column
//         Expanded(
//           child: ListView.builder(
//             itemCount: years.length,
//             itemBuilder: (context, index) {
//               final int year = years[index];
//               final bool isSelected = year == displayedMonth.year;
//               return Container(
//                 color: isSelected ? Colors.grey[200] : null,
//                 child: ListTile(
//                   title: Center(
//                     child: Text(
//                       year.toString(),
//                       style: TextStyle(
//                         color: isSelected ? Colors.black : Colors.grey[400],
//                         fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                       ),
//                     ),
//                   ),
//                   onTap: () => _selectMonth(displayedMonth.month, year),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     ),
//   );
// }