import 'package:ers_linux/features/scheduling/data/models/udfOptionsModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../utils/showBottomSheet.dart';
import '../shared/CustomTextField.dart';
import '../shared/PillText.dart';
import 'tile_interaction_type.dart';

class UnifiedContainerTile extends StatefulWidget {
  // Common properties
  final String title;
  final String? iconPath;
  final String? itemText;
  final bool? isRequired;

  // Appearance properties
  final Color? backgroundColor;
  final Color? borderColor;

  // Interaction type flags
  final TileInteractionType interactionType;

  // For navigation type
  final Widget? navigationTarget;

  // For bottom sheet type
  final Widget? bottomSheetContent;
  final bool? isDoneButtonNeeded;
  final bool? fullSizeBottomSheet;

  // For popup menu type
  final List<String>? popMenuOptions;
  final bool? isPinTextNeeded;
  final String? initialSelectedOption;

  // For expandable type
  final bool initiallyExpanded;
  final Widget? expandedContent;
  final double? initialSliderValue;

  // For DDMS type
  final List<String>? initialSelectedOptions;

  // For bottom sheet options
  final bool? isSearchEnabled;
  final bool? isTextFieldNeeded;
  final CustomTextField? customTextField;
  final bool? isDateWidget;
  final bool? isTimeWidget;
  final bool? isFTRCalender;
  final bool? isColorPaletteNeeded;
  final List<TextInputFormatter>? inputFormatters;

  // For action callbacks
  final Function(String)? onOptionSelected;
  final Function(List<int>)? onMultipleOptionsSelected;
  final Function(double)? onSliderChanged;
  final Function(double)? onFieldFilled;
  final Function(String)? onDateSelected;
  final Function(DateTime)? onDateTimeSelected;

  // final Function(String)? onTextChanged;

  const UnifiedContainerTile({
    super.key,
    required this.title,
    this.iconPath,
    this.itemText,
    this.interactionType = TileInteractionType.none,
    this.backgroundColor = Colors.white,
    this.borderColor = const Color.fromRGBO(208, 213, 221, 1),
    this.isRequired = false,

    // Navigation properties
    this.navigationTarget,

    // Bottom sheet properties
    this.bottomSheetContent,
    this.isDoneButtonNeeded = true,

    // Popup menu properties
    this.popMenuOptions,
    this.isPinTextNeeded = false,
    this.initialSelectedOption,

    // Expandable properties
    this.initiallyExpanded = false,
    this.expandedContent,
    this.initialSliderValue = 0.0,

    // DDMS properties
    this.initialSelectedOptions,

    // Bottom sheet options
    this.isSearchEnabled,
    this.isTextFieldNeeded,
    this.customTextField,
    this.isDateWidget,
    this.isTimeWidget,
    this.isFTRCalender,
    this.isColorPaletteNeeded,
    this.inputFormatters,

    // Callbacks
    this.onOptionSelected,
    this.onMultipleOptionsSelected,
    this.onSliderChanged,
    this.onFieldFilled,
    this.onDateSelected,
    this.onDateTimeSelected,
    // this.onTextChanged,
    this.fullSizeBottomSheet = false,
  });

  @override
  State<UnifiedContainerTile> createState() => _UnifiedContainerTileState();
}

class _UnifiedContainerTileState extends State<UnifiedContainerTile> {
  late String _trailingText;
  String _selectedOption = '';
  List<UdfOptionsModel> _selectedOptions = [];
  bool _isExpanded = false;
  double _sliderValue = 0.0;
  final TextEditingController _effortController = TextEditingController();
  Color? selectedColor;
  String? selectedLabel;

  @override
  void initState() {
    super.initState();
    _trailingText = widget.itemText ?? '';
    _selectedOption = widget.initialSelectedOption ?? '';
    // _selectedOptions = widget.initialSelectedOptions?.toList() ?? [];
    _isExpanded = widget.initiallyExpanded;
    _sliderValue = widget.initialSliderValue ?? 0.0;
  }

  @override
  void dispose() {
    _effortController.dispose();
    super.dispose();
  }

