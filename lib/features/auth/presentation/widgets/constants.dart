import 'package:flutter/material.dart';

class ConstantWidget {
  static Widget loginCircularBar(
    double width,
    double height,
    BorderRadius radius,
    Color color,
  ) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: color, borderRadius: radius),
    );
  }

  static void showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 300),
      ),
    );
  }
}
