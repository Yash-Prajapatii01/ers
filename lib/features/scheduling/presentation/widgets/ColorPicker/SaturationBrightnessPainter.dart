import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class SaturationBrightnessPainter extends CustomPainter {
  final double hue;
  final double saturation;
  final double value;

  const SaturationBrightnessPainter({
    required this.hue,
    required this.saturation,
    required this.value,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;


    final paintSatGrad =
    Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white,
          HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor(),
        ],
      ).createShader(rect);

    // Transparent to black (value/brightness)
    final paintValGrad =
    Paint()
      ..shader = const LinearGradient(
        colors: [Colors.transparent, Colors.black],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);

    // Paint the gradients
    canvas.drawRect(rect, paintSatGrad);
    canvas.drawRect(rect, paintValGrad);

    // Draw the pointer position
    final pointerX = saturation * size.width;
    final pointerY = (1 - value) * size.height;

    // Draw outer white circle
    final outerPaint =
    Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.w;
    canvas.drawCircle(Offset(pointerX, pointerY), 8, outerPaint);

    // Draw inner circle with current color
    final innerPaint =
    Paint()
      ..color = HSVColor.fromAHSV(1.0, hue, saturation, value).toColor();
    canvas.drawCircle(Offset(pointerX, pointerY), 6, innerPaint);
  }

  @override
  bool shouldRepaint(covariant SaturationBrightnessPainter oldDelegate) {
    return oldDelegate.hue != hue ||
        oldDelegate.saturation != saturation ||
        oldDelegate.value != value;
  }
}