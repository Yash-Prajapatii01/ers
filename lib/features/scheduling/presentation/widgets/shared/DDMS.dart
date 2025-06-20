import 'package:ers_linux/features/scheduling/data/models/udfOptionsModel.dart';
import 'package:ers_linux/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// class DDMSSelectableList extends StatelessWidget {
//   final List<UdfOptionsModel> options;
//   final List<UdfOptionsModel> selectedItems;
//   // final ValueChanged<List<String>> onSelectionChanged;
//   final ValueChanged<List<UdfOptionsModel>> onSelectionChanged;
//   final bool showCheckboxes;
//
//   const DDMSSelectableList({super.key,
//     required this.options,
//     required this.selectedItems,
//     required this.onSelectionChanged,
//     this.showCheckboxes = true,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (selectedItems.isNotEmpty && showCheckboxes)
//             Padding(
//               padding:  EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//               child: Wrap(
//                 spacing: 8,
//                 runSpacing: 8,
//                 children:
//                     //here we are making the chips of the selected items
//                     selectedItems.map((item) {
//                       return Container(
//                         margin:  EdgeInsets.only(right: 4.w),
//                         decoration: BoxDecoration(
//                           color: Colors.transparent,
//                           borderRadius: BorderRadius.circular(6.r),
//                           border: Border.all(
//                             color: Color.fromRGBO(0, 0, 0, 0.12),
//                           ),
//                         ),
//                         child: Stack(
//                           clipBehavior: Clip.none,
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 12.w,
//                                 vertical: 8.h,
//                               ),
//                               child: Text(
//                                 item.name,
//                                 style: TextStyle(fontSize: 13.sp),
//                               ),
//                             ),
//                             Positioned(
//                               top: -6,
//                               right: -6,
//                               child: InkWell(
//                                 borderRadius: BorderRadius.circular(8.r),
//                                 onTap: () {
//                                   final newSel = List<UdfOptionsModel>.from(
//                                     selectedItems,
//                                   )..removeWhere((v) => v.id == item);
//                                   onSelectionChanged(newSel);
//                                 },
//                                 child: Container(
//                                   padding: const EdgeInsets.all(2),
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     border: Border.all(
//                                       color: Colors.white,
//                                       width: 1.w,
//                                     ),
//                                     color: Color.fromRGBO(233, 233, 233, 1),
//                                   ),
//                                   child: const Icon(Icons.close, size: 12),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }).toList(),
//               ),
//             ),
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.0.w),
//               child: ListView.separated(
//                 separatorBuilder:
//                     (_, __) =>  Divider(
//                       height: 0.5.h,
//                       color: AppColors.dividerColor
//                     ),
//                 itemCount: options.length,
//                 padding: EdgeInsets.zero,
//                 itemBuilder: (ctx, i) {
//                   final opt = options[i];
//                   final isSel = selectedItems.contains(opt.name);
//                   if (showCheckboxes) {
//                     return Material(
//                       color: Colors.transparent,
//                       child: InkWell(
//                         onTap: () {
//                           final newSel = List<String>.from(selectedItems);
//                           if (isSel) {
//                             newSel.remove(opt.name);
//                           } else {
//                             newSel.add(opt.name);
//                           }
//                           onSelectionChanged(selectedItems);
//                         },
//                         child: Padding(
//                           padding:  EdgeInsets.symmetric(vertical: 9.5.h),
//                           child: Row(
//                             children: [
//                               // Checkbox
//                               Theme(
//                                 data: Theme.of(context).copyWith(
//                                   checkboxTheme: CheckboxThemeData(
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(2.r),
//                                     ),
//                                     side:  BorderSide(
//                                       color: AppColors.darkBlack,
//                                       width: 1.w,
//                                     ),
//                                     fillColor: WidgetStateProperty.resolveWith<
//                                       Color
//                                     >((states) {
//                                       if (states.contains(
//                                         WidgetState.selected,
//                                       )) {
//                                         return AppColors.primaryColor;
//                                       }
//                                       return Colors.white;
//                                     }),
//                                     checkColor: WidgetStateProperty.all<Color>(
//                                       Colors.white,
//                                     ),
//                                     // Check mark color
//                                     materialTapTargetSize:
//                                         MaterialTapTargetSize.shrinkWrap,
//                                     visualDensity: VisualDensity.compact,
//                                   ),
//                                 ),
//                                 child: SizedBox(
//                                   width: 13.5.w,
//                                   height: 13.5.h,
//                                   child: Checkbox(
//                                     value: isSel,
//                                     onChanged: (b) {
//                                       final newSel = List<UdfOptionsModel>.from(
//                                         selectedItems,
//                                       );
//                                       if (b == true) {
//                                         newSel.add(opt);
//                                       } else {
//                                         newSel.remove(opt);
//                                       }
//                                       onSelectionChanged(newSel);
//                                     },
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 10.w),
//                               // Text
//                               Expanded(
//                                 child: Text(
//                                   opt.name,
//                                   style: TextStyle(
//                                     fontSize: 15.sp,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   } else {
//                     // New non-checkbox multiple selection mode with check icons on right
//                     return Material(
//                       color: Colors.transparent,
//                       child: InkWell(
//                         onTap: () {
//                           final newSel = List<UdfOptionsModel>.from(selectedItems);
//                           if (isSel) {
//                             newSel.remove(opt.name);
//                           } else {
//                             newSel.add(opt);
//                           }
//                           onSelectionChanged(newSel);
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 10),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   opt.name,
//                                   style: TextStyle(
//                                     fontSize: 15.sp,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                               ),
//                               if (isSel)
//                                 const Icon(Icons.check, color: Colors.black),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   }
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
class DDMSSelectableList extends StatelessWidget {
  final List<UdfOptionsModel> options;
  final List<UdfOptionsModel> selectedItems;
  final ValueChanged<List<UdfOptionsModel>> onSelectionChanged;
  final bool showCheckboxes;

