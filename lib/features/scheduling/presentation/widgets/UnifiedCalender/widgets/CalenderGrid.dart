// import 'package:flutter/material.dart';
// class CalendarGrid extends StatelessWidget {
//   final int month, year;
//   final DateTime selected;
//   final ValueChanged<int> onDaySelected;
//   final bool weekdaylabel;
//
//   const CalendarGrid({
//     Key? key,
//     required this.month,
//     required this.year,
//     required this.selected,
//     required this.onDaySelected,
//     this.weekdaylabel = true,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final daysInMonth = DateTime(year, month + 1, 0).day;
//     final firstWeekday = DateTime(year, month, 1).weekday % 7;
//
//     // Days of week labels
//     final List<String> daysOfWeek = [
//       'SUN',
//       'MON',
//       'TUE',
//       'WED',
//       'THU',
//       'FRI',
//       'SAT',
//     ];
//     return Column(
//       children: [
//         // Days of week header row
//         if (weekdaylabel) ...[
//           Row(
//             children:
//             daysOfWeek
//                 .map(
//                   (day) => Expanded(
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     day,
//                     style: const TextStyle(
//                       color: Color.fromRGBO(60, 60, 67, 0.3),
//                       fontWeight: FontWeight.w600,
//                       fontSize: 13,
//                     ),
//                   ),
//                 ),
//               ),
//             )
//                 .toList(),
//           ),
//
//           // Row(
//           //   mainAxisAlignment: MainAxisAlignment.spaceAround,
//           //   children:
//           //       daysOfWeek
//           //           .map(
//           //             (day) => Expanded(
//           //               child: Center(
//           //                 child: Text(
//           //                   day,
//           //                   style: const TextStyle(
//           //                     color: Color.fromRGBO(60, 60, 67, 0.3),
//           //                     fontWeight: FontWeight.w600,
//           //                     fontSize: 13,
//           //                   ),
//           //                 ),
//           //               ),
//           //             ),
//           //           )
//           //           .toList(),
//           // ),
//           // const SizedBox(height: 8),
//         ],
//         // Calendar grid
//         GridView.builder(
//           padding: EdgeInsets.zero,
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 7,
//             childAspectRatio: 1,
//           ),
//           itemCount: firstWeekday + daysInMonth,
//           itemBuilder: (context, index) {
//             if (index < firstWeekday) return const SizedBox.shrink();
//
//             final day = index - firstWeekday + 1;
//             final isSel = selected.year == year &&
//                 selected.month == month &&
//                 selected.day == day;
//
//             final columnIndex = index % 7;
//
//             // Dynamic margin to prevent content from looking misaligned
//             final margin = EdgeInsets.only(
//               top: 2,
//               bottom: 2,
//               left: columnIndex == 0 ? 0 : 2,
//               right: columnIndex == 6 ? 0 : 2,
//             );
//
//             // Apply offset only if selected and at the edge
//             final offsetX = isSel
//                 ? (columnIndex == 0
//                 ? -12.0
//                 : columnIndex == 6
//                 ? 12.0
//                 : 0.0)
//                 : 0.0;
//
//             // final columnIndex = index % 7;
//
//             // Determine alignment based on column
//             final alignment = (columnIndex == 0 || columnIndex == 6)
//                 ? Alignment.centerLeft
//                 : Alignment.center;
//
//             return GestureDetector(
//               onTap: () => onDaySelected(day),
//               child: Transform.translate(
//                 offset: Offset(offsetX, 0),
//                 child: Container(
//                   width: 32,
//                   height: 32,
//                   // margin: margin,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: isSel ? const Color(0xFF1C79D4) : null,
//                   ),
//                   alignment: alignment,
//                   child: Text(
//                     '$day',
//                     style: TextStyle(
//                       color: isSel ? Colors.white : Colors.black,
//                     ),
//                   ),
//                 ),
//               ),
//             );
//
//           },
//         ),
//
//         // GridView.builder(
//         //   padding: EdgeInsets.zero,
//         //   shrinkWrap: true,
//         //   physics: const NeverScrollableScrollPhysics(),
//         //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         //     crossAxisCount: 7,
//         //     childAspectRatio: 1,
//         //   ),
//         //   itemCount: firstWeekday + daysInMonth,
//         //   itemBuilder: (context, index) {
//         //     if (index < firstWeekday) return const SizedBox.shrink();
//         //     final day = index - firstWeekday + 1;
//         //     final isSel =
//         //         selected.year == year &&
//         //             selected.month == month &&
//         //             selected.day == day;
//         //
//         //     final columnIndex = index % 7;
//         //     final margin = EdgeInsets.only(
//         //       top: 2,
//         //       bottom: 2,
//         //       left: columnIndex == 0 ? 0 : 2,
//         //       right: columnIndex == 6 ? 0 : 2,
//         //     );
//         //
//         //     return GestureDetector(
//         //       onTap: () => onDaySelected(day),
//         //       child: Transform.translate(
//         //         offset: Offset(isSel ? -12.0 : 0.0, 0),
//         //         child: Container(
//         //           width: 32,
//         //           height: 32,
//         //           margin: margin,
//         //           decoration: BoxDecoration(
//         //             shape: BoxShape.circle,
//         //             color: isSel ? const Color(0xFF1C79D4) : null,
//         //           ),
//         //           alignment: Alignment.center, // keeps the day number centered in the circle
//         //           child: Text(
//         //             '$day',
//         //             style: TextStyle(
//         //               color: isSel ? Colors.white : Colors.black,
//         //             ),
//         //           ),
//         //         ),
//         //       ),
//         //     );
//         //
//         //     // return GestureDetector(
//         //     //   onTap: () => onDaySelected(day),
//         //     //   child: Container(
//         //     //     width: 32,
//         //     //     height: 32,
//         //     //     margin: margin,
//         //     //     decoration: BoxDecoration(
//         //     //       shape: BoxShape.circle,
//         //     //       color: isSel ? Color.fromRGBO(28, 121, 212, 1) : null,
//         //     //     ),
//         //     //     child: Align(
//         //     //       alignment: Alignment.centerLeft,
//         //     //       child: Text(
//         //     //         '$day',
//         //     //         style: TextStyle(
//         //     //           color: isSel ? Colors.white : Colors.black,
//         //     //           // fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
//         //     //         ),
//         //     //       ),
//         //     //     ),
//         //     //   ),
//         //     // );
//         //   },
//         // ),
//       ],
//     );
//   }
// }
// -----V----------------------------
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
//
// class CalendarGrid extends StatelessWidget {
//   final int month, year;
//   final DateTime selected;
//   final ValueChanged<int> onDaySelected;
//   final bool showWeekdayLabels;
//
//   const CalendarGrid({
//     Key? key,
//     required this.month,
//     required this.year,
//     required this.selected,
//     required this.onDaySelected,
//     this.showWeekdayLabels = true,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // Number of days in the month
//     final daysInMonth = DateTime(year, month + 1, 0).day;
//
//     // Calculate the index of the first weekday (Sunday = 0, Monday = 1, ...)
//     final firstWeekday = (DateTime(year, month, 1).weekday % 7);
//
//     // Days of week labels starting from Sunday
//     final daysOfWeek = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
//
//     return Column(
//       children: [
//         if (showWeekdayLabels)
//           Padding(
//             padding: const EdgeInsets.only(bottom: 6.0, top: 4.0),
//             child: Row(
//               children: daysOfWeek
//                   .asMap()
//                   .entries
//                   .map(
//                     (entry) {
//                   final index = entry.key;
//                   final day = entry.value;
//                   // Apply bleeding offset for weekday labels on extremes
//                   final offsetX = index == 0 ? -12.0 : (index == 6 ? 12.0 : 0.0);
//                   return Expanded(
//                     child: Transform.translate(
//                       offset: Offset(offsetX, 0),
//                       child: Center(
//                         child: Text(
//                           day,
//                           style: const TextStyle(
//                             color: Colors.grey,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 11,
//                             letterSpacing: 0.2,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               )
//                   .toList(),
//             ),
//           ),
//         GridView.builder(
//           padding: const EdgeInsets.symmetric(horizontal: 0.0),
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 7,
//             childAspectRatio: 1.0,
//             crossAxisSpacing: 0,
//             mainAxisSpacing: 10,
//           ),
//           itemCount: firstWeekday + daysInMonth,
//           itemBuilder: (context, index) {
//             if (index < firstWeekday) return const SizedBox.shrink();
//
//             final day = index - firstWeekday + 1;
//             final isSelected = selected.year == year &&
//                 selected.month == month &&
//                 selected.day == day;
//
//             // Calculate column index for bleeding
//             final columnIndex = index % 7;
//             final offsetX = columnIndex == 0 ? -12.0 : (columnIndex == 6 ? 12.0 : 0.0);
//
//             return GestureDetector(
//               onTap: () => onDaySelected(day),
//               child: Transform.translate(
//                 offset: Offset(offsetX, 0),
//                 child: Container(
//                   alignment: Alignment.center,
//                   child: Container(
//                     width: 32,
//                     height: 32,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: isSelected ?  Colors.blue : Colors.transparent,
//                     ),
//                     alignment: Alignment.center,
//                     child: Text(
//                       '$day',
//                       style: TextStyle(
//                         color: isSelected ? Colors.white : Colors.black87,
//                         fontWeight: FontWeight.w400,
//                         fontSize: 16,
//                       ),
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



