import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../data/models/resource_model.dart';
import '../widgets/ColorPicker/ColorPicker.dart';
import '../widgets/CustomTextField.dart';
import '../widgets/DDMS.dart';
import '../widgets/UnifiedCalender/unifiedCalender.dart';
import '../widgets/priorityWheel.dart';

typedef BottomSheetSelectionCallback = void Function(dynamic selected);

class BottomSheetService {
  static Future<void> showCustomBottomSheet({
    required BuildContext context,
    required Widget child,
    bool startFullSize = true,
    BottomSheetSelectionCallback? onSelected,
  }) async {
    final double initialSize = startFullSize ? 0.90 : 0.50;

    final selected = await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder:
          (_) => Container(
            height: MediaQuery.of(context).size.height * initialSize,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: child,
          ),
    );

    if (selected == null) return;

    // Handle different selection formats
    if (selected is Resource) {
      onSelected?.call({'resource': selected, 'type': 'resource'});
    }
    if (selected is Map<String, dynamic> &&
        selected['label'] is String &&
        selected['color'] is Color) {
      onSelected!({
        'label': selected['label'],
        'color': selected['color'],
        'type': 'label-color',
      });
    } else if (child is BottomSheetOptions &&
        child.isColorPalleteNeeded == true &&
        selected is String) {
      onSelected!({'color': selected, 'type': 'color'});
    } else if (selected is String) {
      onSelected!({'text': selected, 'type': 'text'});
    }
  }
}

class BottomSheetOptions extends StatefulWidget {
  final String title;
  final List<String>? options;
  final VoidCallback? onDone;
  final bool? isSearchEnabled;
  final bool? isTextFieldNeeded;
  final CustomTextField? customTextField;
  final Widget? unifiedcontainercontent;
  final bool? isDateWidget;
  final bool? isTimeWidget;
  final bool? isDragHandleNeeded;
  final bool? isPriority;

  // final bool? isFTRCalender;
  final bool? isDonethere;
  final bool? DDMS;
  final String? SearchHintText;
  final bool? showCheckboxes; // New property to control DDMS display mode
  final bool? isColorPalleteNeeded;
  final List<String>? initialSelectedOptions;
  final List<TextInputFormatter>? inputFormatters;
  final DateTime? initialDate;
  final TimeOfDay? initialFromTime;
  final List<Resource>? resourceOptions;

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
    this.showCheckboxes = true,
    this.isColorPalleteNeeded = false,
    this.initialSelectedOptions,
    this.inputFormatters,
    this.isDragHandleNeeded = true,
    this.initialDate,
    this.initialFromTime,
    this.isPriority,
    this.SearchHintText = 'Search',
    this.unifiedcontainercontent,
    this.resourceOptions,
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
  Color _pickedColor = Colors.transparent;
  List<Resource> _filteredResources = [];

