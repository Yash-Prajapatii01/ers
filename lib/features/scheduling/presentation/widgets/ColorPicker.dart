// // import 'package:flutter/material.dart';
// //
// // class ColorPickerGrid extends StatelessWidget {
// //   final Function(Color) onColorSelected;
// //
// //   const ColorPickerGrid({super.key, required this.onColorSelected});
// //
// //   void _openColorPicker(BuildContext context) {
// //     showDialog(
// //       context: context,
// //       builder: (_) {
// //         Color pickedColor = Colors.blue;
// //         return AlertDialog(
// //           title: const Text('Pick a Color'),
// //           content: SingleChildScrollView(
// //             child: Column(
// //               children: [
// //                 ColorPickerSlider(
// //                   onChanged: (color) {
// //                     pickedColor = color;
// //                   },
// //                 ),
// //               ],
// //             ),
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.pop(context),
// //               child: const Text('Cancel'),
// //             ),
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.pop(context);
// //                 onColorSelected(pickedColor);
// //               },
// //               child: const Text('Done'),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final List<Color> presetColors = [
// //       Colors.grey, Colors.redAccent, Colors.orangeAccent, Colors.amber, Colors.lightGreen,
// //       Colors.teal, Colors.cyan, Colors.blue, Colors.purple, Colors.pinkAccent,
// //       Colors.red, Colors.lightBlueAccent, Colors.green, Colors.yellow.shade300, Colors.blueGrey,
// //       Colors.indigo, Colors.orange, Colors.white, Colors.lime, Colors.deepPurple,
// //       Colors.blueAccent, Colors.deepOrangeAccent,
// //     ];
// //
// //     return Wrap(
// //       spacing: 10,
// //       runSpacing: 10,
// //       children: [
// //         ...presetColors.map((color) => GestureDetector(
// //           onTap: () => onColorSelected(color),
// //           child: Container(
// //             width: 36,
// //             height: 36,
// //             decoration: BoxDecoration(
// //               color: color,
// //               borderRadius: BorderRadius.circular(6),
// //               border: Border.all(color: Colors.grey.shade300),
// //             ),
// //           ),
// //         )),
// //         GestureDetector(
// //           onTap: () => _openColorPicker(context),
// //           child: Container(
// //             width: 36,
// //             height: 36,
// //             decoration: BoxDecoration(
// //               color: Colors.grey.shade300,
// //               borderRadius: BorderRadius.circular(6),
// //             ),
// //             child: const Icon(Icons.add, size: 20, color: Colors.black),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
// // class ColorPickerSlider extends StatefulWidget {
// //   final ValueChanged<Color> onChanged;
// //
// //   const ColorPickerSlider({super.key, required this.onChanged});
// //
// //   @override
// //   State<ColorPickerSlider> createState() => _ColorPickerSliderState();
// // }
// //
// // class _ColorPickerSliderState extends State<ColorPickerSlider> {
// //   double hue = 240;
// //   double saturation = 1.0;
// //   double lightness = 0.5;
// //
// //   Color get color =>
// //       HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         Slider(
// //           label: 'Hue',
// //           value: hue,
// //           min: 0,
// //           max: 360,
// //           onChanged: (v) => setState(() {
// //             hue = v;
// //             widget.onChanged(color);
// //           }),
// //         ),
// //         Slider(
// //           label: 'Saturation',
// //           value: saturation,
// //           min: 0,
// //           max: 1,
// //           onChanged: (v) => setState(() {
// //             saturation = v;
// //             widget.onChanged(color);
// //           }),
// //         ),
// //         Slider(
// //           label: 'Lightness',
// //           value: lightness,
// //           min: 0,
// //           max: 1,
// //           onChanged: (v) => setState(() {
// //             lightness = v;
// //             widget.onChanged(color);
// //           }),
// //         ),
// //         Container(
// //           height: 40,
// //           width: double.infinity,
// //           margin: const EdgeInsets.only(top: 10),
// //           decoration: BoxDecoration(
// //             color: color,
// //             borderRadius: BorderRadius.circular(6),
// //             border: Border.all(color: Colors.black26),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class ColorPickerGrid extends StatelessWidget {
//   final Function(Color) onColorSelected;
//
//   const ColorPickerGrid({super.key, required this.onColorSelected});
//
//   void _openColorPicker(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) {
//         return AdvancedColorPicker(
//           initialColor: Colors.blue,
//           onColorSelected: onColorSelected,
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final List<Color> presetColors = [
//       Colors.grey, Colors.redAccent, Colors.orangeAccent, Colors.amber, Colors.lightGreen,
//       Colors.teal, Colors.cyan, Colors.blue, Colors.purple, Colors.pinkAccent,
//       Colors.red, Colors.lightBlueAccent, Colors.green, Colors.yellow.shade300, Colors.blueGrey,
//       Colors.indigo, Colors.orange, Colors.white, Colors.lime, Colors.deepPurple,
//       Colors.blueAccent, Colors.deepOrangeAccent,
//     ];
//
//     return Wrap(
//       spacing: 10,
//       runSpacing: 10,
//       children: [
//         ...presetColors.map((color) => GestureDetector(
//           onTap: () => onColorSelected(color),
//           child: Container(
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               color: color,
//               borderRadius: BorderRadius.circular(6),
//               border: Border.all(color: Colors.grey.shade300),
//             ),
//           ),
//         )),
//         GestureDetector(
//           onTap: () => _openColorPicker(context),
//           child: Container(
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               color: Colors.grey.shade300,
//               borderRadius: BorderRadius.circular(6),
//             ),
//             child: const Icon(Icons.add, size: 20, color: Colors.black),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class AdvancedColorPicker extends StatefulWidget {
//   final Color initialColor;
//   final Function(Color) onColorSelected;
//
//   const AdvancedColorPicker({
//     super.key,
//     required this.initialColor,
//     required this.onColorSelected,
//   });
//
//   @override
//   State<AdvancedColorPicker> createState() => _AdvancedColorPickerState();
// }
//
// class _AdvancedColorPickerState extends State<AdvancedColorPicker> {
//   late Color _currentColor;
//   late double _hue;
//   late double _saturation;
//   late double _value;
//   late double _opacity;
//   late TextEditingController _hexController;
//
//   @override
//   void initState() {
//     super.initState();
//     _currentColor = widget.initialColor;
//
//     // Convert to HSV
//     final HSVColor hsvColor = HSVColor.fromColor(_currentColor);
//     _hue = hsvColor.hue;
//     _saturation = hsvColor.saturation;
//     _value = hsvColor.value;
//     _opacity = hsvColor.alpha;
//
//     // Initialize hex controller
//     _hexController = TextEditingController(text: _colorToHex(_currentColor));
//   }
//
//   @override
//   void dispose() {
//     _hexController.dispose();
//     super.dispose();
//   }
//
//   String _colorToHex(Color color) {
//     return color.value.toRadixString(16).padLeft(8, '0').toUpperCase().substring(2);
//   }
//
//   void _updateCurrentColor() {
//     setState(() {
//       _currentColor = HSVColor.fromAHSV(_opacity, _hue, _saturation, _value).toColor();
//       _hexController.text = _colorToHex(_currentColor);
//     });
//   }
//
//   void _updateFromHex(String hex) {
//     if (hex.length == 6) {
//       try {
//         final color = Color(int.parse('FF$hex', radix: 16));
//         final HSVColor hsvColor = HSVColor.fromColor(color);
//         setState(() {
//           _hue = hsvColor.hue;
//           _saturation = hsvColor.saturation;
//           _value = hsvColor.value;
//           _currentColor = color.withOpacity(_opacity);
//         });
//       } catch (e) {
//         // Invalid hex format
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       height: MediaQuery.of(context).size.height * 0.6,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Header
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text(
//                   'Cancel',
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ),
//               Text(
//                 'Edit Labels',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   widget.onColorSelected(_currentColor);
//                 },
//                 child: Text(
//                   'Done',
//                   style: TextStyle(
//                     color: Theme.of(context).primaryColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 20),
//
//           // Color preview box
//           Container(
//             height: 120,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.black.withOpacity(_opacity),
//                   HSVColor.fromAHSV(_opacity, _hue, _saturation, 1).toColor(),
//                 ],
//                 begin: Alignment.bottomLeft,
//                 end: Alignment.topRight,
//               ),
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//
//           const SizedBox(height: 20),
//
//           // Hue slider
//           Container(
//             height: 24,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               gradient: const LinearGradient(
//                 colors: [
//                   Colors.red,
//                   Colors.yellow,
//                   Colors.green,
//                   Colors.cyan,
//                   Colors.blue,
//                   Colors.purple,
//                   Colors.red,
//                 ],
//               ),
//             ),
//             child: SliderTheme(
//               data: SliderThemeData(
//                 trackShape: const RectangularSliderTrackShape(),
//                 trackHeight: 24,
//                 thumbColor: Colors.white,
//                 thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
//                 overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
//                 overlayColor: Colors.white.withOpacity(0.2),
//               ),
//               child: Slider(
//                 value: _hue,
//                 min: 0,
//                 max: 360,
//                 onChanged: (value) {
//                   setState(() {
//                     _hue = value;
//                     _updateCurrentColor();
//                   });
//                 },
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 16),
//
//           // Opacity slider
//           Container(
//             height: 24,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.transparent,
//                   HSVColor.fromAHSV(1.0, _hue, _saturation, _value).toColor(),
//                 ],
//               ),
//               image: const DecorationImage(
//                 image: AssetImage('assets/transparency_grid.png'),
//                 repeat: ImageRepeat.repeat,
//                 fit: BoxFit.none,
//               ),
//             ),
//             child: SliderTheme(
//               data: SliderThemeData(
//                 trackShape: const RectangularSliderTrackShape(),
//                 trackHeight: 24,
//                 thumbColor: Colors.white,
//                 thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
//                 overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
//                 overlayColor: Colors.white.withOpacity(0.2),
//               ),
//               child: Slider(
//                 value: _opacity,
//                 min: 0,
//                 max: 1.0,
//                 onChanged: (value) {
//                   setState(() {
//                     _opacity = value;
//                     _updateCurrentColor();
//                   });
//                 },
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 20),
//
//           // Hex input and opacity percentage
//           Row(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade300),
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 child: Row(
//                   children: [
//                     const Text('Hex', style: TextStyle(fontWeight: FontWeight.w500)),
//                     const SizedBox(width: 8),
//                     const Icon(Icons.swap_horiz, size: 20),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey.shade300),
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   child: TextFormField(
//                     controller: _hexController,
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       prefixText: '# ',
//                       contentPadding: EdgeInsets.zero,
//                     ),
//                     inputFormatters: [
//                       FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F]')),
//                       LengthLimitingTextInputFormatter(6),
//                     ],
//                     onChanged: _updateFromHex,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade300),
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 child: Text(
//                   '${(_opacity * 100).round()}%',
//                   style: const TextStyle(fontWeight: FontWeight.w500),
//                 ),
//               ),
//             ],
//           ),
//
//           const Spacer(),
//
//           // Bottom handle
//           Container(
//             width: 40,
//             height: 5,
//             decoration: BoxDecoration(
//               color: Colors.black,
//               borderRadius: BorderRadius.circular(2.5),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ColorPickerGrid extends StatelessWidget {
  final Function(Color) onColorSelected;

  const ColorPickerGrid({super.key, required this.onColorSelected});

  AdvancedColorPicker _openColorPicker(BuildContext context) {
    return AdvancedColorPicker(
      initialColor: Colors.blue,
      onColorSelected: onColorSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> presetColors = [
      Colors.grey, Colors.redAccent, Colors.orangeAccent, Colors.amber, Colors.lightGreen,
      Colors.teal, Colors.cyan, Colors.blue, Colors.purple, Colors.pinkAccent,
      Colors.red, Colors.lightBlueAccent, Colors.green, Colors.yellow.shade300, Colors.blueGrey,
      Colors.indigo, Colors.orange, Colors.white, Colors.lime, Colors.deepPurple,
      Colors.blueAccent, Colors.deepOrangeAccent,
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        ...presetColors.map((color) => GestureDetector(
          onTap: () => onColorSelected(color),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade300),
            ),
          ),
        )),
        GestureDetector(
          onTap: () => _openColorPicker(context),
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
    );
  }
}

class AdvancedColorPicker extends StatefulWidget {
  final Color initialColor;
  final Function(Color) onColorSelected;

  const AdvancedColorPicker({
    super.key,
    required this.initialColor,
    required this.onColorSelected,
  });

  @override
  State<AdvancedColorPicker> createState() => _AdvancedColorPickerState();
}

class _AdvancedColorPickerState extends State<AdvancedColorPicker> {
  late Color _currentColor;
  late double _hue;
  late double _saturation;
  late double _value;
  late double _opacity;
  late TextEditingController _hexController;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.initialColor;

    // Convert to HSV
    final HSVColor hsvColor = HSVColor.fromColor(_currentColor);
    _hue = hsvColor.hue;
    _saturation = hsvColor.saturation;
    _value = hsvColor.value;
    _opacity = hsvColor.alpha;

    // Initialize hex controller
    _hexController = TextEditingController(text: _colorToHex(_currentColor));
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  String _colorToHex(Color color) {
    return color.value.toRadixString(16).padLeft(8, '0').toUpperCase().substring(2);
  }

  void _updateCurrentColor() {
    setState(() {
      _currentColor = HSVColor.fromAHSV(_opacity, _hue, _saturation, _value).toColor();
      _hexController.text = _colorToHex(_currentColor);
    });
  }

  void _updateFromHex(String hex) {
    if (hex.length == 6) {
      try {
        final color = Color(int.parse('FF$hex', radix: 16));
        final HSVColor hsvColor = HSVColor.fromColor(color);
        setState(() {
          _hue = hsvColor.hue;
          _saturation = hsvColor.saturation;
          _value = hsvColor.value;
          _currentColor = color.withOpacity(_opacity);
        });
      } catch (e) {
        // Invalid hex format
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              Text(
                'Edit Labels',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onColorSelected(_currentColor);
                },
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Color preview box
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(_opacity),
                  HSVColor.fromAHSV(_opacity, _hue, _saturation, 1).toColor(),
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 20),

          // Hue slider
          Container(
            height: 24,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [
                  Colors.red,
                  Colors.yellow,
                  Colors.green,
                  Colors.cyan,
                  Colors.blue,
                  Colors.purple,
                  Colors.red,
                ],
              ),
            ),
            child: SliderTheme(
              data: SliderThemeData(
                trackShape: const RectangularSliderTrackShape(),
                trackHeight: 24,
                thumbColor: Colors.white,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                overlayColor: Colors.white.withOpacity(0.2),
              ),
              child: Slider(
                value: _hue,
                min: 0,
                max: 360,
                onChanged: (value) {
                  setState(() {
                    _hue = value;
                    _updateCurrentColor();
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Opacity slider
          Container(
            height: 24,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  HSVColor.fromAHSV(1.0, _hue, _saturation, _value).toColor(),
                ],
              ),
              image: const DecorationImage(
                image: AssetImage('assets/transparency_grid.png'),
                repeat: ImageRepeat.repeat,
                fit: BoxFit.none,
              ),
            ),
            child: SliderTheme(
              data: SliderThemeData(
                trackShape: const RectangularSliderTrackShape(),
                trackHeight: 24,
                thumbColor: Colors.white,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                overlayColor: Colors.white.withOpacity(0.2),
              ),
              child: Slider(
                value: _opacity,
                min: 0,
                max: 1.0,
                onChanged: (value) {
                  setState(() {
                    _opacity = value;
                    _updateCurrentColor();
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Hex input and opacity percentage
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const Text('Hex', style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(width: 8),
                    const Icon(Icons.swap_horiz, size: 20),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextFormField(
                    controller: _hexController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixText: '# ',
                      contentPadding: EdgeInsets.zero,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F]')),
                      LengthLimitingTextInputFormatter(6),
                    ],
                    onChanged: _updateFromHex,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  '${(_opacity * 100).round()}%',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),

          const Spacer(),

          // Bottom handle
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
        ],
      ),
    );
  }
}