// -------------------------vv
import 'package:flutter/material.dart';

class CalendarGrid extends StatelessWidget {
  final int month, year;
  final DateTime selected;
  final ValueChanged<int> onDaySelected;
  final bool showWeekdayLabels;

  const CalendarGrid({
    Key? key,
    required this.month,
    required this.year,
    required this.selected,
    required this.onDaySelected,
    this.showWeekdayLabels = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Number of days in the month
    final daysInMonth = DateTime(year, month + 1, 0).day;

    // Calculate the index of the first weekday (Sunday = 0, Monday = 1, ...)
    final firstWeekday = (DateTime(year, month, 1).weekday % 7);

    // Days of week labels starting from Sunday
    final daysOfWeek = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

    return Column(
      children: [
        if (showWeekdayLabels)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0, top: 2.0),
            child: Row(
              children: daysOfWeek.asMap().entries.map((entry) {
                final index = entry.key;
                final day = entry.value;
                // Apply bleeding offset for weekday labels on extremes
                final offsetX = index == 0 ? -12.0 : (index == 6 ? 12.0 : 0.0);
                return Expanded(
                  child: Transform.translate(
                    offset: Offset(offsetX, 0),
                    child: Center(
                      child: Text(
                        day,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.0, // Adjusted to ensure tight fit
            crossAxisSpacing: 0,
            mainAxisSpacing: 4, // Reduced to minimize vertical space
          ),
          itemCount: firstWeekday + daysInMonth,
          itemBuilder: (context, index) {
            if (index < firstWeekday) return const SizedBox.shrink();

            final day = index - firstWeekday + 1;
            final isSelected = selected.year == year &&
                selected.month == month &&
                selected.day == day;

            // Calculate column index for bleeding
            final columnIndex = index % 7;
            final offsetX = columnIndex == 0 ? -12.0 : (columnIndex == 6 ? 12.0 : 0.0);

            return GestureDetector(
              onTap: () => onDaySelected(day),
              child: Transform.translate(
                offset: Offset(offsetX, 0),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Colors.blue : Colors.transparent,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$day',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
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
// class CalendarGrid extends StatelessWidget {
//   final int month, year;
//   final DateTime selected;
//   final ValueChanged<int> onDaySelected;
//   final bool showWeekdayLabels;
//
//   const CalendarGrid({
//     Key? key,
//     required this.month,
//     required this.year,
//     required this.selected,
//     required this.onDaySelected,
//     this.showWeekdayLabels = true,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // Number of days in the month
//     final daysInMonth = DateTime(year, month + 1, 0).day;
//
//     // Calculate the index of the first weekday (Sunday = 0, Monday = 1, ...)
//     final firstWeekday = (DateTime(year, month, 1).weekday % 7);
//
//     // Days of week labels starting from Sunday
//     final daysOfWeek = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
//
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         if (showWeekdayLabels)
//           Row(
//             children: daysOfWeek
//                 .map(
//                   (day) => Expanded(
//                 child: Center(
//                   child: Text(
//                     day,
//                     style: TextStyle(
//                       // fontFamily: 'SF Pro Text',
//                       color: Colors.grey.shade500,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 12,
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//                 ),
//               ),
//             )
//                 .toList(),
//           ),
//         GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 7,
//             childAspectRatio: 1.2, // Slightly taller cells for iOS look
//             crossAxisSpacing: 4, // Reduced spacing
//             mainAxisSpacing: 4,
//           ),
//           itemCount: firstWeekday + daysInMonth,
//           itemBuilder: (context, index) {
//             if (index < firstWeekday) return const SizedBox.shrink();
//
//             final day = index - firstWeekday + 1;
//             final isSelected = selected.year == year &&
//                 selected.month == month &&
//                 selected.day == day;
//
//             return GestureDetector(
//               onTap: () => onDaySelected(day),
//               child: Container(
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: isSelected ? const Color(0xFF007AFF) : Colors.transparent,
//                   boxShadow: isSelected
//                       ? [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 4,
//                       offset: const Offset(0, 2),
//                     ),
//                   ]
//                       : null,
//                 ),
//                 alignment: Alignment.center,
//                 child: Text(
//                   '$day',
//                   style: TextStyle(
//                     // fontFamily: 'SF Pro Text',
//                     color: isSelected ? Colors.white : Colors.black87,
//                     fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
//                     fontSize: 16,
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
// class CalendarGrid extends StatelessWidget {
//   final int month, year;
//   final DateTime selected;
//   final ValueChanged<int> onDaySelected;
//   final bool showWeekdayLabels;
//
//   const CalendarGrid({
//     Key? key,
//     required this.month,
//     required this.year,
//     required this.selected,
//     required this.onDaySelected,
//     this.showWeekdayLabels = true,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // Number of days in the month
//     final daysInMonth = DateTime(year, month + 1, 0).day;
//
//     // Calculate the index of the first weekday (Sunday = 0, Monday = 1, ...)
//     // Adjust so that Sunday is 0 to match your week starting on Sunday
//     final firstWeekday = (DateTime(year, month, 1).weekday % 7);
//
//     // Days of week labels starting from Sunday
//     final daysOfWeek = ['SUN ', 'MON ', 'TUE ', 'WED ', 'THU ', 'FRI ', 'SAT '];
//
//     return Column(
//       children: [
//         if (showWeekdayLabels)
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8),
//             child: Row(
//               children: daysOfWeek
//                   .map(
//                     (day) => Expanded(
//                   child: Center(
//                     child: Text(
//                       day,
//                       style: TextStyle(
//                         color: Colors.grey.shade600,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//                   .toList(),
//             ),
//           ),
//         GridView.builder(
//           padding: EdgeInsets.zero,
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 7,
//             childAspectRatio: 1,
//             crossAxisSpacing: 25,
//             mainAxisSpacing: 20
//           ),
//           itemCount: firstWeekday + daysInMonth,
//           itemBuilder: (context, index) {
//             if (index < firstWeekday) return const SizedBox.shrink();
//
//             final day = index - firstWeekday + 1;
//             final isSel = selected.year == year &&
//                 selected.month == month &&
//                 selected.day == day;
//
//             final columnIndex = index % 7;
//
//             // Calculate horizontal offset for bleeding on extreme columns
//             final offsetX = isSel
//                 ? (columnIndex == 0 ? -6.0 : (columnIndex == 6 ? 12.0 : 0.0))
//                 : (columnIndex == 0 ? -6.0 : (columnIndex == 6 ? 12.0 : 0.0));
//
//             return GestureDetector(
//               onTap: () => onDaySelected(day),
//               child: Transform.translate(
//                 offset: Offset(offsetX, 0),
//                 child: Container(
//                   width: 32,
//                   height: 32,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: isSel ? const Color(0xFF1C79D4) : null,
//                   ),
//                   alignment: Alignment.center,
//                   child: Text(
//                     '$day',
//                     style: TextStyle(
//                       color: isSel ? Colors.white : Colors.black,
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//         // GridView.builder(
//         //   shrinkWrap: true,
//         //   physics: const NeverScrollableScrollPhysics(),
//         //   padding: EdgeInsets.zero,
//         //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         //     crossAxisCount: 7,
//         //     childAspectRatio: 1,
//         //   ),
//         //   itemCount: firstWeekday + daysInMonth,
//         //   itemBuilder: (context, index) {
//         //     if (index < firstWeekday) {
//         //       // Empty cells before the first day of month
//         //       return const SizedBox.shrink();
//         //     }
//         //
//         //     final day = index - firstWeekday + 1;
//         //     final isSelected = selected.year == year &&
//         //         selected.month == month &&
//         //         selected.day == day;
//         //
//         //     return GestureDetector(
//         //       onTap: () => onDaySelected(day),
//         //       child: Container(
//         //         margin: const EdgeInsets.all(4),
//         //         decoration: BoxDecoration(
//         //           shape: BoxShape.circle,
//         //           color: isSelected ? const Color(0xFF1C79D4) : Colors.transparent,
//         //         ),
//         //         alignment: Alignment.center,
//         //         child: Text(
//         //           '$day',
//         //           style: TextStyle(
//         //             color: isSelected ? Colors.white : Colors.black87,
//         //             fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//         //             fontSize: 14,
//         //           ),
//         //         ),
//         //       ),
//         //     );
//         //   },
//         // ),
//       ],
//     );
//   }
// }