  const DDMSSelectableList({
    super.key,
    required this.options,
    required this.selectedItems,
    required this.onSelectionChanged,
    this.showCheckboxes = true,
  });

  @override
  Widget build(BuildContext context) {
    print(options);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectedItems.isNotEmpty && showCheckboxes)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    selectedItems.map((item) {
                      return Container(
                        margin: EdgeInsets.only(right: 4.w),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(
                            color: Color.fromRGBO(0, 0, 0, 0.12),
                          ),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              child: Text(
                                item.name,
                                style: TextStyle(fontSize: 13.sp),
                              ),
                            ),
                            Positioned(
                              top: -6,
                              right: -6,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8.r),
                                onTap: () {
                                  final newSel = List<UdfOptionsModel>.from(
                                    selectedItems,
                                  )..removeWhere((v) => v.id == item.id);
                                  onSelectionChanged(newSel);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.w,
                                    ),
                                    color: Color.fromRGBO(233, 233, 233, 1),
                                  ),
                                  child: const Icon(Icons.close, size: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: ListView.separated(
                separatorBuilder:
                    (_, __) =>
                        Divider(height: 0.5.h, color: AppColors.dividerColor),
                itemCount: options.length,
                padding: EdgeInsets.zero,
                itemBuilder: (ctx, i) {
                  final opt = options[i];
                  final isSel = selectedItems.any((item) => item.id == opt.id);

                  if (showCheckboxes) {
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // Fixed: Use UdfOptionsModel instead of String
                          final newSel = List<UdfOptionsModel>.from(
                            selectedItems,
                          );
                          if (isSel) {
                            newSel.removeWhere((item) => item.id == opt.id);
                          } else {
                            newSel.add(opt);
                          }
                          onSelectionChanged(newSel);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 9.5.h),
                          child: Row(
                            children: [
                              // Checkbox
                              Theme(
                                data: Theme.of(context).copyWith(
                                  checkboxTheme: CheckboxThemeData(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.r),
                                    ),
                                    side: BorderSide(
                                      color: AppColors.darkBlack,
                                      width: 1.w,
                                    ),
                                    fillColor:
                                        WidgetStateProperty.resolveWith<Color>((
                                          states,
                                        ) {
                                          if (states.contains(
                                            WidgetState.selected,
                                          )) {
                                            return AppColors.primaryColor;
                                          }
                                          return Colors.white;
                                        }),
                                    checkColor: WidgetStateProperty.all<Color>(
                                      Colors.white,
                                    ),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ),
                                child: SizedBox(
                                  width: 13.5.w,
                                  height: 13.5.h,
                                  child: Checkbox(
                                    value: isSel,
                                    onChanged: (b) {
                                      final newSel = List<UdfOptionsModel>.from(
                                        selectedItems,
                                      );
                                      if (b == true) {
                                        newSel.add(opt);
                                      } else {
                                        newSel.removeWhere(
                                          (item) => item.id == opt.id,
                                        );
                                      }
                                      onSelectionChanged(newSel);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              // Text
                              Expanded(
                                child: Text(
                                  opt.name,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    // Non-checkbox multiple selection mode with check icons on right
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          final newSel = List<UdfOptionsModel>.from(
                            selectedItems,
                          );
                          if (isSel) {
                            // Fixed: Remove by comparing id instead of comparing UdfOptionsModel with String
                            newSel.removeWhere((item) => item.id == opt.id);
                          } else {
                            newSel.add(opt);
                          }
                          onSelectionChanged(newSel);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  opt.name,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              if (isSel)
                                const Icon(Icons.check, color: Colors.black),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomCheckbox extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const CustomCheckbox({
    Key? key,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.initialValue;
  }

  void _toggleCheckbox() {
    setState(() => isChecked = !isChecked);
    widget.onChanged(isChecked);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: isChecked ? Colors.blue : Colors.transparent,
          border: Border.all(color: Colors.grey, width: 1.5),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(Icons.check, size: 10, color: Colors.white),
      ),
    );
  }
}
