// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class CustomWheelPicker extends StatefulWidget {
//   final ValueChanged<Map<String, dynamic>> onSelected;
//   final List<Map<String, dynamic>> options;
//
//   CustomWheelPicker({super.key, required this.onSelected, required this.options});
//
//   @override
//   State<CustomWheelPicker> createState() => _CustomWheelPickerState();
// }
//
// class _CustomWheelPickerState extends State<CustomWheelPicker> {
//
//   int _selectedIndex = 0;
//   final FixedExtentScrollController _controller = FixedExtentScrollController();
//
//
//   @override
//   Widget build(BuildContext context) {
//     const double tileWidth = 87;
//     const double tileHeight = 30;
//     const double selectedWidth = 150;
//     const double overlayHeight = 40;
//     const double listHeight = 250;
//
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         SizedBox(
//           height: listHeight,
//           child: Stack(
//             children: [
//               Positioned(
//                 top: (listHeight - overlayHeight) / 2,
//                 left: 0,
//                 right: 0,
//                 child: Center(
//                   child: Container(
//                     width: 340.w,
//                     height: overlayHeight,
//                     decoration: BoxDecoration(
//                       color: Colors.black.withValues(alpha: 0.05),
//                       borderRadius: BorderRadius.circular(12.r),
//                     ),
//                   ),
//                 ),
//               ),
//               NotificationListener<ScrollNotification>(
//                 onNotification: (_) {
//                   setState(() {});
//                   return true;
//                 },
//                 child: ListWheelScrollView.useDelegate(
//                   controller: _controller,
//                   itemExtent: overlayHeight,
//                   perspective: 0.00000000001,
//                   physics: const FixedExtentScrollPhysics(),
//                   diameterRatio: 10.0,
//                   onSelectedItemChanged: (idx) {
//                     setState(() => _selectedIndex = idx);
//                     widget.onSelected(widget.options[idx]);
//                   },
//                   childDelegate: ListWheelChildBuilderDelegate(
//                     childCount: widget.options.length,
//                     builder: (context, index) {
//                       final bool isSelected = index == _selectedIndex;
//                       final double width = isSelected ? selectedWidth : tileWidth;
//                       return AnimatedContainer(
//                         duration: const Duration(milliseconds: 200),
//                         margin: EdgeInsets.symmetric(vertical: 5.h),
//                         width: width.w,
//                         height: tileHeight.h,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: widget.options[index]['color'] ?? Colors.transparent,
//                           borderRadius: BorderRadius.circular(6.r),
//                         ),
//                         child: Text(
//                           widget.options[index]['label'],
//                           style: TextStyle(fontSize: isSelected ? 15.sp : 13.sp),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//
//               // Top blur overlay
//               Positioned(
//                 top: 0,
//                 left: 0,
//                 right: 0,
//                 height: 60,
//                 child: IgnorePointer(
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                           Colors.white,
//                           Colors.white,
//                           Colors.white,
//                           Color.fromRGBO(255, 255, 255, 0),
//                           // Colors.transparent,
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               // Bottom blur overlay
//               Positioned(
//                 bottom: -1,
//                 left: 0,
//                 right: 0,
//                 height: 50,
//                 child: IgnorePointer(
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.bottomCenter,
//                         end: Alignment.topCenter,
//                         colors: [
//                           Colors.white,
//                           Color.fromRGBO(255, 255, 255, 0),
//                           // Colors.transparent,
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }

import 'package:ers_linux/features/scheduling/data/models/udfOptionsModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomWheelPicker extends StatefulWidget {
  final ValueChanged<UdfOptionsModel> onSelected;
  final List<UdfOptionsModel> options;

  const CustomWheelPicker({super.key, required this.onSelected, required this.options});

  @override
  State<CustomWheelPicker> createState() => _CustomWheelPickerState();
}

class _CustomWheelPickerState extends State<CustomWheelPicker> {
  int _selectedIndex = 0;
  final FixedExtentScrollController _controller = FixedExtentScrollController();

  @override
  void initState() {
    super.initState();
    // Call onSelected with the initial option (index 0) when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.options.isNotEmpty) {
        widget.onSelected(widget.options[0]);
      }
    });
  }

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
                    width: 340.w,
                    height: overlayHeight,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12.r),
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
                  // perspective: 0.00000000001,
                  physics: const FixedExtentScrollPhysics(),
                  diameterRatio: 10.0,
                  onSelectedItemChanged: (idx) {
                    setState(() => _selectedIndex = idx);
                    widget.onSelected(widget.options[idx]);
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: widget.options.length,
                    builder: (context, index) {
                      var option = widget.options[index];
                      final bool isSelected = index == _selectedIndex;
                      final double width = isSelected ? selectedWidth : tileWidth;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: EdgeInsets.symmetric(vertical: 5.h),
                        width: width.w,
                        height: tileHeight.h,
                        alignment: Alignment.center,
                        decoration:BoxDecoration(
                          color: option.color,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          option.name,
                          style: TextStyle(fontSize: isSelected ? 15.sp : 13.sp),
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom blur overlay
              Positioned(
                bottom: -1,
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
                          Color.fromRGBO(255, 255, 255, 0),
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