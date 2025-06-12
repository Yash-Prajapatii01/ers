import 'package:ers_linux/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  CustomSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  Color activeColor =  AppColors.switchActiveColor;
  Color inactiveColor = AppColors.switchInactiveColor;
  Color thumbColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onChanged(!widget.value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 42.w,
        height: 23.w,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: widget.value ? activeColor : inactiveColor,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment:
          widget.value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 17.w,
            height: 17.h,
            decoration: BoxDecoration(
                color: thumbColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 3),
                    blurRadius: 1.r,
                    spreadRadius: 0,
                    color: const Color.fromRGBO(0, 0, 0, 0.06),
                  ),
                  BoxShadow(
                    offset: Offset(0, 3),
                    blurRadius: 8,
                    spreadRadius: 0,
                    color: const Color.fromRGBO(0, 0, 0, 0.15),
                  ),
                  BoxShadow(
                    offset: Offset(0, 0),
                    blurRadius: 0,
                    spreadRadius: 1,
                    color: const Color.fromRGBO(0, 0, 0, 0.04),
                  ),
                ]
            ),
          ),
        ),
      ),
    );
  }
}