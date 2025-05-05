import 'package:ers_linux/features/scheduling/presentation/widgets/unifiedCalenderTemp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'ColorPicker.dart';


/// A unified container tile that can support multiple interaction modes:
/// - Simple navigation tile (with nextPage)
/// - Bottom sheet display (with custom content)
/// - Popup menu selection (dropdown style)
/// - Expandable content (collapsible sections)
/// - DDMS (Dynamic Data Multiple Selection)
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
  });

  @override
  State<UnifiedContainerTile> createState() => _UnifiedContainerTileState();
}

/// Defines the type of interaction for the container tile
enum TileInteractionType {
  simple,       // Basic tile with no special interaction
  navigation,   // Navigates to a new page
  bottomSheet,  // Opens a bottom sheet
  popupMenu,    // Shows a popup menu
  expandable,   // Expands to show more content
  ddms,         // Dynamic Data Multiple Selection
}

class _UnifiedContainerTileState extends State<UnifiedContainerTile> {
  // State variables
  late String _itemText;
  String _selectedOption = '';
  List<String> _selectedOptions = [];
  bool _isExpanded = false;
  double _sliderValue = 0.0;
  final TextEditingController _effortController = TextEditingController();

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

  // Handle tap on the tile
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
          _showCustomBottomSheet(context, widget.bottomSheetContent!);
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

  // Show custom bottom sheet
  void _showCustomBottomSheet(BuildContext context, Widget child) {
    showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.95,
        minChildSize: 0.3,
        maxChildSize: 0.98,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(12),
            ),
          ),
          child: child,
        ),
      ),
    ).then((selected) {
      if (selected != null && selected.isNotEmpty) {
        setState(() => _itemText = selected);
        if (widget.onTextChanged != null) {
          widget.onTextChanged!(selected);
        }
      }
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
      offset.dy - (65.0 * (widget.options?.length ?? 0)) - 5.0,
      overlay.size.width - offset.dx - size.width,
      offset.dy,
    );

    final items = <PopupMenuEntry<String>>[];
    for (var i = 0; i < (widget.options?.length ?? 0); i++) {
      if (i > 0) items.add(const PopupMenuDivider());
      items.add(
        PopupMenuItem<String>(
          value: widget.options![i],
          child: Text(
            widget.options![i],
            style: TextStyle(
              fontSize: 14,
              fontWeight: widget.options![i] == _selectedOption
                  ? FontWeight.w400
                  : FontWeight.normal,
            ),
          ),
        ),
      );
    }

    final choice = await showMenu<String>(
      context: context,
      position: pos,
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

  // Show effort input bottom sheet
  void _showEffortInputSheet() {
    _showCustomBottomSheet(
      context,
      BottomSheetOptions(
        isDonethere: true,
        isTextFieldNeeded: true,
        customTextField: CustomTextField(
          controller: _effortController,
          hintText: 'Effort',
          keyboardType: TextInputType.number,
        ),
        onDone: () {
          setState(() {});
          if (widget.onTextChanged != null) {
            widget.onTextChanged!(_effortController.text);
          }
        },
      ),
    );
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

                // Different trailing widgets based on interaction type
                _buildTrailingWidget(),
              ],
            ),

            // Expandable content if applicable
            if (_isExpanded && widget.interactionType == TileInteractionType.expandable)
              _buildExpandableContent(),
          ],
        ),
      ),
    );
  }

  // Build trailing widget based on interaction type
  Widget _buildTrailingWidget() {
    switch (widget.interactionType) {
      case TileInteractionType.navigation:
        return Row(
          children: [
            Text(
              _itemText,
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromRGBO(102, 112, 133, 0.5),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        );

      case TileInteractionType.bottomSheet:
        return Row(
          children: [
            Text(
              _itemText,
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromRGBO(102, 112, 133, 0.5),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        );

      case TileInteractionType.popupMenu:
        if (widget.isPinTextNeeded == true) {
          return Row(
            children: [
              GestureDetector(
                onTap: _showEffortInputSheet,
                child: PillText(
                  _effortController.text.isNotEmpty ? _effortController.text.trim() : "Add",
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
                            ? (widget.options?.isNotEmpty == true ? widget.options!.first : "Select")
                            : _selectedOption,
                        Colors.black
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
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
                  _selectedOption.isEmpty ? "" : _selectedOption, // can add 'Select for better UX'
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
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
      default:
        return const SizedBox();
    }
  }

  // Build expandable content
  Widget _buildExpandableContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
        const SizedBox(height: 12),

        // Show either custom expandable content or the default slider
        widget.expandedContent ?? _buildDefaultExpandableContent(),
      ],
    );
  }

  // Default expandable content with slider
  Widget _buildDefaultExpandableContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Your progress',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const Spacer(),
            Text(
              '${_sliderValue.toInt()}%',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xff0072C3),
              ),
            ),
          ],
        ),
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
    this.inputFormatters
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
      padding:  EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: TextField(
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400
        ),
        controller: _controller,
        inputFormatters: widget.inputFormatters,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        textInputAction: widget.textInputAction,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        decoration: (widget.decoration ?? InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
            icon:  Icon(CupertinoIcons.xmark_circle),
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11.5),
        )),
        onChanged: (value) {
          setState(() {});
          widget.onChanged?.call(value);
        },
      ),
    );
  }
}
class PillText extends StatelessWidget {
  final String text;
  final Color color;

