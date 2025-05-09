import 'package:flutter/material.dart';

class CustomWheelPicker extends StatefulWidget {
  const CustomWheelPicker({super.key});

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
    const double overlayWidth = 350;
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
                left: (MediaQuery.of(context).size.width - overlayWidth) / 2,
                child: Container(
                  width: overlayWidth,
                  height: overlayHeight,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
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
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
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
                          style: TextStyle(
                            fontSize: isSelected ? 16 : 14,
                          ),
                        ),
                      );
                    },
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
