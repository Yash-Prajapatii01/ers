import 'package:ers_linux/features/scheduling/presentation/widgets/priorityWheel.dart';
import 'package:ers_linux/features/scheduling/presentation/widgets/unifiedCalender.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'ColorPicker.dart';

class UnifiedContainerTile extends StatefulWidget {
  // Common properties
  final String title;
  final String iconPath;
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
    required this.iconPath,
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
  });

  @override
  State<UnifiedContainerTile> createState() => _UnifiedContainerTileState();
}

enum TileInteractionType {
  simple, // Basic tile with no special interaction
  navigation, // Navigates to a new page
  bottomSheet, // Opens a bottom sheet
  popupMenu, // Shows a popup menu
  expandable, // Expands to show more content
  ddms, // Dynamic Data Multiple Selection
}

class _UnifiedContainerTileState extends State<UnifiedContainerTile> {
  // State variables
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
          _showCustomBottomSheet(
            context,
            widget.bottomSheetContent!,
            startFullSize:
                widget.fullSizeBottomSheet ?? true, // Default to full size
          );
        }
        break;
      case TileInteractionType.expandable:
        setState(() {
          _isExpanded = !_isExpanded;
        });
        break;
      default:
        // No special handling for other types
        break;
    }
  }

  void _showCustomBottomSheet(
    BuildContext context,
    Widget child, {
    startFullSize,
  }) {
    // Use ternary operator to set initial size based on the opening option
    final double initialSize = startFullSize ? 0.90 : 0.50;

    showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // Allow tapping outside to dismiss the sheet
      isDismissible: true,
      builder:
          (_) => Container(
            // Setting a height constraint to ensure the sheet appears
            height: MediaQuery.of(context).size.height * initialSize,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: child,
          ),
    ).then((selected) {
      final bool isColorSheet =
          child is BottomSheetOptions && (child).isColorPalleteNeeded == true;
      if (selected == null) return;

      // 1) Priority picker: Map with both label & color
      if (selected is Map<String, dynamic>
          && selected['label'] is String
          && selected['color'] is Color) {
        setState(() {
          selectedLabel = selected['label'] as String;
          selectedColor = selected['color'] as Color;
          _itemText     = selectedLabel!;
        });
        widget.onTextChanged?.call(selectedLabel!);
        return;
      }

      // 2) Color‐only sheet: child.isColorPalleteNeeded == true, returns a String colorValue
      if (child is BottomSheetOptions
          && (child).isColorPalleteNeeded == true
          && selected is String) {
        final int? colorVal = int.tryParse(selected);
        if (colorVal != null) {
          setState(() {
            selectedLabel = null;              // no text label in this mode
            selectedColor = Color(colorVal);
            _itemText     = '';                // clear any old text
          });
          widget.onTextChanged?.call('');     // or call with empty
        }
        return;
      }

      // 3) Fallback for all other String‐returning sheets (dates, text, DDMS…)
      if (selected is String) {
        setState(() {
          selectedLabel = null;
          selectedColor = null;
          _itemText     = selected;
        });
        widget.onTextChanged?.call(selected);
        return;
      }

      // if (selected is Map<String, dynamic>
      //     && selected.containsKey('label')
      //     && selected.containsKey('color')
      //     && selected['label'] is String
      //     && selected['color'] is Color) {
      //   setState(() {
      //     selectedLabel = selected['label'] as String;
      //     selectedColor = selected['color'] as Color;
      //     _itemText     = selectedLabel!;
      //   });
      //
      // if (selected == null || selected.isEmpty) return;
      //
      // if (isColorSheet) {
      //   final int? colorValue = int.tryParse(selected);
      //   if (colorValue != null) {
      //     setState(() {
      //       print('Here is the color pallete !!');
      //       selectedColor = Color(colorValue);
      //       _itemText = '';
      //     });
      //   }
      //   return;
      // }
      //
      // if (isLabel) {}
      //
      // setState(() {
      //   print('Here is the else part');
      //   selectedColor = null;
      //   _itemText = selected;
      // });
      // widget.onTextChanged?.call(selected);
    });
  }

  // Show popup menu
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
                const SizedBox(width: 4), // Spacing after icon/placeholder
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
                SvgPicture.asset(widget.iconPath),
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
              if(selectedLabel != 'None')
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
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey.shade400),
                ),
              ),
            ] ,if(selectedColor == null) ...[
                Text(
                  _itemText,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(102, 112, 133, 0.5),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
            // Text(
            //   _itemText,
            //   style: const TextStyle(
            //     fontSize: 14,
            //     color: Color.fromRGBO(102, 112, 133, 0.5),
            //     overflow: TextOverflow.ellipsis,
            //   ),
            // ),
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
                onTap:
                    () => _showCustomBottomSheet(
                      context,
                      BottomSheetOptions(
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
                    ),
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
                Text(
                  _selectedOption.isEmpty ? "" : _selectedOption,
                  // can add 'Select for better UX'
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
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

class BottomSheetOptions extends StatefulWidget {
  final String title;
  final List<String>? options;
  final VoidCallback? onDone;
  final bool? isSearchEnabled;
  final bool? isTextFieldNeeded;
  final CustomTextField? customTextField;
  final bool? isDateWidget;
  final bool? isTimeWidget;
  final bool? isDragHandleNeeded;
  final bool? isPriority;

  // final bool? isFTRCalender;
  final bool? isDonethere;
  final bool? DDMS;
  final bool? showCheckboxes; // New property to control DDMS display mode
  final bool? isColorPalleteNeeded;
  final List<String>? initialSelectedOptions;
  final List<TextInputFormatter>? inputFormatters;
  final DateTime? initialDate;
  final TimeOfDay? initialFromTime;

  const BottomSheetOptions({
    super.key,
    this.title = 'Choose',
    this.options,
    this.onDone,
    this.isSearchEnabled,
    this.isTextFieldNeeded,
    this.customTextField,
    this.isDateWidget = false,
    this.isTimeWidget = false,
    this.isDonethere = true,
    this.DDMS = false,
    this.showCheckboxes =
        true, // Default to checkbox mode for backward compatibility
    this.isColorPalleteNeeded = false,
    this.initialSelectedOptions,
    this.inputFormatters,
    this.isDragHandleNeeded = true,
    this.initialDate,
    this.initialFromTime,
    this.isPriority,
    // this.isFTRCalender,
  });

  @override
  State<BottomSheetOptions> createState() => _BottomSheetOptionsState();
}

class _BottomSheetOptionsState extends State<BottomSheetOptions> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedOption;
  String textValue = '';
  List<String> _filteredOptions = [];
  List<String> _ddmsSelections = [];
  late DateTime _localDate;
  late bool _timePicked = false;
  late TimeOfDay _localTime;
  late Color _localColor;
  String _pickedLabel = 'None';
  Color  _pickedColor = Colors.transparent;

  @override
  void initState() {
    super.initState();

    _localColor = Colors.transparent;
    _localDate = widget.initialDate ?? DateTime.now();
    _localTime = widget.initialFromTime ?? TimeOfDay.now();

    _filteredOptions = widget.options ?? [];
    if (widget.DDMS == true && widget.initialSelectedOptions != null) {
      _ddmsSelections.addAll(widget.initialSelectedOptions!);
    }
    if (widget.isSearchEnabled == true) {
      _searchController.addListener(_onSearchChanged);
    }
  }

  void _onSearchChanged() {
    final q = _searchController.text.toLowerCase();
    setState(() {
      _filteredOptions =
          (widget.options ?? [])
              .where((o) => o.toLowerCase().contains(q))
              .toList();
    });
  }

  @override
  void dispose() {
    if (widget.isSearchEnabled == true) {
      _searchController.removeListener(_onSearchChanged);
    }
    _searchController.dispose();
    super.dispose();
  }

  void _handleDone() {
    String result = '';
    if (widget.DDMS == true) {
      if (_ddmsSelections.isNotEmpty) {
        final first = _ddmsSelections.first;
        final extra = _ddmsSelections.length - 1;
        result = extra > 0 ? '$first +$extra' : first;
      }
    } else if (widget.customTextField != null) {
      result = widget.customTextField!.controller?.text.trim() ?? '';
    } else if (widget.isTextFieldNeeded == true) {
      result = textValue;
    } else if (_selectedOption != null) {
      result = _selectedOption!;
    } else if(widget.isPriority == true){
      Navigator.pop<Map<String, dynamic>>(
        context,
        {'label': _pickedLabel, 'color': _pickedColor},
      );
      return;
    }
    else if (widget.isColorPalleteNeeded == true) {
      result = _localColor.value.toString();
    } else if (widget.isDateWidget!) {
      if (widget.isTimeWidget!) {
        final TimeOfDay useTime = _timePicked ? _localTime : TimeOfDay.now();
        final dt = DateTime(
          _localDate.year,
          _localDate.month,
          _localDate.day,
          useTime.hour,
          useTime.minute,
        );
        result = DateFormat('d MMM yyyy, h:mm a').format(dt);
      } else {
        result = DateFormat('d MMM yyyy').format(_localDate);
      }
    }

    Navigator.pop(context, result);
    widget.onDone?.call();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          const Divider(height: 0.5, color: Color.fromRGBO(0, 0, 0, 0.12)),
          if (widget.isSearchEnabled == true) _buildSearchField(),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildHeader() => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (widget.isDragHandleNeeded!)
        Center(
          child: Container(
            width: 29,
            height: 4,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFD0D5DD),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: SizedBox(
          height: 50,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color.fromRGBO(242, 48, 48, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color.fromRGBO(51, 51, 51, 1),
                  ),
                ),
              ),
              if (widget.isDonethere == true)
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: _handleDone,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _buildSearchField() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: SizedBox(
      width: double.infinity,
      height: 40,
      child: TextField(
        controller: _searchController,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(102, 112, 133, 0.5),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(CupertinoIcons.search, color: Colors.grey),
                const SizedBox(width: 12),
                Container(width: 1, height: 25, color: const Color(0xFFE0E0E0)),
              ],
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 9.5,
            horizontal: 9.5,
          ),
          fillColor: const Color.fromRGBO(245, 246, 248, 1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    ),
  );

  Widget _buildContent() {
    if (widget.isColorPalleteNeeded == true) {
      return Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ColorPickerGrid(
            onColorSelected:
                (c) => setState(() {
                  _localColor = c;
                }),
          ),
        ),
      );
    }
    if (widget.isPriority == true) {
      return CustomWheelPicker(
          onSelected: (map) {
            setState(() {
              _pickedLabel = map['label'] as String;
              _pickedColor = map['color'] as Color;
            });
          }
      );
    }
    if (widget.isDateWidget == true && widget.isTimeWidget == true) {
      return UnifiedCalendar(
        initialDate: _localDate,
        initialFromTime: _localTime,
        showTime: true,
        onDateSelected: (combined) {
          setState(() {
            _localDate = combined;
            _localTime = TimeOfDay.fromDateTime(combined);
            _timePicked = true;
          });
        },
      );
    }
    if (widget.isDateWidget == true) {
      return UnifiedCalendar(
        initialDate: _localDate,
        initialFromTime: _localTime,
        showTime: false,
        onDateSelected:
            (v) => setState(() {
              _localDate = v;
            }),
      );
    }

    if (widget.isTextFieldNeeded == true) {
      return Expanded(
        child:
            (widget.customTextField != null)
                ? CustomTextField(
                  hintText: widget.customTextField!.hintText,
                  controller: widget.customTextField?.controller,
                  keyboardType: widget.customTextField!.keyboardType,
                  inputFormatters: widget.customTextField!.inputFormatters,
                  onChanged: (v) {
                    setState(() => textValue = v);
                    widget.customTextField!.onChanged?.call(v);
                  },
                )
                : Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    onChanged: (v) {
                      setState(() {
                        textValue = v;
                      });
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    expands: true,
                    style: const TextStyle(fontSize: 16),
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Type Something...',
                    ),
                  ),
                ),
      );
    }

    // DDMS multi-selection with new checkbox/non-checkbox mode toggle
    if (widget.DDMS == true) {
      return _DDMSSelectableList(
        options: _filteredOptions,
        selectedItems: _ddmsSelections,
        onSelectionChanged:
            (newSel) => setState(() => _ddmsSelections = newSel),
        showCheckboxes:
            widget.showCheckboxes ?? true, // Pass the checkbox display mode
      );
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.separated(
          separatorBuilder:
              (_, __) => const Divider(
                height: 0.5,
                color: Color.fromRGBO(0, 0, 0, 0.12),
              ),
          itemCount: _filteredOptions.length,
          padding: EdgeInsets.zero,
          itemBuilder: (ctx, i) {
            final opt = _filteredOptions[i];
            final sel = opt == _selectedOption;
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() => _selectedOption = opt);
                  if (widget.isDonethere == false) Navigator.pop(context, opt);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          opt,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      if (sel) const Icon(Icons.check, color: Colors.black),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final bool autofocus;
  final InputDecoration? decoration;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.focusNode,
    this.autofocus = false,
    this.decoration,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
    this.inputFormatters,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: TextField(
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        controller: _controller,
        inputFormatters: widget.inputFormatters,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        textInputAction: widget.textInputAction,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        decoration:
            (widget.decoration ??
                InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  suffixIcon:
                      _controller.text.isNotEmpty
                          ? IconButton(
                            icon: Icon(CupertinoIcons.xmark_circle),
                            onPressed: () {
                              _controller.clear();
                              setState(() {});
                              widget.onChanged?.call('');
                            },
                          )
                          : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11.5,
                  ),
                )),
        onChanged: (value) {
          setState(() {});
          widget.onChanged?.call(value);
        },
      ),
    );
  }
}

