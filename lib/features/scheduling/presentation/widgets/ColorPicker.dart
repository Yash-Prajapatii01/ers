import 'package:flutter/material.dart';

class ColorPickerGrid extends StatefulWidget {
  final Function(Color) onColorSelected;

  const ColorPickerGrid({super.key, required this.onColorSelected});

  @override
  State<ColorPickerGrid> createState() => _ColorPickerGridState();
}

class _ColorPickerGridState extends State<ColorPickerGrid> {
  Color selectedColor = Colors.blue;
  // Keep a reference to the CustomColorPicker's state key
  final GlobalKey<_CustomColorPickerState> _colorPickerKey = GlobalKey<_CustomColorPickerState>();

  void changeColor(Color color) {
    setState(() {
      selectedColor = color;
    });
    // Update the CustomColorPicker when a preset color is selected
    _colorPickerKey.currentState?.updateColorFromOutside(color);
    widget.onColorSelected(color);
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> presetColors = [
      Colors.grey,
      Colors.redAccent,
      Colors.orangeAccent,
      Colors.amber,
      Colors.lightGreen,
      Colors.teal,
      Colors.cyan,
      Colors.blue,
      Colors.purple,
      Colors.pinkAccent,
      Colors.red,
      Colors.lightBlueAccent,
      Colors.green,
      Colors.yellow,
      Colors.blueGrey,
      Colors.indigo,
      Colors.orange,
      Colors.lime,
      Colors.deepPurple,
      Colors.blueAccent,
      Colors.deepOrangeAccent,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Custom palette always visible on top
        CustomColorPicker(
          key: _colorPickerKey, // Add the key to access the state
          initialColor: selectedColor,
          onColorChanged: (Color color) {
            changeColor(color);
          },
        ),
        const SizedBox(height: 16),
        // Grid of preset colors
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: presetColors.map((color) {
            return GestureDetector(
              onTap: () => changeColor(color),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: selectedColor.value == color.value
                    ? const Center(
                  child: Icon(Icons.check, color: Colors.white, size: 20),
                )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class CustomColorPicker extends StatefulWidget {
  final Color initialColor;
  final void Function(Color) onColorChanged;

  const CustomColorPicker({
    super.key,
    required this.initialColor,
    required this.onColorChanged,
  });

  @override
  State<CustomColorPicker> createState() => _CustomColorPickerState();
}

class _CustomColorPickerState extends State<CustomColorPicker> {
  late HSVColor _currentHsv;
  double _alpha = 1.0;
  final _hexController = TextEditingController();

  final GlobalKey _gestureAreaKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _currentHsv = HSVColor.fromColor(widget.initialColor);
    _alpha = widget.initialColor.opacity;
    _updateTextControllers();
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  // Add this method to update the color picker from outside
  void updateColorFromOutside(Color newColor) {
    setState(() {
      _currentHsv = HSVColor.fromColor(newColor);
      _alpha = newColor.opacity;
      _updateTextControllers();
    });
  }

  String _colorToHex(Color color) =>
      '#${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}'
          .toUpperCase();

  void _updateColor(Color newColor) {
    widget.onColorChanged(newColor);
    _updateTextControllers();
  }

  void _updateTextControllers() {
    _hexController.text = _colorToHex(
      _currentHsv.toColor().withOpacity(_alpha),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: GestureDetector(
            key: _gestureAreaKey,
            onPanUpdate: (details) => _handleSaturationBrightnessGesture(details.localPosition),
            onTapDown: (details) => _handleSaturationBrightnessGesture(details.localPosition),
            child: CustomPaint(
              size: const Size(500, 160),
              painter: _SaturationBrightnessPainter(
                hue: _currentHsv.hue,
                saturation: _currentHsv.saturation,
                value: _currentHsv.value,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildHueSlider(),
      ],
    );
  }

  void _handleSaturationBrightnessGesture(Offset localPosition) {
    final renderBox = _gestureAreaKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;

    final dx = localPosition.dx.clamp(0.0, size.width);
    final dy = localPosition.dy.clamp(0.0, size.height);

    double s = dx / size.width;
    double v = 1.0 - (dy / size.height);

    setState(() {
      _currentHsv = _currentHsv.withSaturation(s).withValue(v);
      _updateColor(_currentHsv.toColor().withOpacity(_alpha));
    });
  }

  Widget _buildHueSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 255, 0, 0),
                    Color.fromARGB(255, 255, 255, 0),
                    Color.fromARGB(255, 0, 255, 0),
                    Color.fromARGB(255, 0, 255, 255),
                    Color.fromARGB(255, 0, 0, 255),
                    Color.fromARGB(255, 255, 0, 255),
                    Color.fromARGB(255, 255, 0, 0),
                  ],
                ),
              ),
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 24,
                thumbShape: _CircleThumbShape(
                  thumbRadius: 8,
                  color: _currentHsv.toColor(),
                ),
                overlayShape: SliderComponentShape.noOverlay,
                trackShape: const RectangularSliderTrackShape(),
                activeTrackColor: Colors.transparent,
                inactiveTrackColor: Colors.transparent,
              ),
              child: Slider(
                value: _currentHsv.hue,
                onChanged: (newHue) {
                  setState(() {
                    _currentHsv = _currentHsv.withHue(newHue);
                    _updateColor(_currentHsv.toColor().withOpacity(_alpha));
                  });
                },
                min: 0,
                max: 360,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color get currentColor => _currentHsv.toColor().withOpacity(_alpha);
}

class _SaturationBrightnessPainter extends CustomPainter {
  final double hue;
  final double saturation;
  final double value;

  const _SaturationBrightnessPainter({
    required this.hue,
    required this.saturation,
    required this.value,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // White to pure color (saturation)
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
      ..strokeWidth = 2;
    canvas.drawCircle(Offset(pointerX, pointerY), 8, outerPaint);

    // Draw inner circle with current color
    final innerPaint =
    Paint()
      ..color = HSVColor.fromAHSV(1.0, hue, saturation, value).toColor();
    canvas.drawCircle(Offset(pointerX, pointerY), 6, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _SaturationBrightnessPainter oldDelegate) {
    return oldDelegate.hue != hue ||
        oldDelegate.saturation != saturation ||
        oldDelegate.value != value;
  }
}

class _CircleThumbShape extends SliderComponentShape {
  final double thumbRadius;
  final Color color;

  const _CircleThumbShape({required this.thumbRadius, required this.color});

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