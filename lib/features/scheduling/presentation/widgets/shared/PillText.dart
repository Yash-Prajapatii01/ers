import 'package:ers_linux/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PillText extends StatelessWidget {
  final String text;
  final Color color;
  final double? width;
  final double? height;
  final double radius;
  final bool isCalender;
  final EdgeInsetsGeometry? padding;


  const PillText(
      this.text,
      this.color, {
        Key? key,
        this.isCalender = false,
        this.width,
        this.height,
        this.radius = 4, this.padding
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      padding: padding ?? padding,
      // alignment: Alignment.center,
      // padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      // padding : isCalender
      //     ? const EdgeInsets.symmetric(horizontal: 14, vertical: 8)
      //     : const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
      decoration: BoxDecoration(
        color: isCalender ? AppColors.calenderPillColor : AppColors.effortPillColor,
        borderRadius:
        isCalender ? BorderRadius.circular(8.r) : BorderRadius.circular(radius.r),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: width?.w ?? 80.w
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: isCalender ? 15.sp : 13.sp,
            overflow: TextOverflow.ellipsis,
            color: color
            // color: isCalender ? color : Color.fromRGBO(102, 112, 133, 0.5),
          ),
        ),
      ),
    );
  }
}