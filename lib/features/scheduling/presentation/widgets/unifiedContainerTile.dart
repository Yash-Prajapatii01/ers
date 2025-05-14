import 'package:ers_linux/features/scheduling/presentation/widgets/unifiedCalender.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/showBottomSheet.dart';
import 'CustomTextField.dart';
enum TileInteractionType {
  simple, // Basic tile with no special interaction
  navigation, // Navigates to a new page
  bottomSheet, // Opens a bottom sheet
  popupMenu, // Shows a popup menu
  expandable, // Expands to show more content
  ddms, // Dynamic Data Multiple Selection
}

class UnifiedContainerTile extends StatefulWidget {
  // Common properties
  final String title;
  final String? iconPath;
  final String? itemText;

  // Appearance properties
  final Color? backgroundColor;
  final Color? borderColor;
  // final GlobalKey? popupmenukey;

  // Interaction type flags
  final TileInteractionType interactionType;

  // For navigation type
  final Widget? navigationTarget;

  // For bottom sheet type
  final Widget? bottomSheetContent;
  final bool? isDonethere;
  final bool? fullSizeBottomSheet;

  // For popup menu type
  final List<String>? options;
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
  final bool? isColorPalleteNeeded;
  final List<TextInputFormatter>? inputFormatters;

  // For action callbacks
  final Function(String)? onOptionSelected;
  final Function(List<String>)? onMultipleOptionsSelected;
  final Function(double)? onSliderChanged;
  final Function(String)? onTextChanged;
  final VoidCallback? onDone;

  const UnifiedContainerTile({
    super.key,
    required this.title,
    this.iconPath,
    this.itemText,
    this.interactionType = TileInteractionType.simple,
    this.backgroundColor = Colors.white,
    this.borderColor = const Color.fromRGBO(208, 213, 221, 1),

    // Navigation properties
    this.navigationTarget,

    // Bottom sheet properties
    this.bottomSheetContent,
    this.isDonethere = true,

    // Popup menu properties
    this.options,
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
    this.isColorPalleteNeeded,
    this.inputFormatters,

    // Callbacks
    this.onOptionSelected,
    this.onMultipleOptionsSelected,
    this.onSliderChanged,
    this.onTextChanged,
    this.onDone,
    this.fullSizeBottomSheet = false,
    // this.popupmenukey,
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
    if (widget.options == null || widget.options!.isEmpty) return;

    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset offset = box.localToGlobal(Offset.zero);
    final Size size = box.size;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final RelativeRect pos = RelativeRect.fromLTRB(
      offset.dx + size.width - 200,
      offset.dy - (51.2 * (widget.options?.length ?? 0)) - 10.0,
      overlay.size.width - offset.dx - size.width,
      offset.dy,
    );

    final items = <PopupMenuEntry<String>>[];

    for (var i = 0; i < (widget.options?.length ?? 0); i++) {
      items.add(
        PopupMenuItem<String>(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          height: 48,
          value: widget.options![i],
          child: SizedBox(
            width: 170,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.options![i] == _selectedOption)
                  const Icon(Icons.check, size: 16, color: Colors.black)
                else
                  const SizedBox(width: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.options![i],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          widget.options![i] == _selectedOption
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

      if (i < widget.options!.length - 1) {
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
  // Future<void> _showPopupMenu()async {
  //   await CustomPopupMenu.show(
  //     context: context,
  //     options: widget.options!,
  //     widgetKey: widget.popupmenukey,
  //     selectedOption: _selectedOption,
  //     onSelected: (value) {
  //       setState(() {
  //         _selectedOption = value;
  //       });
  //       widget.onOptionSelected?.call(value);
  //     },
  //     isReverse: true,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTileTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: widget.borderColor ?? const Color.fromRGBO(208, 213, 221, 1),
            width: 0.5,
          ),
        ),
        child: Column(
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
      ),
    );
  }

  Widget _buildTrailingWidget() {
    switch (widget.interactionType) {
      case TileInteractionType.navigation:
        return const Icon(Icons.chevron_right, color: Colors.grey);

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
            const Icon(
              Icons.keyboard_arrow_down,
              color: Color.fromRGBO(102, 112, 133, 0.5),
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
                  _effortController.text.isNotEmpty
                      ? _effortController.text.trim()
                      : "Add",
                  Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: _showPopupMenu,
                child: Row(
                  children: [
                    PillText(
                      _selectedOption.isEmpty
                          ? (widget.options?.isNotEmpty == true
                              ? widget.options!.first
                              : "Select")
                          : _selectedOption,
                      Colors.black,
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

      case TileInteractionType.ddms:
        return Row(
          children: [
            Text(
              _selectedOptions.isNotEmpty
                  ? "${_selectedOptions.first} +${_selectedOptions.length - 1}"
                  : "Select",
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromRGBO(102, 112, 133, 0.5),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        );

      case TileInteractionType.simple:
        return const SizedBox();
    }
  }

  Widget _buildSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
        const SizedBox(height: 12),
        SliderTheme(
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
      ],
    );
  }
}
