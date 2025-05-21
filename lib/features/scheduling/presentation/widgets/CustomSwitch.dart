import 'package:flutter/material.dart';
class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;

  CustomSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    this.activeColor = const Color.fromRGBO(53, 199, 90, 1),
    this.inactiveColor = const Color.fromRGBO(233, 233, 235, 1),
    this.thumbColor = Colors.white,
  }) : super(key: key);

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onChanged(!widget.value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 24,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: widget.value ? widget.activeColor : widget.inactiveColor,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment:
          widget.value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
                color: widget.thumbColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 3),
                    blurRadius: 1,
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