  void _handleTileTap() {
    switch (widget.interactionType) {
      case TileInteractionType.navigation:
        if (widget.navigationTarget != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => widget.navigationTarget!),
          );
        }
        break;
      case TileInteractionType.popupMenu:
        _showPopupMenu();
        break;
      case TileInteractionType.bottomSheet:
        if (widget.bottomSheetContent != null) {
          BottomSheetService.showCustomBottomSheet(
            context: context,
            child: widget.bottomSheetContent!,
            startFullSize: widget.fullSizeBottomSheet ?? true,
            // onSelected: (result) {
            //   if (result is List<UdfOptionsModel>) {
            //     setState(() {
            //       // Handle multiple selections from DDMS
            //       _selectedOptions = result;
            //
            //       if (result.isNotEmpty) {
            //         final firstItem = result.first;
            //         final extraCount = result.length - 1;
            //
            //         // Check what type of data the first item contains
            //         if (firstItem.color != null && firstItem.name.isNotEmpty) {
            //           // Case: label-color (has both label and color)
            //           selectedLabel = firstItem.name;
            //           selectedColor = firstItem.color;
            //           _itemText = extraCount > 0
            //               ? '${firstItem.name} +$extraCount'
            //               : firstItem.name;
            //           widget.onOptionSelected?.call(_itemText);
            //
            //         } else if (firstItem.color != null && (firstItem.name.isEmpty || firstItem.name == '')) {
            //           // Case: color only (has color but no meaningful label)
            //           selectedLabel = null;
            //           selectedColor = firstItem.color;
            //           _itemText = extraCount > 0
            //               ? 'Color +$extraCount'
            //               : '';
            //           widget.onOptionSelected?.call(selectedColor.toString());
            //
            //         } else {
            //           // Case: text only (has label/name but no color)
            //           selectedLabel = null;
            //           selectedColor = null;
            //           _itemText = extraCount > 0
            //               ? '${firstItem.name} +$extraCount'
            //               : firstItem.name;
            //           widget.onOptionSelected?.call(_itemText);
            //         }
            //
            //         // If you need to pass the selected indices/IDs to a callback
            //         final selectedIds = result.map((item) => item.id).toList();
            //         widget.onMultipleOptionsSelected?.call(selectedIds);
            //       } else {
            //         // No selections - reset everything
            //         selectedLabel = null;
            //         selectedColor = null;
            //         _itemText = '';
            //       }
            //     });
            //   } else if (result is Map<String, dynamic>) {
            //     // Handle other types of results (your existing logic)
            //     setState(() {
            //       switch (result['type']) {
            //         case 'label-color':
            //           selectedLabel = result['label'];
            //           selectedColor = result['color'];
            //           _itemText = selectedLabel!;
            //           widget.onOptionSelected?.call(selectedLabel!);
            //           break;
            //         case 'color':
            //           final int? colorVal = int.tryParse(result['color']);
            //           if (colorVal != null) {
            //             selectedLabel = null;
            //             selectedColor = Color(colorVal);
            //             _itemText = '';
            //             widget.onOptionSelected?.call(selectedColor.toString());
            //           }
            //           break;
            //         case 'text':
            //           selectedLabel = null;
            //           selectedColor = null;
            //           _itemText = result['text'];
            //           widget.onOptionSelected?.call(result['text']);
            //           break;
            //       }
            //     });
            //   }
            // },//todo v2
            // onSelected: (result) {
            //   if (result is List<UdfOptionsModel>) {
            //     setState(() {
            //       switch (result['type']) {
            //         case 'label-color':
            //           selectedLabel = result['label'];
            //           selectedColor = result['color'];
            //           _itemText = selectedLabel!;
            //           widget.onOptionSelected?.call(selectedLabel!);
            //           // widget.onTextChanged?.call(selectedLabel!);
            //           break;
            //         case 'color':
            //           final int? colorVal = int.tryParse(result['color']);
            //           if (colorVal != null) {
            //             selectedLabel = null;
            //             selectedColor = Color(colorVal);
            //             _itemText = '';
            //             widget.onOptionSelected?.call(selectedColor.toString());
            //             // widget.onTextChanged?.call('');
            //           }
            //           break;
            //         case 'text':
            //           selectedLabel = null;
            //           selectedColor = null;
            //           _itemText = result['text'];
            //           widget.onOptionSelected?.call(result['text']);
            //           break;
            //       }
            //     });
            //   }
            // },
            onSelected: (result) {
              print("result -$result");
              print(result.runtimeType);
              if (result is List<UdfOptionsModel>) {
                setState(() {
                  // Store the selected options
                  _selectedOptions = result;

                  if (result.isNotEmpty) {
                    final firstItem = result.first;
                    final extraCount = result.length - 1;

                    // Check what type of data the first item contains
                    if (firstItem.color != Colors.transparent && firstItem.name.isNotEmpty) {
                      // Case: label-color (has both label and color)
                      selectedLabel = firstItem.name;
                      selectedColor = firstItem.color;
                      _trailingText = extraCount > 0
                          ? '${firstItem.name} +$extraCount'
                          : firstItem.name;

                    } else if (firstItem.color != Colors.transparent && (firstItem.name.isEmpty || firstItem.name == '')) {
                      // Case: color only (has color but no meaningful label)
                      selectedLabel = null;
                      selectedColor = firstItem.color;
                      _trailingText = extraCount > 0
                          ? 'Color +$extraCount'
                          : '';

                    } else {
                      // Case: text only (has label/name but no color)
                      selectedLabel = null;
                      selectedColor = null;
                      _trailingText = extraCount > 0
                          ? '${firstItem.name} +$extraCount'
                          : firstItem.name;
                    }

                    // Extract IDs and call the callback
                    final selectedIds = result.map((item) => item.id).toList();
                    widget.onMultipleOptionsSelected?.call(selectedIds);

                    // Also call single option callback with display text
                    widget.onOptionSelected?.call(_trailingText);

                  } else {
                    // No selections - reset everything
                    selectedLabel = null;
                    selectedColor = null;
                    _trailingText = '';
                    widget.onMultipleOptionsSelected?.call([]);
                  }
                });}
              // ───────────────────────────────────────
              // 2. String Result Branch (MISSING)
              // ───────────────────────────────────────
              // If bottom sheet returned a String (e.g., custom text, single selection, date string),
              // we must update the display text and bubble up to onOptionSelected.
              if (result is String) {
                setState(() {
                  _trailingText = result;
                  print("Result is String here....");
                });
                widget.onOptionSelected?.call(result);
                return;
              }

              // ───────────────────────────────────────
              // 3. Map<String, dynamic> Branch (Label + Color / Date + Time)
              // ───────────────────────────────────────
              if (result is Map<String, dynamic>) {
                setState(() {
                  print("Result is Map here....");
                  // Example: { 'label': 'Priority A', 'color': Color(0xFF...), 'type': 'label-color' }
                  switch (result['type']) {
                    case 'label-color':
                      selectedLabel = result['label'] as String?;
                      selectedColor = result['color'] as Color?;
                      _trailingText = selectedLabel ?? '';
                      widget.onOptionSelected?.call(_trailingText);
                      break;
                    case 'color':
                      final colorVal = int.tryParse(result['color'] as String);
                      if (colorVal != null) {
                        selectedLabel = null;
                        selectedColor = Color(colorVal);
                        _trailingText = ''; // You can decide how to render a pure color swatch
                        widget.onOptionSelected?.call(selectedColor!.value.toString());
                      }
                      break;
                    case 'text':
                      final textVal = result['text'] as String?;
                      if (textVal != null) {
                        selectedLabel = null;
                        selectedColor = null;
                        _trailingText = textVal;
                        widget.onOptionSelected?.call(textVal);
                      }
                      break;
                    default:
                      break;
                  }
                });
                return;
              }
              // } else if (result is Map<String, dynamic>) {
              //   // Handle other types of results (your existing logic)
              //   setState(() {
              //     switch (result['type']) {
              //       case 'label-color':
              //         selectedLabel = result['label'];
              //         selectedColor = result['color'];
              //         _itemText = selectedLabel!;
              //         widget.onOptionSelected?.call(selectedLabel!);
              //         break;
              //       case 'color':
              //         final int? colorVal = int.tryParse(result['color']);
              //         if (colorVal != null) {
              //           selectedLabel = null;
              //           selectedColor = Color(colorVal);
              //           _itemText = '';
              //           widget.onOptionSelected?.call(selectedColor.toString());
              //         }
              //         break;
              //       case 'text':
              //         selectedLabel = null;
              //         selectedColor = null;
              //         _itemText = result['text'];
              //         widget.onOptionSelected?.call(result['text']);
              //         break;
              //     }
              //   });
              // }
            },
          );
        }
        break;
      case TileInteractionType.expandable:
        setState(() {
          _isExpanded = !_isExpanded;
        });
        break;
      default:
        break;
    }
  }

  Future<void> _showPopupMenu() async {
    if (widget.popMenuOptions == null || widget.popMenuOptions!.isEmpty) return;

    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset offset = box.localToGlobal(Offset.zero);
    final Size size = box.size;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final RelativeRect pos = RelativeRect.fromLTRB(
      offset.dx + size.width - 200,
      offset.dy - (51.2 * (widget.popMenuOptions?.length ?? 0)) - 10.0,
      overlay.size.width - offset.dx - size.width,
      offset.dy,
    );

    final items = <PopupMenuEntry<String>>[];

    for (var i = 0; i < (widget.popMenuOptions?.length ?? 0); i++) {
      items.add(
        PopupMenuItem<String>(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          height: 48,
          value: widget.popMenuOptions![i],
          child: SizedBox(
            width: 170,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.popMenuOptions![i] == _selectedOption)
                  const Icon(Icons.check, size: 16, color: Colors.black)
                else
                  const SizedBox(width: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.popMenuOptions![i],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          widget.popMenuOptions![i] == _selectedOption
                              ? FontWeight.w400
                              : FontWeight.normal,
                      color: const Color.fromRGBO(39, 39, 39, 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      if (i < widget.popMenuOptions!.length - 1) {
        items.add(
          PopupMenuItem<String>(
            enabled: false, // Prevent selection
            height: 0.7,
            padding: EdgeInsets.zero,
            child: Container(
              height: 0.7,
              color: const Color.fromRGBO(102, 112, 133, 0.2),
            ),
          ),
        );
      }
    }

    final choice = await showMenu<String>(
      context: context,
      position: pos,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      elevation: 4,
      items: items,
    );

    if (choice != null && choice != _selectedOption) {
      setState(() {
        _selectedOption = choice;
      });
      if (widget.onOptionSelected != null) {
        widget.onOptionSelected!(choice);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTileTap,
      child: Container(
        // width: double.infinity,
        height: _isExpanded ? 120.w : 44.w,
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: widget.borderColor ?? AppColors.bookingContainerTileBorder,
            width: 0.5.w,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main tile content
            Row(
              children: [
                widget.iconPath != null
                    ? SvgPicture.asset(
                      'assets/icons/scheduling/booking/${widget.iconPath}.svg' ??
                          'assets/icons/scheduling/booking/email.svg',
                    )
                    : SizedBox.shrink(),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: widget.title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.darkBlack,
                      ),
                      children:
                          widget.isRequired!
                              ? [
                                TextSpan(
                                  text: '*',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ]
                              : [],
                    ),
                  ),
                ),
                _buildTrailingWidget(),
              ],
            ),
            if (_isExpanded &&
                widget.interactionType == TileInteractionType.expandable)
              _buildSlider(),
          ],
        ),
      ),
    );
  }

  Widget _buildTrailingWidget() {
    switch (widget.interactionType) {
      case TileInteractionType.navigation:
        return GestureDetector(
          onTap: _handleTileTap,
          child: Icon(
            Icons.chevron_right,
            color: AppColors.containerSelectedItem,
          ),
        );

      case TileInteractionType.bottomSheet:
        return Row(
          children: [
            if (selectedLabel != null && selectedColor != null) ...[
              // if(selectedLabel != 'None')
              // selectedColor == Colors.transparent
              //     ? Text(
              //   selectedLabel!,
              //   style: TextStyle(
              //     fontSize: 13.5.sp,
              //     fontWeight: FontWeight.w400,
              //     color: AppColors.darkBlack,
              //   ),
              // )
              //     :
              Container(
                // width: 78.w,
                // height: 24.h,
                padding:
                    selectedColor == Colors.transparent
                        ? EdgeInsets.zero
                        : EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: selectedColor,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Center(
                  child: Text(
                    selectedLabel!,
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.darkBlack,
                    ),
                  ),
                ),
              ),
            ],
            if (selectedColor != null && selectedLabel == null) ...[
              Container(
                width: 23.w,
                height: 23.w,
                decoration: BoxDecoration(
                  color: selectedColor,
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
            ],
            if (selectedColor == null) ...[
              Container(
                constraints: BoxConstraints(
                  maxWidth:
                      145.w, // how maximum of width the user input can be shown it customized here...
                ),
                child: Text(
                  _trailingText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.containerSelectedItem,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
            const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.containerSelectedItem,
            ),
          ],
        );

      case TileInteractionType.popupMenu:
        if (widget.isPinTextNeeded == true) {
          return Row(
            children: [
              GestureDetector(
                onTap:
                    () => BottomSheetService.showCustomBottomSheet(
                      context: context,
                      child: BottomSheetOptions(
                        isTextFieldNeeded: true,
                        customTextField: CustomTextField(
                          hintText: 'Effort',
                          controller: _effortController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (_) => setState(() {}),
                        ),
                        onDone: () => setState(() {}),
                      ),
                      startFullSize: false,
                      onSelected: (result) {
                        if (result is Map<String, dynamic>) {
                          setState(() {
                            // For example, handle submitted effort
                            if (result['text'] != null) {
                              _effortController.text = result['text'];
                            }
                          });
                        }
                      },
                    ),
                // () => showCustomBottomSheet(
                //   context,
                //   BottomSheetOptions(
                //     isTextFieldNeeded: true,
                //     customTextField: CustomTextField(
                //       hintText: 'Effort',
                //       controller: _effortController,
                //       inputFormatters: [
                //         FilteringTextInputFormatter.digitsOnly,
                //       ],
                //       onChanged: (_) => setState(() {}),
                //     ),
                //     onDone: () => setState(() {}),
                //   ),
                //   startFullSize: false,
                // ),
                child: PillText(
                  // width: 49,
                  height: 24.w,
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  _effortController.text.isNotEmpty
                      ? _effortController.text.trim()
                      : "Add",
                  AppColors.pillText,
                ),
              ),
              SizedBox(width: 8.w),
              InkWell(
                onTap: _showPopupMenu,
                child: Row(
                  children: [
                    PillText(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      // width: 90,
                      height: 24.w,
                      _selectedOption.isEmpty
                          ? (widget.popMenuOptions?.isNotEmpty == true
                              ? widget.popMenuOptions!.first
                              : "Select")
                          : _selectedOption,
                      AppColors.pillText,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 7.6.w,
                        vertical: 4.8.h,
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/scheduling/booking/updownarrow.svg',
                      ),
                    ),
                    // const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ],
          );
        } else {
          return InkWell(
            onTap: _showPopupMenu,
            child: Row(
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: 145.w),
                  child: Text(
                    _selectedOption.isEmpty ? "" : _selectedOption,
                    overflow: TextOverflow.ellipsis,
                    // can add 'Select for better UX'
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.containerSelectedItem,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    //todo work here for the util
                    horizontal: 8.0,
                    vertical: 5.0,
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/scheduling/booking/updownarrow.svg',
                  ),
                ),
                // const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          );
        }

      case TileInteractionType.expandable:
        return Row(
          children: [
            Text(
              '${_sliderValue.toInt()}%',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.containerSelectedItem,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.grey,
            ),
          ],
        );

      case TileInteractionType.none:
        return const SizedBox();
    }
  }

  Widget _buildSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 9.h),
        Divider(thickness: 0.5.w, color: AppColors.dividerColor),
        // const SizedBox(height: 12),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primaryColor,
            inactiveTrackColor: AppColors.pillTextBg,
            thumbColor: Colors.white,
            // overlayColor: const Color(0x330B5FFF),
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.5.r),
            trackHeight: 4,
          ),
          child: Slider(
            value: _sliderValue,
            min: 0,
            max: 100,
            divisions: 100,
            onChanged: (value) {
              setState(() {
                _sliderValue = value;
              });
              if (widget.onSliderChanged != null) {
                widget.onSliderChanged!(value);
              }
            },
          ),
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import '../../utils/showBottomSheet.dart';
// import '../PillText.dart';
// import 'tile_interaction_type.dart';
//
// /// Config classes for each interaction
// class NavigationConfig {
//   final Widget target;
//
//   NavigationConfig({required this.target});
// }
//
// class BottomSheetConfig {
//   final Widget content;
//   final bool fullSize;
//   final bool showDoneButton;
//
//   BottomSheetConfig({
//     required this.content,
//     this.fullSize = false,
//     this.showDoneButton = true,
//   });
// }
//
// class PopupMenuConfig {
//   final List<String> options;
//   final bool pinText;
//   final String? initialOption;
//
//   PopupMenuConfig({
//     required this.options,
//     this.pinText = false,
//     this.initialOption,
//   });
// }
//
// class ExpandableConfig {
//   final bool initiallyExpanded;
//   final double initialValue;
//
//   ExpandableConfig({this.initiallyExpanded = false, this.initialValue = 0.0});
// }
//
// class DdmsConfig {
//   final List<String>? initialSelections;
//
//   DdmsConfig({this.initialSelections});
// }
//
// /// UnifiedContainerTile with modular configs and full behavior
// class UnifiedContainerTile extends StatefulWidget {
//   // Common
//   final String title;
//   final String? iconPath;
//   final Color backgroundColor;
//   final Color borderColor;
//   final TileInteractionType interactionType;
//
//   // Configs
//   final NavigationConfig? navigationConfig;
//   final BottomSheetConfig? bottomSheetConfig;
//   final PopupMenuConfig? popupMenuConfig;
//   final ExpandableConfig? expandableConfig;
//   final DdmsConfig? ddmsConfig;
//
//   // Callbacks
//   final Function(String)? onOptionSelected;
//   final Function(List<String>)? onMultipleOptionsSelected;
//   final Function(double)? onSliderChanged;
//   final Function(String)? onTextChanged;
//   final VoidCallback? onDonePressed;
//
//   const UnifiedContainerTile._({
//     Key? key,
//     required this.title,
//     this.iconPath,
//     required this.backgroundColor,
//     required this.borderColor,
//     required this.interactionType,
//     this.navigationConfig,
//     this.bottomSheetConfig,
//     this.popupMenuConfig,
//     this.expandableConfig,
//     this.ddmsConfig,
//     this.onOptionSelected,
//     this.onMultipleOptionsSelected,
//     this.onSliderChanged,
//     this.onTextChanged,
//     this.onDonePressed,
//   }) : super(key: key);
//
//   factory UnifiedContainerTile.navigation({
//     required String title,
//     required Widget target,
//     String? iconPath,
//     Color backgroundColor = Colors.white,
//     Color borderColor = const Color.fromRGBO(208, 213, 221, 1),
//   }) => UnifiedContainerTile._(
//     title: title,
//     iconPath: iconPath,
//     backgroundColor: backgroundColor,
//     borderColor: borderColor,
//     interactionType: TileInteractionType.navigation,
//     navigationConfig: NavigationConfig(target: target),
//   );
//
//   factory UnifiedContainerTile.bottomSheet({
//     required String title,
//     required Widget content,
//     bool fullSize = false,
//     bool showDoneButton = true,
//     String? iconPath,
//     Color backgroundColor = Colors.white,
//     Color borderColor = const Color.fromRGBO(208, 213, 221, 1),
//     Function(String)? onTextChanged,
//     VoidCallback? onDonePressed,
//   }) => UnifiedContainerTile._(
//     title: title,
//     iconPath: iconPath,
//     backgroundColor: backgroundColor,
//     borderColor: borderColor,
//     interactionType: TileInteractionType.bottomSheet,
//     bottomSheetConfig: BottomSheetConfig(
//       content: content,
//       fullSize: fullSize,
//       showDoneButton: showDoneButton,
//     ),
//     onTextChanged: onTextChanged,
//     onDonePressed: onDonePressed,
//   );
//
//   factory UnifiedContainerTile.popupMenu({
//     required String title,
//     required List<String> options,
//     bool pinText = false,
//     String? initialOption,
//     String? iconPath,
//     Color backgroundColor = Colors.white,
//     Color borderColor = const Color.fromRGBO(208, 213, 221, 1),
//     Function(String)? onOptionSelected,
//   }) => UnifiedContainerTile._(
//     title: title,
//     iconPath: iconPath,
//     backgroundColor: backgroundColor,
//     borderColor: borderColor,
//     interactionType: TileInteractionType.popupMenu,
//     popupMenuConfig: PopupMenuConfig(
//       options: options,
//       pinText: pinText,
//       initialOption: initialOption,
//     ),
//     onOptionSelected: onOptionSelected,
//   );
//
//   factory UnifiedContainerTile.expandable({
//     required String title,
//     bool initiallyExpanded = false,
//     double initialValue = 0.0,
//     String? iconPath,
//     Color backgroundColor = Colors.white,
//     Color borderColor = const Color.fromRGBO(208, 213, 221, 1),
//     Function(double)? onSliderChanged,
//   }) => UnifiedContainerTile._(
//     title: title,
//     iconPath: iconPath,
//     backgroundColor: backgroundColor,
//     borderColor: borderColor,
//     interactionType: TileInteractionType.expandable,
//     expandableConfig: ExpandableConfig(
//       initiallyExpanded: initiallyExpanded,
//       initialValue: initialValue,
//     ),
//     onSliderChanged: onSliderChanged,
//   );
//
//   factory UnifiedContainerTile.ddms({
//     required String title,
//     List<String>? initialSelections,
//     String? iconPath,
//     Color backgroundColor = Colors.white,
//     Color borderColor = const Color.fromRGBO(208, 213, 221, 1),
//     Function(List<String>)? onMultipleOptionsSelected,
//   }) => UnifiedContainerTile._(
//     title: title,
//     iconPath: iconPath,
//     backgroundColor: backgroundColor,
//     borderColor: borderColor,
//     interactionType: TileInteractionType.ddms,
//     ddmsConfig: DdmsConfig(initialSelections: initialSelections),
//     onMultipleOptionsSelected: onMultipleOptionsSelected,
//   );
//
//   @override
//   State<UnifiedContainerTile> createState() => _UnifiedContainerTileState();
// }
//
// class _UnifiedContainerTileState extends State<UnifiedContainerTile> {
//   late String _itemText;
//   late String _selectedOption;
//   late List<String> _selectedOptions;
//   late bool _isExpanded;
//   late double _sliderValue;
//   final TextEditingController _effortController = TextEditingController();
//   Color? selectedColor;
//   String? selectedLabel;
//
//   @override
//   void initState() {
//     super.initState();
//     _itemText = '';
//     _selectedOption = widget.popupMenuConfig?.initialOption ?? '';
//     _selectedOptions = widget.ddmsConfig?.initialSelections?.toList() ?? [];
//     _isExpanded = widget.expandableConfig?.initiallyExpanded ?? false;
//     _sliderValue = widget.expandableConfig?.initialValue ?? 0.0;
//   }
//
//   @override
//   void dispose() {
//     _effortController.dispose();
//     super.dispose();
//   }
//
//   void _handleTap() {
//     switch (widget.interactionType) {
//       case TileInteractionType.navigation:
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => widget.navigationConfig!.target),
//         );
//         break;
//       case TileInteractionType.bottomSheet:
//         BottomSheetService.showCustomBottomSheet(
//           context: context,
//           child: widget.bottomSheetConfig!.content,
//           startFullSize: widget.bottomSheetConfig!.fullSize,
//           onSelected: (result) {
//             if (result is Map<String, dynamic>) {
//               setState(() {
//                 switch (result['type']) {
//                   case 'label-color':
//                     selectedLabel = result['label'];
//                     selectedColor = result['color'];
//                     _itemText = selectedLabel!;
//                     widget.onTextChanged?.call(selectedLabel!);
//                     break;
//                   case 'color':
//                     final int? val = int.tryParse(result['color']);
//                     if (val != null) {
//                       selectedColor = Color(val);
//                       _itemText = '';
//                       widget.onTextChanged?.call('');
//                     }
//                     break;
//                   case 'text':
//                     _itemText = result['text'];
//                     widget.onTextChanged?.call(_itemText);
//                     break;
//                 }
//               });
//             }
//             widget.onDonePressed?.call();
//           },
//         );
//         break;
//       case TileInteractionType.expandable:
//         setState(() => _isExpanded = !_isExpanded);
//         break;
//       default:
//         break;
//     }
//   }
//
//   Future<void> _showPopupMenu() async {
//     final opts = widget.popupMenuConfig!.options;
//     if (opts.isEmpty) return;
//     final box = context.findRenderObject() as RenderBox;
//     final pos = RelativeRect.fromLTRB(
//       box.localToGlobal(Offset.zero).dx,
//       box.localToGlobal(Offset.zero).dy,
//       0,
//       0,
//     );
//     final choice = await showMenu<String>(
//       context: context,
//       position: pos,
//       items:
//           opts
//               .map((opt) => PopupMenuItem(value: opt, child: Text(opt)))
//               .toList(),
//     );
//     if (choice != null && choice != _selectedOption) {
//       setState(() => _selectedOption = choice);
//       widget.onOptionSelected?.call(choice);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _handleTap,
//       child: Container(
//         height: _isExpanded ? 125 : 46,
//         padding: const EdgeInsets.symmetric(horizontal: 13.5, vertical: 9.5),
//         decoration: BoxDecoration(
//           color: widget.backgroundColor,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: widget.borderColor, width: 0.5),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 if (widget.iconPath != null) SvgPicture.asset(widget.iconPath!),
//                 if (widget.iconPath != null) SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     widget.title,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w400,
//                       color: Color(0xFF212121),
//                     ),
//                   ),
//                 ),
//                 _buildTrailing(),
//               ],
//             ),
//             if (_isExpanded &&
//                 widget.interactionType == TileInteractionType.expandable)
//               _buildSlider(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTrailing() {
//     switch (widget.interactionType) {
//       case TileInteractionType.navigation:
//         return Icon(Icons.chevron_right, color: Colors.grey);
//       case TileInteractionType.bottomSheet:
//         if (selectedLabel != null && selectedColor != null) {
//           return Container(
//             width: 80,
//             height: 25,
//             decoration: BoxDecoration(
//               color: selectedColor,
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: Center(
//               child: Text(selectedLabel!, style: TextStyle(fontSize: 14)),
//             ),
//           );
//         }
//         if (selectedColor != null) {
//           return Container(
//             width: 24,
//             height: 24,
//             decoration: BoxDecoration(
//               color: selectedColor,
//               borderRadius: BorderRadius.circular(5),
//             ),
//           );
//         }
//         return Row(
//           children: [
//             Text(_itemText, overflow: TextOverflow.ellipsis),
//             Icon(Icons.keyboard_arrow_down, color: Color(0xFF667085)),
//           ],
//         );
//       case TileInteractionType.popupMenu:
//         if (widget.popupMenuConfig!.pinText) {
//           return Row(
//             children: [
//               GestureDetector(
//                 onTap: _showPopupMenu,
//                 child: PillText(
//                   _effortController.text.isNotEmpty
//                       ? _effortController.text
//                       : 'Add',
//                   Colors.black,
//                   height: 24,
//                   padding: EdgeInsets.symmetric(horizontal: 8),
//                 ),
//               ),
//               SizedBox(width: 8),
//               GestureDetector(
//                 onTap: _showPopupMenu,
//                 child: PillText(
//                   _selectedOption.isEmpty
//                       ? widget.popupMenuConfig!.options.first
//                       : _selectedOption,
//                   Colors.black,
//                   height: 24,
//                   padding: EdgeInsets.symmetric(horizontal: 8),
//                 ),
//               ),
//             ],
//           );
//         }
//         return GestureDetector(
//           onTap: _showPopupMenu,
//           child: Row(
//             children: [
//               Text(_selectedOption, overflow: TextOverflow.ellipsis),
//               SizedBox(width: 4),
//               SvgPicture.asset(
//                 'assets/icons/scheduling/booking/updownarrow.svg',
//               ),
//             ],
//           ),
//         );
//       case TileInteractionType.expandable:
//         return Row(
//           children: [
//             Text(
//               '${_sliderValue.toInt()}%',
//               style: TextStyle(fontSize: 14, color: Color(0xFF667085)),
//             ),
//             Icon(
//               _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
//               color: Colors.grey,
//             ),
//           ],
//         );
//       case TileInteractionType.ddms:
//         final display =
//             _selectedOptions.isNotEmpty
//                 ? '\${_selectedOptions.first} +\${_selectedOptions.length-1}'
//                 : 'Select';
//         return Row(
//           children: [
//             Text(
//               display,
//               style: TextStyle(fontSize: 14, color: Color(0xFF667085)),
//             ),
//             Icon(Icons.chevron_right, color: Colors.grey),
//           ],
//         );
//       default:
//         return SizedBox.shrink();
//     }
//   }
//
//   Widget _buildSlider() {
//     return Column(
//       children: [
//         Divider(thickness: 0.7, color: Color(0xFFE0E0E0)),
//         Slider(
//           value: _sliderValue,
//           min: 0,
//           max: 100,
//           divisions: 100,
//           onChanged: (v) {
//             setState(() => _sliderValue = v);
//             widget.onSliderChanged?.call(v);
//           },
//         ),
//       ],
//     );
//   }
// }
