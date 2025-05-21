import 'package:ers_linux/features/scheduling/presentation/widgets/UnifiedCalender/unifiedCalender.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../CustomCupertinoPicker.dart';
import '../CustomSwitch.dart';
import 'monthSelector.dart';

class CustomTab extends StatefulWidget {
  const CustomTab({super.key});

  @override
  _CustomTabState createState() => _CustomTabState();
}

class _CustomTabState extends State<CustomTab> {
  final List<String> _frequencies = ['Daily', 'Weekly', 'Monthly', 'Yearly'];
  String _selectedFrequency = 'Daily';
  bool _showUnitOptions = false;
  dynamic _selectedUnitValue;
  String _selectedUnitType = '';
  Set<String> _selectedDays = {};
  int?    _yearlyOrdinalCount;
  String? _yearlyOrdinalUnit;
  Set<String> _yearlySelectedMonths = {};

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
  static const days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
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
                      fontFamily: 'Inter',
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
              const Text('Frequency', style: TextStyle(fontSize: 16,fontFamily: 'Inter')),
              GestureDetector(
                key: _frequencyKey,
                onTap: _showFrequencyMenu,
                child: Row(
                  children: [
                    Text(_selectedFrequency,style: TextStyle(fontFamily: 'Inter'),),
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
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Every', style: TextStyle(fontSize: 16,fontFamily: 'Inter')),
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
                          ? const TextStyle(color: Colors.blue,fontFamily: 'Inter')
                          : const TextStyle(color: Color.fromRGBO(102, 112, 133, 0.5),fontFamily: 'Inter'),

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
              if(_selectedFrequency == 'Daily' && _showUnitOptions) ...[
                SizedBox(height: 10,),
                const Divider(
                  height: 1,
                  thickness: 0.7,
                  color: Color.fromRGBO(102, 112, 133, 0.2),
                ),
                SizedBox(height: 2,),
                CustomCupertinoPicker(
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
              ],
              if(_selectedFrequency == 'Weekly' && _showUnitOptions) ...[
                SizedBox(height: 10,),
                const Divider(
                  height: 1,
                  thickness: 0.7,
                  color: Color.fromRGBO(102, 112, 133, 0.2),
                ),
                SizedBox(height: 2,),
                CustomCupertinoPicker(
                  firstColumnOptions: List.generate(6, (i) => i + 1),
                  secondColumnOptions: ['Weeks'],
                  onDualColumnSelected: (first, second) {
                    setState(() {
                      _selectedUnitValue = first;
                      _selectedUnitType = second;
                    });
                    print("$first $second");
                  },
                ),
              ],
              if(_selectedFrequency == 'Monthly' && _showUnitOptions) ...[
                SizedBox(height: 10,),
                const Divider(
                  height: 1,
                  thickness: 0.7,
                  color: Color.fromRGBO(102, 112, 133, 0.2),
                ),
                SizedBox(height: 2,),
                CustomCupertinoPicker(
                  firstColumnOptions: List.generate(12, (i) => i + 1),
                  secondColumnOptions: ['Months'],
                  onDualColumnSelected: (first, second) {
                    setState(() {
                      _selectedUnitValue = first;
                      _selectedUnitType = second;
                    });
                    print("$first $second");
                  },
                ),
              ],
              if (_selectedFrequency == 'Yearly' && _showUnitOptions) ...[
                SizedBox(height: 10,),
                const Divider(
                  height: 1,
                  thickness: 0.7,
                  color: Color.fromRGBO(102, 112, 133, 0.2),
                ),
                CustomCupertinoPicker(
                  firstColumnOptions: List.generate(5, (i) => i+1),
                  secondColumnOptions: ['Years'],
                  onDualColumnSelected: (first, second) {
                    setState(() {
                      _yearlyOrdinalCount = first;
                      _yearlyOrdinalUnit  = second;
                    });
                  },
                ),
              ],

              // if(_selectedFrequency == 'Yearly' && _showUnitOptions) ...[
              //   SizedBox(height: 10,),
              //   const Divider(
              //     height: 1,
              //     thickness: 0.7,
              //     color: Color.fromRGBO(102, 112, 133, 0.2),
              //   ),
              //   SizedBox(height: 2,),
              //   CustomCupertinoPicker(
              //     firstColumnOptions: List.generate(12, (i) => i + 1),
              //     secondColumnOptions: ['Years'],
              //     onDualColumnSelected: (first, second) {
              //       setState(() {
              //         _yearlySelectedMonths = first;
              //         _selectedUnitType = second;
              //       });
              //       print("$first $second");
              //     },
              //   ),
              // ],
            ],
          ),
        ),
        if(_selectedFrequency == 'Weekly') ...[
          SizedBox(height: 24,),
          Container(
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
                                fontFamily: 'Inter',
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
          )
        ],
        if(_selectedFrequency == 'Monthly') ...[
          SizedBox(height: 24,),
          Container(
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
                              fontFamily: 'Inter'
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
                              fontFamily: 'Inter'
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
                          print('$_selectedUnitValue $_selectedUnitType');
                        });
                      },
                    ),
                ],
              ),
            ),
          )
        ],
        if(_selectedFrequency == 'Yearly') ...[
          SizedBox(height: 24,),
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
                    Text('Days of Week',style: TextStyle(fontFamily: 'Inter'),),
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
          SizedBox(height: 24,),
          Container(
            width: double.infinity,
            // margin: EdgeInsets.only(top: 4),
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
              selectedMonths: _yearlySelectedMonths,   // <-- the Set<String>
              onChanged: (newSet) => setState(() {
                _yearlySelectedMonths = newSet;
              }),
            ),
            // child: MonthSelector(
            //   selectedMonths: _selectedUnitValue,
            //   onChanged: (month){
            //     setState(() {
            //       _selectedUnitValue = month;
            //       _selectedUnitType = '';
            //     });
            //   },
            // ),
          ),
        ],
        SizedBox(height: 12,),
        Row(
          children: [
            InkWell(
              onTap: _selectedUnitType.contains('Working day') ? null : _toggleCheckbox,
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
             Text('Skip Non-Working Day', style: TextStyle(fontSize: 14,fontFamily: 'Inter',color: (_selectedUnitType.contains('Working day'))? Colors.grey : Colors.black),),
          ],
        ),

      ],
    );
  }
}