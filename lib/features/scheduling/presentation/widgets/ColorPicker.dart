

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerGrid extends StatefulWidget {
  final Function(Color) onColorSelected;

  const ColorPickerGrid({super.key, required this.onColorSelected});

  @override
  State<ColorPickerGrid> createState() => _ColorPickerGridState();
}

class _ColorPickerGridState extends State<ColorPickerGrid> {
  Color pickerColor = Colors.blue;
  bool showColorGrid = false;

  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
    });
    widget.onColorSelected(color);
  }

  void toggleColorPicker() {
    setState(() {
      showColorGrid = !showColorGrid;
    });
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
      Colors.yellow.shade300,
      Colors.blueGrey,
      Colors.indigo,
      Colors.orange,
      Colors.white,
      Colors.lime,
      Colors.deepPurple,
      Colors.blueAccent,
      Colors.deepOrangeAccent,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!showColorGrid)
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ...presetColors.map(
                    (color) => GestureDetector(
                  onTap: () => widget.onColorSelected(color),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: toggleColorPicker,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.add, size: 20, color: Colors.black),
                ),
              ),
            ],
          )
        else
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ColorPicker(
                    pickerColor: pickerColor,
                    onColorChanged: changeColor,
                    paletteType: PaletteType.hsv,
                    enableAlpha: true,
                    displayThumbColor: false,
                    showLabel: false,
                    pickerAreaHeightPercent: 0.5,
                    pickerAreaBorderRadius: const BorderRadius.all(Radius.circular(8)),
                    hexInputBar: false,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
