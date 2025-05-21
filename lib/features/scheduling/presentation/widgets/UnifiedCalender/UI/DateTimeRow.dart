import 'package:flutter/material.dart';

import '../../PillText.dart';
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Inter'),
          ),
          const Spacer(),
          if (date != null)
            GestureDetector(
              onTap: onDateTap,
              child: PillText(
                width: 130,
                height: 36,
                date!,
                dateColor ?? Color.fromRGBO(39, 39, 39, 1),
                isCalender: true,
              ),
            ),
          if (date != null && time != null) const SizedBox(width: 8),
          if (time != null)
            GestureDetector(
              onTap: onTimeTap,
              child: PillText(
                width: 95,
                height: 36,
                time!,
                timeColor ?? Color.fromRGBO(39, 39, 39, 1),
                isCalender: true,
              ),
            ),
        ],
      ),
    );
  }
}