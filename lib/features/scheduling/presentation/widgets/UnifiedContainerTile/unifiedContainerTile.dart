import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/showBottomSheet.dart';
import '../CustomTextField.dart';
import '../PillText.dart';
import 'tile_interaction_type.dart';


class UnifiedContainerTile extends StatefulWidget {
  // Common properties
  final String title;
  final String? iconPath;
  final String? itemText;

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
  final Function(List<String>)? onMultipleOptionsSelected;
  final Function(double)? onSliderChanged;
  final Function(String)? onTextChanged;
  final VoidCallback? onDonePressed;

  const UnifiedContainerTile({
    super.key,
    required this.title,
    this.iconPath,
    this.itemText,
    this.interactionType = TileInteractionType.none,
    this.backgroundColor = Colors.white,
    this.borderColor = const Color.fromRGBO(208, 213, 221, 1),

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
    this.onTextChanged,
    this.onDonePressed,
    this.fullSizeBottomSheet = false,
  });

  @override
  State<UnifiedContainerTile> createState() => _UnifiedContainerTileState();
}
class _UnifiedContainerTileState extends State<UnifiedContainerTile> {
  late String _itemText;
  String _selectedOption = '';
  List<String> _selectedOptions = [];
  bool _isExpanded = false;
  double _sliderValue = 0.0;
  final TextEditingController _effortController = TextEditingController();
  Color? selectedColor;
  String? selectedLabel;

  @override
  void initState() {
    super.initState();
    _itemText = widget.itemText ?? '';
    _selectedOption = widget.initialSelectedOption ?? '';
    _selectedOptions = widget.initialSelectedOptions?.toList() ?? [];
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
      case TileInteractionType.bottomSheet:
        if (widget.bottomSheetContent != null) {
          if (widget.bottomSheetContent != null) {
            BottomSheetService.showCustomBottomSheet(
              context: context,
              child: widget.bottomSheetContent!,
              startFullSize: widget.fullSizeBottomSheet ?? true,
              onSelected: (result) {
                if (result is Map<String, dynamic>) {
                  setState(() {
                    switch (result['type']) {
                      case 'label-color':
                        selectedLabel = result['label'];
                        selectedColor = result['color'];
                        _itemText = selectedLabel!;
                        widget.onTextChanged?.call(selectedLabel!);
                        break;
                      case 'color':
                        final int? colorVal = int.tryParse(result['color']);
                        if (colorVal != null) {
                          selectedLabel = null;
                          selectedColor = Color(colorVal);
                          _itemText = '';
                          widget.onTextChanged?.call('');
                        }
                        break;
                      case 'text':
                        selectedLabel = null;
                        selectedColor = null;
                        _itemText = result['text'];
                        widget.onTextChanged?.call(result['text']);
                        break;
                    }
                  });
                }
              },
            );
          }
          break;
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
    return Container(
      // width: double.infinity,
      height: _isExpanded ? 125 : 46,
      padding: const EdgeInsets.symmetric(horizontal: 13.5, vertical: 9.5),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.borderColor ?? const Color.fromRGBO(208, 213, 221, 1),
          width: 0.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main tile content
          Row(
            children: [
              widget.iconPath != null ? SvgPicture.asset(widget.iconPath ?? 'assets/icons/scheduling/booking/email.svg') : SizedBox.shrink(),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF212121),
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
    );
  }

  Widget _buildTrailingWidget() {
    switch (widget.interactionType) {
      case TileInteractionType.navigation:
        return GestureDetector(onTap: _handleTileTap,child: const Icon(Icons.chevron_right, color: Colors.grey));

      case TileInteractionType.bottomSheet:
        return Row(
          children: [
            if (selectedLabel != null && selectedColor != null) ...[
              // if(selectedLabel != 'None')
                Container(
                  width: 80,
                  height: 25,
                  decoration: BoxDecoration(
                    color: selectedColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      selectedLabel!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
            ],
            if (selectedColor != null && selectedLabel == null) ...[
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: selectedColor,
                  borderRadius: BorderRadius.circular(5)
                ),
              ),
            ] ,if(selectedColor == null) ...[
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 150 // how maximum of width the user input can be shown it customized here...
                  ),
                  child: Text(
                    _itemText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(102, 112, 133, 0.5),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
            ],
            GestureDetector(
            onTap: _handleTileTap,
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: Color.fromRGBO(102, 112, 133, 0.5),
              ),
            ),
          ],
        );

      case TileInteractionType.popupMenu:
        if (widget.isPinTextNeeded == true) {
          return Row(
            children: [
              GestureDetector(
                onTap: () => BottomSheetService.showCustomBottomSheet(
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
                  height: 24,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  _effortController.text.isNotEmpty
                      ? _effortController.text.trim()
                      : "Add",
                  Color.fromRGBO(102, 112, 133, 0.5),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: _showPopupMenu,
                child: Row(
                  children: [
                    PillText(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      // width: 90,
                      height: 24,
                      _selectedOption.isEmpty
                          ? (widget.popMenuOptions?.isNotEmpty == true
                              ? widget.popMenuOptions!.first
                              : "Select")
                          : _selectedOption,
                      Color.fromRGBO(102, 112, 133, 0.5),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
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
              ),
            ],
          );
        } else {
          return InkWell(
            onTap: _showPopupMenu,
            child: Row(
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 130
                  ),
                  child: Text(
                    _selectedOption.isEmpty ? "" : _selectedOption,
                    overflow: TextOverflow.ellipsis,
                    // can add 'Select for better UX'
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(102, 112, 133, 0.5),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '${_sliderValue.toInt()}%',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color.fromRGBO(102, 112, 133, 0.5),
                  overflow: TextOverflow.ellipsis,
                ),
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
        const SizedBox(height: 12),
        const Divider(thickness: 0.7, color: Color(0xFFE0E0E0)),
        // const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xff1C79D4),
              inactiveTrackColor: const Color(0xffF4F4F4),
              thumbColor: Colors.white,
              overlayColor: const Color(0x330B5FFF),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 13.5),
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