class _DDMSSelectableList extends StatelessWidget {
  final List<String> options;
  final List<String> selectedItems;
  final ValueChanged<List<String>> onSelectionChanged;
  final bool showCheckboxes; // New property to control display mode

  const _DDMSSelectableList({
    required this.options,
    required this.selectedItems,
    required this.onSelectionChanged,
    this.showCheckboxes =
        true, // Default to checkbox mode for backward compatibility
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectedItems.isNotEmpty && showCheckboxes)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    selectedItems.map((item) {
                      return Container(
                        margin: const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Color.fromRGBO(0, 0, 0, 0.12),
                          ),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Text(
                                item,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            Positioned(
                              top: -6,
                              right: -6,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () {
                                  final newSel = List<String>.from(
                                    selectedItems,
                                  )..remove(item);
                                  onSelectionChanged(newSel);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      width: 1,
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.separated(
                separatorBuilder:
                    (_, __) => const Divider(
                      height: 0.5,
                      color: Color.fromRGBO(0, 0, 0, 0.12),
                    ),
                itemCount: options.length,
                padding: EdgeInsets.zero,
                itemBuilder: (ctx, i) {
                  final opt = options[i];
                  final isSel = selectedItems.contains(opt);

                  // Different item rendering based on showCheckboxes flag
                  // For the checkbox version
                  if (showCheckboxes) {
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          final newSel = List<String>.from(selectedItems);
                          if (isSel) {
                            newSel.remove(opt);
                          } else {
                            newSel.add(opt);
                          }
                          onSelectionChanged(newSel);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: [
                              // Checkbox
                              Theme(
                                data: Theme.of(context).copyWith(
                                  checkboxTheme: CheckboxThemeData(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    side: const BorderSide(
                                      color: Color.fromRGBO(39, 39, 39, 1),
                                      width: 1,
                                    ),
                                    fillColor: WidgetStateProperty.resolveWith<
                                      Color
                                    >((states) {
                                      if (states.contains(
                                        WidgetState.selected,
                                      )) {
                                        return Color.fromRGBO(
                                          28,
                                          121,
                                          212,
                                          1,
                                        ); // Customize your fill color when selected
                                      }
                                      return Colors
                                          .white; // Fill color when not selected
                                    }),
                                    checkColor: WidgetStateProperty.all<Color>(
                                      Colors.white,
                                    ),
                                    // Check mark color
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ),
                                child: SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: Checkbox(
                                    value: isSel,
                                    onChanged: (b) {
                                      final newSel = List<String>.from(
                                        selectedItems,
                                      );
                                      if (b == true) {
                                        newSel.add(opt);
                                      } else {
                                        newSel.remove(opt);
                                      }
                                      onSelectionChanged(newSel);
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Text
                              Expanded(
                                child: Text(
                                  opt,
                                  style: const TextStyle(
                                    fontSize: 16,
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
                    // New non-checkbox multiple selection mode with check icons on right
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          final newSel = List<String>.from(selectedItems);
                          if (isSel) {
                            newSel.remove(opt);
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
                                  opt,
                                  style: const TextStyle(
                                    fontSize: 16,
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
