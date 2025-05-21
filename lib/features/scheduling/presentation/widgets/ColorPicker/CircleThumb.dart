import 'package:flutter/material.dart';
class CircleThumbShape extends SliderComponentShape {
  final double thumbRadius;
  final Color color;

  const CircleThumbShape({required this.thumbRadius, required this.color});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    final Canvas canvas = context.canvas;

    // Draw outer white circle
    final Paint outerPaint =
    Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, thumbRadius, outerPaint);

    // Draw inner colored circle
    final Paint innerPaint =
    Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, thumbRadius * 0.6, innerPaint);
  }
}