  const PillText(this.text, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Color.fromRGBO(102, 112, 133, 0.5),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

// BottomSheetOptions component (simplified version)
class BottomSheetOptions extends StatefulWidget {
  final String title;
  final List<String>? options;
  final VoidCallback? onDone;
  final bool? isSearchEnabled;
  final bool? isTextFieldNeeded;
  final CustomTextField? customTextField;
  final bool? isDateWidget;
  final bool? isTimeWidget;
  // final bool? isFTRCalender;
  final bool? isDonethere;
  final bool? DDMS;
  final bool? isColorPalleteNeeded;
  final List<String>? initialSelectedOptions;
  final List<TextInputFormatter>? inputFormatters;

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
    this.isColorPalleteNeeded = false,
    this.initialSelectedOptions,
    this.inputFormatters,
    // this.isFTRCalender,
  });

  @override
  State<BottomSheetOptions> createState() => _BottomSheetOptionsState();
}

class _BottomSheetOptionsState extends State<BottomSheetOptions> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedOption;
  String _textValue = '';
  List<String> _filteredOptions = [];
  List<String> _ddmsSelections = [];

  @override
  void initState() {
    super.initState();
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
      _filteredOptions = (widget.options ?? [])
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
    } else if (widget.isTextFieldNeeded == true) {
      result = _textValue;
    } else if (_selectedOption != null) {
      result = _selectedOption!;
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
          const Divider(height: 1),
          if (widget.isSearchEnabled == true) _buildSearchField(),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Color.fromRGBO(242, 48, 48, 1),
                fontSize: 16,
              ),
            ),
          ),
        ),
        Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Color.fromRGBO(51, 51, 51, 1),
          ),
        ),
        if (widget.isDonethere == true)
          GestureDetector(
            onTap: _handleDone,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Done',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ),
          )
        else
          const SizedBox(),
      ],
    ),
  );

  Widget _buildSearchField() => Padding(
    padding: const EdgeInsets.all(12),
    child: TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search',
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color.fromRGBO(102, 112, 133, 0.5),
        ),
        prefixIcon: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(color: Color(0xFFE0E0E0), width: 1),
            ),
          ),
          child: const Icon(CupertinoIcons.search, color: Colors.grey),
        ),
        filled: true,
        fillColor: const Color.fromRGBO(245, 246, 248, 1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );

  Widget _buildContent() {
    if (widget.isColorPalleteNeeded == true) {
      return Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ColorPickerGrid(onColorSelected: (c) => print(c)),
        ),
      );
    }
    if (widget.isDateWidget == true && widget.isTimeWidget == true) {
      // return StandaloneCalendar(isTimeShow: true);
      return UnifiedCalendar(
        initialDate: DateTime.now(),
        showTime: true,
      );
    }
    if (widget.isDateWidget == true) {
      // return StandaloneCalendar(isTimeShow: false);
      return UnifiedCalendar(
        initialDate: DateTime.now(),
        showTime: false,
      );
    }
    // In a real implementation, this would use the actual components
    if (widget.isTextFieldNeeded == true) {
      return Expanded(
        child: (widget.customTextField != null)
            ? widget.customTextField!
            : Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            onChanged: (v) => _textValue = v,
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

    // DDMS multi-selection
    if (widget.DDMS == true) {
      return _DDMSSelectableList(
        options: _filteredOptions,
        selectedItems: _ddmsSelections,
        onSelectionChanged: (newSel) => setState(() => _ddmsSelections = newSel),
      );
    }

    // Simple options list
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemCount: _filteredOptions.length,
        itemBuilder: (ctx, i) {
          final opt = _filteredOptions[i];
          final sel = opt == _selectedOption;
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            title: Text(
              opt,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            trailing: sel ? const Icon(Icons.check, color: Colors.black) : null,
            onTap: () {
              setState(() => _selectedOption = opt);
              if (widget.isDonethere == false) Navigator.pop(context, opt);
            },
          );
        },
      ),
    );
  }
}

/// Multiple selection list with chips
class _DDMSSelectableList extends StatelessWidget {
  final List<String> options;
  final List<String> selectedItems;
  final ValueChanged<List<String>> onSelectionChanged;

  const _DDMSSelectableList({
    required this.options,
    required this.selectedItems,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectedItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: selectedItems.map((item) {
                  return Container(
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
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
                              final newSel = List<String>.from(selectedItems)..remove(item);
                              onSelectionChanged(newSel);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey.shade100.withOpacity(0.5),
                                  width: 0.5,
                                ),
                                color: Colors.grey.shade200,
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
            child: ListView.separated(
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemCount: options.length,
              itemBuilder: (ctx, i) {
                final opt = options[i];
                final isSel = selectedItems.contains(opt);
                return CheckboxListTile(
                  title: Text(
                    opt,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  value: isSel,
                  onChanged: (b) {
                    final newSel = List<String>.from(selectedItems);
                    if (b == true)
                      newSel.add(opt);
                    else
                      newSel.remove(opt);
                    onSelectionChanged(newSel);
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}