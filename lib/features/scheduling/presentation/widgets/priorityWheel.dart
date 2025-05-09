import 'package:flutter/material.dart';

class CustomWheelPicker extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onSelected;

  const CustomWheelPicker({super.key, required this.onSelected});

  @override
  State<CustomWheelPicker> createState() => _CustomWheelPickerState();
}

class _CustomWheelPickerState extends State<CustomWheelPicker> {
  final List<Map<String, dynamic>> options = [
    {'label': 'None', 'color': Colors.transparent},
    {'label': 'High', 'color': const Color(0xFFFF3B30)},
    {'label': 'Medium', 'color': const Color(0xFFffad33)},
    {'label': 'Low', 'color': const Color(0xFF34C759)},
  ];

  int _selectedIndex = 0;
  final FixedExtentScrollController _controller = FixedExtentScrollController();

  @override
  Widget build(BuildContext context) {
    const double tileWidth = 87;
    const double tileHeight = 30;
    const double selectedWidth = 150;
    const double overlayHeight = 40;
    const double listHeight = 250;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: listHeight,
          child: Stack(
            children: [
              Positioned(
                top: (listHeight - overlayHeight) / 2,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 350,
                    height: overlayHeight,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              NotificationListener<ScrollNotification>(
                onNotification: (_) {
                  setState(() {});
                  return true;
                },
                child: ListWheelScrollView.useDelegate(
                  controller: _controller,
                  itemExtent: overlayHeight,
                  perspective: 0.00000000001,
                  physics: const FixedExtentScrollPhysics(),
                  diameterRatio: 10.0,
                  onSelectedItemChanged: (idx) {
                    setState(() => _selectedIndex = idx);
                    widget.onSelected(options[idx]);
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: options.length,
                    builder: (context, index) {
                      final bool isSelected = index == _selectedIndex;
                      final double width = isSelected ? selectedWidth : tileWidth;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        width: width,
                        height: tileHeight,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: options[index]['color'],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          options[index]['label'],
                          style: TextStyle(fontSize: isSelected ? 16 : 14),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Top blur overlay
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 60,
                child: IgnorePointer(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white,
                          Colors.white,
                          Colors.white,
                          Color.fromRGBO(255, 255, 255, 0),
                          // Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom blur overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 50,
                child: IgnorePointer(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.white,
                          Colors.white,
                          Colors.white,
                          Color.fromRGBO(255, 255, 255, 0),
                          // Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