  @override
  void initState() {
    super.initState();
    _localColor = Colors.transparent;
    _localDate = widget.initialDate ?? DateTime.now();
    _localTime = widget.initialFromTime ?? TimeOfDay.now();

    _filteredOptions = widget.options ?? [];
    _filteredResources = widget.resourceOptions ?? [];
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

      _filteredResources =
          (widget.resourceOptions ?? [])
              .where((r) => r.name.toLowerCase().contains(q))
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
    } else if (widget.isPriority == true) {
      Navigator.pop<Map<String, dynamic>>(context, {
        'label': _pickedLabel,
        'color': _pickedColor,
      });
      return;
    } else if (widget.isColorPalleteNeeded == true) {
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

  Widget _buildResourceOptionsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        itemCount: _filteredResources.length,
        separatorBuilder:
            (_, __) => const Divider(
              height: 0.5,
              thickness: 0.7,
              color: Color.fromRGBO(0, 0, 0, 0.12),
            ),
        itemBuilder: (ctx, i) {
          final resource = _filteredResources[i];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.pop(context, resource);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(resource.imageUrl),
                      radius: 25,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            resource.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            resource.designation,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color.fromRGBO(102, 112, 133, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
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
          hintText: widget.SearchHintText,
          hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(102, 112, 133, 0.5),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
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
          suffixIcon:
              _searchController.text.isNotEmpty
                  ? GestureDetector(
                    onTap:
                        () => setState(() {
                          _searchController.clear();
                        }),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        'assets/icons/scheduling/booking/close.svg',
                        width: 16,
                        height: 16,
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                  : null,
          filled: true,
          fillColor: const Color.fromRGBO(245, 246, 248, 1),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 9.5,
            horizontal: 9.5,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (_) => setState(() {}), // Triggers suffixIcon rebuild
      ),
    ),
  );

  // Widget _buildSearchField() => Padding(
  //   padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
  //   child: SizedBox(
  //     width: double.infinity,
  //     height: 40,
  //     child: TextField(
  //       controller: _searchController,
  //       style: const TextStyle(
  //         fontSize: 14,
  //         fontWeight: FontWeight.w400,
  //         color: Colors.black,
  //       ),
  //       decoration: InputDecoration(
  //         hintText: widget.SearchHintText,
  //         hintStyle: const TextStyle(
  //           fontSize: 14,
  //           fontWeight: FontWeight.w400,
  //           color: Color.fromRGBO(102, 112, 133, 0.5),
  //         ),
  //         prefixIcon: Padding(
  //           padding: const EdgeInsets.only(left: 12, right: 12),
  //           child: Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               const Icon(CupertinoIcons.search, color: Colors.grey),
  //               const SizedBox(width: 12),
  //               Container(width: 1, height: 25, color: const Color(0xFFE0E0E0)),
  //               // Spacer(),
  //               // SvgPicture.asset('assets/icons/scheduling/booking/close.svg')
  //             ],
  //           ),
  //         ),
  //         prefixIconConstraints: const BoxConstraints(
  //           minWidth: 0,
  //           minHeight: 0,
  //         ),
  //         filled: true,
  //         contentPadding: const EdgeInsets.symmetric(
  //           vertical: 9.5,
  //           horizontal: 9.5,
  //         ),
  //         fillColor: const Color.fromRGBO(245, 246, 248, 1),
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(10),
  //           borderSide: BorderSide.none,
  //         ),
  //       ),
  //     ),
  //   ),
  // );

  Widget _buildContent() {
    if (widget.unifiedcontainercontent != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.unifiedcontainercontent!,
      );
    }
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
        },
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
      return DDMSSelectableList(
        options: _filteredOptions,
        selectedItems: _ddmsSelections,
        onSelectionChanged:
            (newSel) => setState(() => _ddmsSelections = newSel),
        showCheckboxes: widget.showCheckboxes ?? true,
      );
    }
    // Default single-selection options (String or Resource)
    if ((widget.resourceOptions != null &&
        widget.resourceOptions!.isNotEmpty)) {
      return Expanded(child: _buildResourceOptionsList());
    } else {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView.separated(
            separatorBuilder:
                (_, __) => const Divider(
                  height: 0.5,
                  thickness: 0.7,
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
                    if (widget.isDonethere == false)
                      Navigator.pop(context, opt);
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
    // return Expanded( //here is the resource thing is worked on !!
    //   child: Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
    //     child: widget.DDMS == false && widget.resourceOptions != null && widget.resourceOptions!.isNotEmpty
    //         ? ListView.separated(
    //       separatorBuilder: (_, __) => const Divider(
    //         height: 0.5,
    //         thickness: 0.7,
    //         color: Color.fromRGBO(0, 0, 0, 0.12),
    //       ),
    //       itemCount: _filteredResources.length,
    //       itemBuilder: (ctx, i) {
    //         final resource = _filteredResources[i];
    //         return Material(
    //           color: Colors.transparent,
    //           child: InkWell(
    //             onTap: () {
    //               Navigator.pop(context, resource);
    //             },
    //             child: Padding(
    //               padding: const EdgeInsets.symmetric(
    //                 horizontal: 0,
    //                 vertical: 8,
    //               ),
    //               child: Row(
    //                 children: [
    //                   CircleAvatar(
    //                     backgroundImage: NetworkImage(resource.imageUrl),
    //                     radius: 25,
    //                   ),
    //                   const SizedBox(width: 16),
    //                   Expanded(
    //                     child: Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Text(
    //                           resource.name,
    //                           style: const TextStyle(
    //                             fontSize: 14,
    //                             fontWeight: FontWeight.w500,
    //                           ),
    //                         ),
    //                         Text(
    //                           resource.designation,
    //                           style: const TextStyle(
    //                             fontSize: 12,
    //                             color: Color.fromRGBO(102, 112, 133, 1),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         );
    //       },
    //     )
    //         : ListView.separated(
    //       separatorBuilder: (_, __) => const Divider(
    //         height: 0.5,
    //         thickness: 0.7,
    //         color: Color.fromRGBO(0, 0, 0, 0.12),
    //       ),
    //       itemCount: _filteredOptions.length,
    //       padding: EdgeInsets.zero,
    //       itemBuilder: (ctx, i) {
    //         final opt = _filteredOptions[i];
    //         final sel = opt == _selectedOption;
    //         return Material(
    //           color: Colors.transparent,
    //           child: InkWell(
    //             onTap: () {
    //               setState(() => _selectedOption = opt);
    //               if (widget.isDonethere == false) Navigator.pop(context, opt);
    //             },
    //             child: Padding(
    //               padding: const EdgeInsets.symmetric(
    //                 horizontal: 0,
    //                 vertical: 10,
    //               ),
    //               child: Row(
    //                 children: [
    //                   Expanded(
    //                     child: Text(
    //                       opt,
    //                       style: const TextStyle(
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.w400,
    //                       ),
    //                     ),
    //                   ),
    //                   if (sel) const Icon(Icons.check, color: Colors.black),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         );
    //       },
    //     ),
    //   ),
    // );
    // return Expanded(
    //   child: Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
    //     child: ListView.separated(
    //       separatorBuilder:
    //           (_, __) => const Divider(
    //             height: 0.5,
    //             thickness: 0.7,
    //             color: Color.fromRGBO(0, 0, 0, 0.12),
    //           ),
    //       itemCount: _filteredOptions.length,
    //       padding: EdgeInsets.zero,
    //       itemBuilder: (ctx, i) {
    //         final opt = _filteredOptions[i];
    //         final sel = opt == _selectedOption;
    //         return Material(
    //           color: Colors.transparent,
    //           child: InkWell(
    //             onTap: () {
    //               setState(() => _selectedOption = opt);
    //               if (widget.isDonethere == false) Navigator.pop(context, opt);
    //             },
    //             child: Padding(
    //               padding: const EdgeInsets.symmetric(
    //                 horizontal: 0,
    //                 vertical: 10,
    //               ),
    //               child: Row(
    //                 children: [
    //                   Expanded(
    //                     child: Text(
    //                       opt,
    //                       style: const TextStyle(
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.w400,
    //                       ),
    //                     ),
    //                   ),
    //                   if (sel) const Icon(Icons.check, color: Colors.black),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         );
    //       },
    //     ),
    //   ),
    // );
  }
}
