import 'package:ers_linux/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared/PillText.dart';
class DateTimeRow extends StatelessWidget {
  final String label;
  final String? date;
  final String? time;
  final bool isRequired;
  final Color? dateColor;
  final Color? timeColor;
  final VoidCallback? onDateTap;
  final VoidCallback? onTimeTap;

  const DateTimeRow({
    super.key,
    required this.label,
    this.isRequired = false,
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
      padding:  EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Expanded(
            child: Text.rich(
              maxLines: 1,
              TextSpan(
                text: label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkBlack,
                ),
                children: isRequired
                    ? [
                  TextSpan(
                    text: '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ]
                    : [],
              ),
            ),
          ),
          const Spacer(),
          if (date != null)
            GestureDetector(
              onTap: onDateTap,
              child: PillText(
                width: 125.w,
                height: 32.h,
                date!,
                dateColor ?? AppColors.darkBlack,
                isCalender: true,
              ),
            ),
          if (date != null && time != null)  SizedBox(width: 8.w),
          if (time != null)
            GestureDetector(
              onTap: onTimeTap,
              child: PillText(
                width: 91.w,
                height: 32.h,
                time!,
                timeColor ?? AppColors.darkBlack,
                isCalender: true,
              ),
            ),
        ],
      ),
    );
  }
}