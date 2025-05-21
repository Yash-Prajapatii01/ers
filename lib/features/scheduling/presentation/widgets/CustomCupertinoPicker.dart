import 'package:flutter/cupertino.dart';

class CustomCupertinoPicker extends StatefulWidget {
  /// Options for the first column (can be any type)
  final List<dynamic>? firstColumnOptions;

  /// Options for the second column (strings)
  final List<String>? secondColumnOptions;

  /// Options for a single column (when using as standard picker)
  final List<dynamic>? singleColumnOptions;

  /// Callback for dual-column selection
  final void Function(dynamic day, String weekday)? onDualColumnSelected;

  /// Callback for single-column selection
  final void Function(dynamic value)? onSingleColumnSelected;

  const CustomCupertinoPicker({
    super.key,
    this.firstColumnOptions,
    this.secondColumnOptions,
    this.singleColumnOptions,
    this.onDualColumnSelected,
    this.onSingleColumnSelected,
  }) : assert(
  (firstColumnOptions != null && secondColumnOptions != null) ||
      singleColumnOptions != null,
  'Either provide both firstColumnOptions and secondColumnOptions for dual-column picker, '
      'or provide singleColumnOptions for a standard picker',
  );

  @override
  State<CustomCupertinoPicker> createState() => _CustomCupertinoPickerState();
}

class _CustomCupertinoPickerState extends State<CustomCupertinoPicker> {
  // Controllers for dual-column mode
  final FixedExtentScrollController _dayController = FixedExtentScrollController();
  final FixedExtentScrollController _weekdayController = FixedExtentScrollController();

  // Controller for single-column mode
  final FixedExtentScrollController _singleController = FixedExtentScrollController();

  // Selection indices
  int _selectedDayIndex = 0;
  int _selectedWeekdayIndex = 0;
  int _selectedSingleIndex = 0;

  // Constants
  static const double _itemExtent = 32.0;
  static const double _pickerHeight = 150.0;

  // Determine if we're in dual-column mode
  bool get _isDualColumnMode =>
      widget.firstColumnOptions != null && widget.secondColumnOptions != null;

  @override
  void dispose() {
    _dayController.dispose();
    _weekdayController.dispose();
    _singleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _isDualColumnMode ? _buildDualColumnPicker() : _buildSingleColumnPicker(),
        IgnorePointer(
          child: Container(
            width: 320,
            height: _pickerHeight,
            alignment: Alignment.center,
            child: Container(
              height: _itemExtent,
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey.withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDualColumnPicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCompactPicker(
          items: widget.firstColumnOptions!.map((e) => e.toString()).toList(),
          controller: _dayController,
          onSelectedItemChanged: (index) {
            setState(() => _selectedDayIndex = index);
            _emitDualSelection();
          },
          width: 50,
        ),
        _buildCompactPicker(
          items: widget.secondColumnOptions!,
          controller: _weekdayController,
          onSelectedItemChanged: (index) {
            setState(() => _selectedWeekdayIndex = index);
            _emitDualSelection();
          },
          width: 110,
        ),
      ],
    );
  }

  Widget _buildSingleColumnPicker() {
    return SizedBox(
      width: 200,
      height: _pickerHeight,
      child: _buildCompactPicker(
        items: widget.singleColumnOptions!.map((e) => e.toString()).toList(),
        controller: _singleController,
        onSelectedItemChanged: (index) {
          setState(() => _selectedSingleIndex = index);
          _emitSingleSelection();
        },
        width: 200,
      ),
    );
  }

  Widget _buildCompactPicker({
    required List<String> items,
    required FixedExtentScrollController controller,
    required ValueChanged<int> onSelectedItemChanged,
    required double width,
  }) {
    return SizedBox(
      width: width,
      height: _pickerHeight,
      child: CupertinoPicker.builder(
        scrollController: controller,
        itemExtent: _itemExtent,
        useMagnifier: true,
        magnification: 1.1,
        squeeze: 1.00,
        selectionOverlay: Container(),
        onSelectedItemChanged: onSelectedItemChanged,
        childCount: items.length,
        itemBuilder: (context, index) {
          return Center(
            child: Text(
              items[index],
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Inter',
                color: CupertinoColors.label,
              ),
            ),
          );
        },
      ),
    );
  }

  void _emitDualSelection() {
    final dynamic selectedDay = widget.firstColumnOptions![_selectedDayIndex];
    final String selectedWeekday = widget.secondColumnOptions![_selectedWeekdayIndex];
    widget.onDualColumnSelected?.call(selectedDay, selectedWeekday);
  }

  void _emitSingleSelection() {
    final dynamic selectedValue = widget.singleColumnOptions![_selectedSingleIndex];
    widget.onSingleColumnSelected?.call(selectedValue);
  }
}