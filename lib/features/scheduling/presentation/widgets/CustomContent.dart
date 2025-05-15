import 'package:ers_linux/features/scheduling/presentation/widgets/unifiedCalender.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class FrequencyUnitSelector extends StatefulWidget {
  @override
  _FrequencyUnitSelectorState createState() => _FrequencyUnitSelectorState();
}

class _FrequencyUnitSelectorState extends State<FrequencyUnitSelector> {
  final List<String> _frequencies = ['Daily', 'Weekly', 'Monthly', 'Yearly'];
  String _selectedFrequency = 'Daily';
  bool _showUnitOptions = false;
  dynamic _selectedUnitValue;
  String _selectedUnitType = '';
  Set<String> _selectedDays = {};
  bool initialValue = false;
  late ValueChanged<bool> onChanged = (_) {};
  late bool isChecked = false;
  bool showCalender = true;
  bool showDialer = false;
  bool toggleSwitch = false;

  final Map<String, String> _unitMap = {
    'Daily': 'Day',
    'Weekly': 'Week',
    'Monthly': 'Month',
    'Yearly': 'Year',
  };
  final GlobalKey _frequencyKey = GlobalKey();

  Future<void> _showFrequencyMenu() async {
    final RenderBox box =
    _frequencyKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = box.localToGlobal(Offset.zero);
    final Size size = box.size;

    final RenderBox overlay =
    Overlay
        .of(context)
        .context
        .findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromLTRB(
      offset.dx,
      offset.dy + size.height + 7,
      overlay.size.width - offset.dx - size.width - 10,
      offset.dy,
    );

    final items = <PopupMenuEntry<String>>[];

    for (var i = 0; i < _frequencies.length; i++) {
      final frequency = _frequencies[i];

      items.add(
        PopupMenuItem<String>(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          height: 48,
          value: frequency,
          child: SizedBox(
            width: 170,
            child: Row(
              children: [
                if (frequency == _selectedFrequency)
                  const Icon(Icons.check, size: 16, color: Colors.black)
                else
                  const SizedBox(width: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    frequency,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                      frequency == _selectedFrequency
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

      if (i < _frequencies.length - 1) {
        items.add(
          PopupMenuItem<String>(
            enabled: false,
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
      position: position,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      items: items,
    );

    if (choice != null && choice != _selectedFrequency) {
      setState(() {
        _selectedFrequency = choice;
        _showUnitOptions = false;
        _selectedUnitValue = null;
        _selectedUnitType = '';
      });
    }
  }

  void _toggleCheckbox() {
    setState(() => isChecked = !isChecked);
    onChanged(isChecked);
  }

  Widget _buildUnitOptions(String frequency) {
    switch (frequency) {
      case 'Daily':
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color.fromRGBO(102, 112, 133, 0.2),
              width: 0.7,
            ),
          ),
          child: CustomCupertinoPicker(
            firstColumnOptions: List.generate(31, (i) => i + 1),
            secondColumnOptions: ['Day/s', 'Working day'],
            onDualColumnSelected: (first, second) {
              setState(() {
                _selectedUnitValue = first;
                _selectedUnitType = second;
              });
              print("$first $second");
            },
          ),
        );
      case 'Weekly':
        const days = [
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
          'Sunday',
        ];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(days.length, (index) {
              final day = days[index];
              final bool isSelected = _selectedDays.contains(day); // <- Changed here

              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedDays.remove(day);
                        } else {
                          _selectedDays.add(day);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      width: double.infinity,
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          Text(
                            day,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF272727),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (isSelected) ...[
                            Spacer(),
                            const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.black,
                            )
                          ]
                        ],
                      ),
                    ),
                  ),
                  if (index < days.length - 1)
                    const Divider(
                      height: 0.5,
                      thickness: 0.5,
                      color: Color.fromRGBO(102, 112, 133, 0.2),
                    ),
                ],
              );
            }),
          ),
        );
    // case 'Weekly':
      //   const days = [
      //     'Monday',
      //     'Tuesday',
      //     'Wednesday',
      //     'Thursday',
      //     'Friday',
      //     'Saturday',
      //     'Sunday',
      //   ];
      //   return Container(
      //     decoration: BoxDecoration(
      //       color: Colors.white,
      //       borderRadius: BorderRadius.circular(12),
      //       border: Border.all(color: const Color(0xFFE0E0E0)),
      //       boxShadow: [
      //         BoxShadow(
      //           color: Colors.black.withOpacity(0.05),
      //           blurRadius: 8,
      //           offset: const Offset(0, 4),
      //         ),
      //       ],
      //     ),
      //     padding: const EdgeInsets.symmetric(vertical: 8),
      //     child: Column(
      //       mainAxisSize: MainAxisSize.min,
      //       children: List.generate(days.length, (index) {
      //         final day = days[index];
      //         final bool isSelected = _selectedUnitValue == day;
      //
      //         return Column(
      //           children: [
      //             GestureDetector(
      //               onTap: () {
      //                 setState(() {
      //                   _selectedUnitValue = day;
      //                   _selectedUnitType = '';
      //                   _showUnitOptions = false;
      //                 });
      //               },
      //               child: Container(
      //                 padding: const EdgeInsets.symmetric(
      //                   horizontal: 16,
      //                   vertical: 12,
      //                 ),
      //                 width: double.infinity,
      //                 color: Colors.transparent,
      //                 child: Row(
      //                   children: [
      //                     Text(
      //                       day,
      //                       style: TextStyle(
      //                         fontSize: 16,
      //                         fontWeight:
      //                         isSelected
      //                             ? FontWeight.w500
      //                             : FontWeight.normal,
      //                         color: const Color(0xFF272727),
      //                       ),
      //                     ),
      //                     const SizedBox(width: 8),
      //                     if (isSelected) ...[
      //                       Spacer(),
      //                       const Icon(
      //                         Icons.check,
      //                         size: 16,
      //                         color: Colors.black,
      //                       )
      //                     ]
      //                   ],
      //                 ),
      //               ),
      //             ),
      //             if (index < days.length - 1)
      //               const Divider(
      //                 height: 0.5,
      //                 thickness: 0.5,
      //                 color: Color.fromRGBO(102, 112, 133, 0.2),
      //               ),
      //           ],
      //         );
      //       }),
      //     ),
      //   );
      case 'Monthly':
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color.fromRGBO(102, 112, 133, 0.2),
              width: 0.7,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap:
                            () =>
                            setState(() {
                              showCalender = true;
                              showDialer = false;
                            }),
                        child: Text(
                          'Each',
                          style: TextStyle(
                            color: Color.fromRGBO(102, 112, 133, 1),
                          ),
                        ),
                      ),
                      Spacer(),
                      if (showCalender)
                        const Icon(
                          Icons.check,
                          size: 16,
                          color: Color.fromRGBO(28, 121, 212, 1),
                        )
                    ],
                  ),
                ),
                Divider(height: 1, color: Color.fromRGBO(102, 112, 131, 0.2)),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            setState(() {
                              showCalender = false;
                              showDialer = true;
                            }),
                        child: Text(
                          'On the',
                          style: TextStyle(
                            color: Color.fromRGBO(102, 112, 133, 1),
                          ),
                        ),
                      ),
                      Spacer(),
                      if (showDialer)
                        const Icon(
                          Icons.check,
                          size: 16,
                          color: Color.fromRGBO(28, 121, 212, 1),
                        )
                    ],
                  ),
                ),
                if (showCalender)
                  UnifiedCalendar(
                    showWeekdayLabels: false,
                    remmoveInternalPadding: true,
                    topheader: false,
                    initialDate: DateTime.now(),
                    initialFromTime: TimeOfDay.now(),
                    showTime: false,
                    onDateSelected: (combined) {
                      setState(() {
                        _selectedUnitType = DateFormat(
                          'd MMMM y',
                        ).format(combined);
                        print(_selectedUnitType);
                        _selectedUnitValue = '';
                      });
                    },
                  ),
                if (showDialer)
                  CustomCupertinoPicker(
                    firstColumnOptions: ['1st', '2nd', '3rd', '4th', 'last'],
                    secondColumnOptions: [
                      'Day',
                      'Working Day',
                      'Sunday',
                      'Monday',
                      'Tuesday',
                      'Wednesday',
                      'Thursday',
                      'Friday',
                      'Saturday',
                    ],
                    onDualColumnSelected: (first, second) {
                      setState(() {
                        _selectedUnitValue = first;
                        _selectedUnitType = second;
                      });
                    },
                  ),
              ],
            ),
          ),
        );
      case 'Yearly':
        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 4),
          padding: EdgeInsets.all(14),
          // alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color.fromRGBO(102, 112, 133, 0.2),
              width: 0.7,
            ),
          ),
          child: MonthSelector(
            selectedMonth: _selectedUnitValue,
            onChanged: (month){
              setState(() {
                _selectedUnitValue = month;
                _selectedUnitType = '';
              });
            },
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final unitLabel = _unitMap[_selectedFrequency]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Frequency', style: TextStyle(fontSize: 16)),
              GestureDetector(
                key: _frequencyKey,
                onTap: _showFrequencyMenu,
                child: Row(
                  children: [
                    Text(_selectedFrequency),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/scheduling/booking/updownarrow.svg',
                        height: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Every', style: TextStyle(fontSize: 16)),
              GestureDetector(
                onTap: () => setState(() => _showUnitOptions = !_showUnitOptions),
                child: Text(
                  (_selectedUnitType.isNotEmpty || _selectedUnitValue != null)
                      ? ('$_selectedUnitValue $_selectedUnitType')
                      : unitLabel,
                  // _selectedFrequency == 'Weekly' && _selectedDays.isNotEmpty
                  //     ? (_selectedDays.length == 1
                  //     ? _selectedDays.first
                  //     : '${_selectedDays.first} + ${_selectedDays.length - 1}')
                  //     : (_selectedUnitType.isNotEmpty || _selectedUnitValue != null
                  //     ? '$_selectedUnitValue $_selectedUnitType'
                  //     : unitLabel),
                  // style: (_selectedUnitType.isNotEmpty || _selectedUnitValue != null && _selectedDays.isNotEmpty) ? TextStyle(color: Colors.blue) : TextStyle(color: Color.fromRGBO(102, 112, 133, 0.5)),
                  style: (
                      (_selectedFrequency == 'Weekly' && _selectedDays.isNotEmpty) ||
                          (_selectedUnitType.isNotEmpty || _selectedUnitValue != null)
                  )
                      ? const TextStyle(color: Colors.blue)
                      : const TextStyle(color: Color.fromRGBO(102, 112, 133, 0.5)),

                ),
              ),
              // GestureDetector(
              //   onTap:
              //       () => setState(() => _showUnitOptions = !_showUnitOptions),
              //   child: Text(
              //     (_selectedUnitType.isNotEmpty || _selectedUnitValue != null)
              //         ? ('$_selectedUnitValue $_selectedUnitType')
              //         : unitLabel,
              //     style: const TextStyle(color: Colors.blue),
              //   ),
              // ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            InkWell(
              onTap: _toggleCheckbox,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: isChecked ? Color.fromRGBO(28, 121, 212, 1) : null,
                  border: Border.all(
                    // color: Color.fromRGBO(39, 39, 39, 1),
                    color:
                    isChecked
                        ? Color.fromRGBO(28, 121, 212, 1)
                        : Color.fromRGBO(39, 39, 39, 1),
                    width: 0.7,
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
                child:
                isChecked
                    ? Center(
                  child: Icon(
                    Icons.check,
                    size: 10,
                    color: Colors.white,
                  ),
                )
                    : null,
              ),
            ),
            SizedBox(width: 8),
            const Text('Skip Non-Working Day', style: TextStyle(fontSize: 14)),
          ],
        ),
        if(_selectedFrequency == 'Yearly') ...[
          SizedBox(height: 30,),
          Container(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Days of Week'),
                    Spacer(),
                    CustomSwitch(
                      value: toggleSwitch,
                      onChanged: (newValue) {
                        setState(() {
                          toggleSwitch = newValue;
                        });
                      },
                    ),
                    // SizedBox(width: 10,)
                  ],
                ),
                if (toggleSwitch) ...[
                  const SizedBox(height: 10),
                  const Divider(height: 1 , color: Color.fromRGBO(208, 213, 221, 1)),
                  CustomCupertinoPicker(
                    firstColumnOptions: ['1st', '2nd', '3rd', '4th', 'last'],
                    secondColumnOptions: [
                      'Day',
                      'Working Day',
                      'Sunday',
                      'Monday',
                      'Tuesday',
                      'Wednesday',
                      'Thursday',
                      'Friday',
                      'Saturday',
                    ],
                    onDualColumnSelected: (first, second) {
                      setState(() {
                        _selectedUnitValue = first;
                        _selectedUnitType = second;
                      });
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
        if (_showUnitOptions) ...[
          SizedBox(height: 16,),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildUnitOptions(_selectedFrequency),
          ),
        ]
      ],
    );
  }
}
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
          width: 108,
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
// class CustomCupertinoPicker extends StatefulWidget {
//   /// Options for the first column (can be any type)
//   final List<dynamic>? firstColumnOptions;
//
//   /// Options for the second column (strings)
//   final List<String>? secondColumnOptions;
//
//   /// Options for a single column (when using as standard picker)
//   final List<dynamic>? singleColumnOptions;
//
//   /// Callback for dual-column selection
//   final void Function(dynamic day, String weekday)? onDualColumnSelected;
//
//   /// Callback for single-column selection
//   final void Function(String value)? onSingleColumnSelected;
//
//   const CustomCupertinoPicker({
//     super.key,
//     this.firstColumnOptions,
//     this.secondColumnOptions,
//     this.singleColumnOptions,
//     this.onDualColumnSelected,
//     this.onSingleColumnSelected,
//   }) : assert(
//   (firstColumnOptions != null && secondColumnOptions != null) ||
//       singleColumnOptions != null,
//   'Either provide both firstColumnOptions and secondColumnOptions for dual-column picker, '
//       'or provide singleColumnOptions for a standard picker',
//   );
//
//   @override
//   State<CustomCupertinoPicker> createState() => _CustomCupertinoPickerState();
// }
//
// class _CustomCupertinoPickerState extends State<CustomCupertinoPicker> {
//   // Controllers for dual-column mode
//   final FixedExtentScrollController _dayController = FixedExtentScrollController();
//   final FixedExtentScrollController _weekdayController = FixedExtentScrollController();
//
//   // Controller for single-column mode
//   final FixedExtentScrollController _singleController = FixedExtentScrollController();
//
//   // Selection indices
//   int _selectedDayIndex = 0;
//   int _selectedWeekdayIndex = 0;
//   int _selectedSingleIndex = 0;
//
//   // Constants
//   static const double _itemExtent = 32.0;
//   static const double _pickerHeight = 150.0;
//
//   // Determine if we're in dual-column mode
//   bool get _isDualColumnMode =>
//       widget.firstColumnOptions != null && widget.secondColumnOptions != null;
//
//   @override
//   void dispose() {
//     _dayController.dispose();
//     _weekdayController.dispose();
//     _singleController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         _isDualColumnMode ? _buildDualColumnPicker() : _buildSingleColumnPicker(),
//         IgnorePointer(
//           child: Container(
//             width: 320,
//             height: _pickerHeight,
//             alignment: Alignment.center,
//             child: Container(
//               height: _itemExtent,
//               decoration: BoxDecoration(
//                 color: CupertinoColors.systemGrey.withOpacity(0.12),
//                 borderRadius: BorderRadius.circular(6),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDualColumnPicker() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         _buildCompactPicker(
//           items: widget.firstColumnOptions!.map((e) => e.toString()).toList(),
//           controller: _dayController,
//           onSelectedItemChanged: (index) {
//             setState(() => _selectedDayIndex = index);
//             _emitDualSelection();
//           },
//           width: 50,
//         ),
//         _buildCompactPicker(
//           items: widget.secondColumnOptions!,
//           controller: _weekdayController,
//           onSelectedItemChanged: (index) {
//             setState(() => _selectedWeekdayIndex = index);
//             _emitDualSelection();
//           },
//           width: 108,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSingleColumnPicker() {
//     return SizedBox(
//       width: 200,
//       height: _pickerHeight,
//       child: _buildCompactPicker(
//         items: widget.singleColumnOptions!.length,
//         controller: _singleController,
//         onSelectedItemChanged: (index) {
//           setState(() => _selectedSingleIndex = index);
//           _emitSingleSelection();
//         },
//         width: 200,
//       ),
//     );
//   }
//
//   Widget _buildCompactPicker({
//     required List<String> items,
//     required FixedExtentScrollController controller,
//     required ValueChanged<int> onSelectedItemChanged,
//     required double width,
//   }) {
//     return SizedBox(
//       width: width,
//       height: _pickerHeight,
//       child: CupertinoPicker.builder(
//         scrollController: controller,
//         itemExtent: _itemExtent,
//         useMagnifier: true,
//         magnification: 1.1,
//         squeeze: 1.00,
//         selectionOverlay: Container(),
//         onSelectedItemChanged: onSelectedItemChanged,
//         childCount: items.length,
//         itemBuilder: (context, index) {
//           return Center(
//             child: Text(
//               items[index],
//               style: const TextStyle(
//                 fontSize: 18,
//                 color: CupertinoColors.label,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   void _emitDualSelection() {
//     final dynamic selectedDay = widget.firstColumnOptions![_selectedDayIndex];
//     final String selectedWeekday = widget.secondColumnOptions![_selectedWeekdayIndex];
//     widget.onDualColumnSelected?.call(selectedDay, selectedWeekday);
//   }
//
//   void _emitSingleSelection() {
//     final String selectedValue = widget.singleColumnOptions![_selectedSingleIndex];
//     widget.onSingleColumnSelected?.call(selectedValue);
//   }
// }
//todo:
// class CustomCupertinoPicker extends StatefulWidget {
//   final List<dynamic> firstColumnOptions;
//   final List<String> secondColumnOptions;
//   final void Function(dynamic day, String weekday)? onSelected;
//
//   const CustomCupertinoPicker({
//     super.key,
//     required this.firstColumnOptions,
//     required this.secondColumnOptions,
//     this.onSelected,
//   });
//
//   @override
//   State<CustomCupertinoPicker> createState() => _CustomCupertinoPickerState();
// }
//
// class _CustomCupertinoPickerState extends State<CustomCupertinoPicker> {
//   final FixedExtentScrollController _dayController =
//   FixedExtentScrollController();
//   final FixedExtentScrollController _weekdayController =
//   FixedExtentScrollController();
//
//   int _selectedDayIndex = 0;
//   int _selectedWeekdayIndex = 0;
//
//   static const double _itemExtent = 32.0;
//   static const double _pickerHeight = 150.0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildCompactPicker(
//               items:
//               widget.firstColumnOptions.map((e) => e.toString()).toList(),
//               controller: _dayController,
//               onSelectedItemChanged: (index) {
//                 setState(() => _selectedDayIndex = index);
//                 _emitSelection();
//               },
//               width: 50,
//             ),
//             _buildCompactPicker(
//               items: widget.secondColumnOptions,
//               controller: _weekdayController,
//               onSelectedItemChanged: (index) {
//                 setState(() => _selectedWeekdayIndex = index);
//                 _emitSelection();
//               },
//               width: 108,
//             ),
//           ],
//         ),
//         IgnorePointer(
//           child: Container(
//             width: 320,
//             height: _pickerHeight,
//             alignment: Alignment.center,
//             child: Container(
//               height: _itemExtent,
//               decoration: BoxDecoration(
//                 color: CupertinoColors.systemGrey.withOpacity(0.12),
//                 borderRadius: BorderRadius.circular(6),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildCompactPicker({
//     required List<String> items,
//     required FixedExtentScrollController controller,
//     required ValueChanged<int> onSelectedItemChanged,
//     required double width,
//   }) {
//     return SizedBox(
//       width: width,
//       height: _pickerHeight,
//       child: CupertinoPicker.builder(
//         scrollController: controller,
//         itemExtent: _itemExtent,
//         useMagnifier: true,
//         magnification: 1.1,
//         squeeze: 1.00,
//         selectionOverlay: Container(),
//         onSelectedItemChanged: onSelectedItemChanged,
//         childCount: items.length,
//         itemBuilder: (context, index) {
//           return Center(
//             child: Text(
//               items[index],
//               style: const TextStyle(
//                 fontSize: 18,
//                 color: CupertinoColors.label,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   void _emitSelection() {
//     final dynamic selectedDay = widget.firstColumnOptions[_selectedDayIndex];
//     final String selectedWeekday =
//     widget.secondColumnOptions[_selectedWeekdayIndex];
//     widget.onSelected?.call(selectedDay, selectedWeekday);
//   }
// }

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;

   CustomSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    this.activeColor = const Color.fromRGBO(53, 199, 90, 1),
    this.inactiveColor = const Color.fromRGBO(233, 233, 235, 1),
    this.thumbColor = Colors.white,
  }) : super(key: key);

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onChanged(!widget.value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 53,
        height: 24,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: widget.value ? widget.activeColor : widget.inactiveColor,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment:
          widget.value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: widget.thumbColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 3),
                  blurRadius: 1,
                  spreadRadius: 0,
                  color: const Color.fromRGBO(0, 0, 0, 0.06),
                ),
                BoxShadow(
                  offset: Offset(0, 3),
                  blurRadius: 8,
                  spreadRadius: 0,
                  color: const Color.fromRGBO(0, 0, 0, 0.15),
                ),
                BoxShadow(
                  offset: Offset(0, 0),
                  blurRadius: 0,
                  spreadRadius: 1,
                  color: const Color.fromRGBO(0, 0, 0, 0.04),
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}

class MonthSelector extends StatelessWidget {
  final String? selectedMonth;
  final ValueChanged<String> onChanged;

  const MonthSelector({
    Key? key,
     this.selectedMonth,
    required this.onChanged,
  }) : super(key: key);

  final List<String> months = const [
    'Jan', 'Feb', 'March', 'Apr',
    'May', 'Jun', 'Jul', 'Aug',
    'Sep', 'Oct', 'Nov', 'Dec'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (rowIndex) {
        int start = rowIndex * 4;
        int end = start + 4;
        List<String> rowItems = months.sublist(start, end);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(4, (colIndex) {
            String month = rowItems[colIndex];
            bool isSelected = selectedMonth == month;

            EdgeInsets margin = EdgeInsets.only(
              left: colIndex == 0 ? 0 : 11.5,
              right: colIndex == 3 ? 0 : 11.5,
            );
            return GestureDetector(
              onTap: () {
                onChanged(month);
              },
              child: Container(
                width: 77,
                height: isSelected ? 36 : 44,
                margin: margin,
                decoration: BoxDecoration(
                  color: isSelected ? Color.fromRGBO(28, 121, 212, 1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    month,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}


