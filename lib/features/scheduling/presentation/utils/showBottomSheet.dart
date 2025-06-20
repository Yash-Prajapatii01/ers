import 'dart:async';
import 'package:ers_linux/features/scheduling/data/models/udfModel.dart';
import 'package:ers_linux/features/scheduling/data/models/udfOptionsModel.dart';
import 'package:ers_linux/features/scheduling/presentation/utils/SearchService.dart';
import 'package:ers_linux/shared/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../data/models/resource_model.dart';
import '../widgets/ColorPicker/ColorPicker.dart';
import '../widgets/shared/CustomTextField.dart';
import '../widgets/UnifiedCalender/unifiedCalender.dart';
import '../widgets/shared/DDMS.dart';
import '../widgets/shared/priorityWheel.dart';
import 'BookingFormBloc/booking_form_bloc.dart';
import 'SearchHandler.dart';

typedef BottomSheetSelectionCallback = void Function(dynamic selected);

class BottomSheetService {
  static Future<void> showCustomBottomSheet({
    required BuildContext context,
    required Widget child,
    bool startFullSize = true,
    BottomSheetSelectionCallback? onSelected,
  }) async {
    final double initialSize = startFullSize ? 0.90 : 0.60;

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
    print("Here i am -> ${selected.runtimeType}");
    if (selected == null) return;
    if(selected is Map<String, Object>){
      onSelected?.call({
        'names' : selected['names'],
        'type': 'name-only',
      });
    }
    if (selected is Map<String, dynamic>) {
      print("Up there in the bottomsheet");
      if (selected['type'] == 'resource') {
        onSelected?.call({
          'resource': selected['resource'],
          'type': 'resource',
        });
      }
      if(selected['type'] == 'single-option'){
        onSelected?.call({
          'name': selected['name'],
          'id': selected['id'],
          'type': 'single-option',
        });
      }
      }
    // Handle different selection formats
    if (selected is List<UdfOptionsModel>) {
      final List<UdfOptionsModel> selectedIds =
          selected.map((opt) => opt).toList();
      onSelected?.call({'Udfselected': selectedIds, 'type': 'udf'});
    }
    if (selected is ResourceModel) {
      onSelected?.call({'resource': selected, 'type': 'resource'});
    }
    if (selected is Map<String, dynamic> &&
        selected['label'] is String &&
        selected['color'] is Color && selected['id'] is int) {
      print("Color label working");
      onSelected!({
        'label': selected['label'],
        'color': selected['color'],
        'id': selected['id'],
        'type': 'label-color',
      });
    } else if (child is BottomSheetOptions &&
        child.isColorPalleteNeeded == true &&
        selected is String) {
      onSelected!({'color': selected, 'type': 'color'});
    } else if (selected is String) {
      print("Up over there caought - $selected");
      onSelected!({'text': selected, 'type': 'text'});
    }
  }
}

class BottomSheetOptions extends StatefulWidget {
  final String title;
  final List<UdfOptionsModel>? options;
  final VoidCallback? onDone;
  final bool? isSearchEnabled;
  final bool? isTextFieldNeeded;
  final CustomTextField? customTextField;
  final Widget? unifiedcontainercontent;
  final bool? isDateWidget;
  final bool? isTimeWidget;
  final bool? isDragHandleNeeded;
  final bool? isPriority;
  final String? regex;
  final double? maxInputLength;
  final double? minInputLength;

  // final bool? isFTRCalender;
  final bool? isDonethere;
  final bool? DDMS;
  final String? SearchHintText;
  final bool? showCheckboxes;
  final bool? isColorPalleteNeeded;
  final List<UdfOptionsModel>? initialSelectedOptions;
  final List<TextInputFormatter>? inputFormatters;
  final DateTime? initialDate;
  final TimeOfDay? initialFromTime;
  final List<ResourceModel>? resourceOptions;
  final UdfModel? udfModel;

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
    this.regex,
    this.maxInputLength,
    this.minInputLength,
    this.udfModel,
    // this.isFTRCalender,
  });

  @override
  State<BottomSheetOptions> createState() => _BottomSheetOptionsState();
}
class _BottomSheetOptionsState extends State<BottomSheetOptions> {
  final TextEditingController _searchController = TextEditingController();
  UdfOptionsModel? _selectedOption;
  String textValue = '';
  List<UdfOptionsModel> _ddmsSelections = [];
  late DateTime _localDate;
  late bool _timePicked = false;
  late TimeOfDay _localTime;
  late Color _localColor;
  String _pickedLabel = 'None';
  Color _pickedColor = Colors.transparent;
  late int _pickedId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, bool> _expandedGroups = {};
  late final UnifiedSearchHandler? _searchHandler;

  static const List<String> _networkFieldTypes = [
    'PRJSS',
    'RSRSS',
    'REQSS',
    'TAGS',
  ];

  @override
  void initState() {
    super.initState();
    _localColor = Colors.transparent;
    _localDate = widget.initialDate ?? DateTime.now();
    _localTime = widget.initialFromTime ?? TimeOfDay.now();

    if (widget.DDMS == true && widget.initialSelectedOptions != null) {
      _ddmsSelections.addAll(widget.initialSelectedOptions!);
    }

    // Initialize search handler if search is enabled
    _initializeSearchHandler();
  }

  void _initializeSearchHandler() {
    if (widget.isSearchEnabled != true) {
      _searchHandler = null;
      return;
    }
    final isNetworkSearch =
        widget.udfModel != null &&
            widget.udfModel!.fieldType.isNotEmpty &&
            _networkFieldTypes.contains(widget.udfModel!.fieldType);

    if (isNetworkSearch) {
      // Create network search handler using UdfModel's fieldType
      _searchHandler = SearchHandlerFactory.createNetworkSearch(
        fieldType: widget.udfModel!.fieldType,
        initialOptions: widget.options ?? [],
        minQueryLength: 0,
        debounceDelay: const Duration(milliseconds: 500),
      );
    } else {
      _searchHandler = SearchHandlerFactory.createLocalSearch(
        options: widget.options ?? [],
        minQueryLength: 0,
        debounceDelay: const Duration(milliseconds: 300),
        caseSensitive: false,
        exactMatch: false,
      );
    }

    // Listen to search results
    _searchHandler?.addListener(_onSearchResultsChanged);

    // Listen to search input changes
    _searchController.addListener(_onSearchInputChanged);
  }

  void _onSearchInputChanged() {
    final query = _searchController.text;
    _searchHandler?.search(query);
  }

  void _onSearchResultsChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchHandler?.removeListener(_onSearchResultsChanged);
    _searchHandler?.dispose();
    super.dispose();
  }

  void _handleDone() {
    print('handle done called');
    if (widget.isTextFieldNeeded == true && _formKey.currentState != null) {
      final isValid = _formKey.currentState!.validate();
      if (!isValid) return;
      print('texfield se exit');
    }
    String result = '';
    Map<String, dynamic> resultData;
    if (widget.DDMS == true) {
      if (_ddmsSelections.isNotEmpty) {
        if (widget.udfModel?.fieldType == 'TAGS') {
          print("TAGSSS");
          final List<String> selectedNames = _ddmsSelections.map((opt) => opt.name).toList();
          Navigator.pop(context, {
            'type': 'names-only',
            'names': selectedNames,
          });
          widget.onDone?.call();
          return;
        }
        if (_ddmsSelections.length < 1) {
          print('In the DDMS');
          if (widget.udfModel!.fieldType == 'PRJSS') {
            context.read<BookingFormBloc>().add(
              SelectOptionEvent(
                name: _ddmsSelections.first.name,
                id: _ddmsSelections.first.id,
                fieldType: widget.udfModel!.fieldType,
              ),
            );
          }
        } else {
          //here we have to update fieldtype of the task udfModel to false (inactive)
        }
        final first = _ddmsSelections.first;
        final extra = _ddmsSelections.length - 1;
        result = extra > 0 ? '${first.name} +$extra' : '${first.name}';
        print('DDMS se exit');
      }
    } else if (widget.customTextField != null) {
      result = widget.customTextField!.controller?.text.trim() ?? '';
      print('customfield se exit');
    } else if (widget.isTextFieldNeeded == true) {
      result = textValue;
      print('txf se exit');
    } else if (_selectedOption != null) {
      final name = _selectedOption!.name;
      final id = _selectedOption!.id;
      print('✅ Done clicked; option id: $id, name: $name');
      result = name;
    } else if (widget.isPriority == true) {
      Navigator.pop<Map<String, dynamic>>(context, {
        'label': _pickedLabel,
        'color': _pickedColor,
        'id' : _pickedId,
      });
      print('ispriority se exit');
      return;
    } else if (widget.isColorPalleteNeeded == true) {
      result = _localColor.value.toString();
      print('Colorpallete se exit');
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
        print('TimeWidget se exit');
      } else {
        result = DateFormat('d MMM yyyy').format(_localDate);
        print('DateWidget se exit');
      }
    }

    print('_ddmsSelections: ${_ddmsSelections.length}');
    print('result form show bottom sheet: $result & ${result.runtimeType}');

    Navigator.pop(context, (_ddmsSelections.length == 0) ? result : _ddmsSelections);
    widget.onDone?.call();
  }

  // Widget _buildResourceOptionsList() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //     child: ListView.separated(
  //       itemCount: widget.resourceOptions!.length,
  //       separatorBuilder:
  //           (_, __) => const Divider(
  //         height: 0.5,
  //         thickness: 0.7,
  //         color: Color.fromRGBO(0, 0, 0, 0.12),
  //       ),
  //       itemBuilder: (ctx, i) {
  //         final resource = widget.resourceOptions![i];
  //         return Material(
  //           color: Colors.transparent,
  //           child: InkWell(
  //             onTap: () {
  //               Navigator.pop(context, resource);
  //             },
  //             child: Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
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
  //     ),
  //   );
  // }

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
          hintText: widget.SearchHintText ?? 'Search...',
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
            onTap: () {
              setState(() {
                _searchController.clear();
                _searchHandler?.clearSearch();
              });
            },
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
      ),
    ),
  );

  // Widget _buildOptionItem(UdfOptionsModel opt) {
  //   final isSelected = opt.name == _selectedOption;
  //
  //   return Material(
  //     color: Colors.transparent,
  //     child: InkWell(
  //       onTap: () {
  //         setState(() => _selectedOption = opt);
  //         print('➡️ Selected Option → ID: ${opt.id}, Name: ${opt.name}');
  //         if(widget.udfModel!.fieldType == 'RSRSS'){
  //           context.read<BookingFormBloc>().add(SelectOptionEvent(name: opt.name, id: opt.id, fieldType: widget.udfModel!.fieldType));
  //         }
  //         if (!widget.isDonethere!) {
  //           Navigator.pop(context, opt.name);
  //         }
  //       },
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 10),
  //         child: Row(
  //           children: [
  //             Expanded(
  //               child: Text(
  //                 opt.name,
  //                 style: const TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w400,
  //                 ),
  //               ),
  //             ),
  //             if (isSelected) const Icon(Icons.check, color: Colors.black),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  Widget _buildOptionItem(UdfOptionsModel opt) {
    final isSelected = opt.name == _selectedOption?.name;

    final shouldShowImage =
        widget.udfModel?.fieldType == 'RSRSS' &&
            opt.imgUrl != null &&
            opt.imgUrl!.isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() => _selectedOption = opt);
          print('➡️ Selected Option → ID: ${opt.id}, Name: ${opt.name}');

          // Handle different field types
          if (widget.udfModel!.fieldType == 'RSRSS') {
            context.read<BookingFormBloc>().add(
              SelectOptionEvent(
                name: opt.name,
                id: opt.id,
                fieldType: widget.udfModel!.fieldType,
              ),
            );

            // For resources, return the complete object with image info
            if (!widget.isDonethere!) {
              print("Is Done there called !!");
              Navigator.pop(context, {
                'type': 'resource',
                'resource': ResourceModel(
                  id: opt.id,
                  name: opt.name,
                  designation: opt.performing ?? '',
                  imageUrl: opt.imgUrl ?? '',
                ),
              });
              return;
            }
          }
          if (widget.udfModel!.fieldType == 'REQSS' || widget.udfModel!.fieldType == 'PRJSS') {
            if(widget.udfModel!.fieldType == 'REQSS'){
              print("Requirement se hello world");
              context.read<BookingFormBloc>().add(
                SelectOptionEvent(
                  name: opt.name,
                  id: opt.id,
                  fieldType: widget.udfModel!.fieldType,
                ),
              );
            }
            if (widget.udfModel!.fieldType == 'PRJSS') {
              context.read<BookingFormBloc>().add(
                SelectOptionEvent(
                  name: opt.name,
                  id: opt.id,
                  fieldType: widget.udfModel!.fieldType,
                ),
              );
            }
          }
          if (!widget.isDonethere!) {
            Navigator.pop(context, {
              'type': 'single-option',
              'name': opt.name,
              'id': opt.id,
            });
            return;
          }
          // if (!widget.isDonethere!) {
          //   Navigator.pop(context, opt.name);
          // }

        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
          child: Row(
            children: [
              // Show avatar for resources
              if (shouldShowImage) ...[
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.calenderPillColor,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      opt.imgUrl!,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback to initials if image fails to load
                        return Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.calenderPillColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              opt.name.isNotEmpty
                                  ? opt.name[0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.calenderPillColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.calenderPillColor,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              // Content section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      opt.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    // Show additional info for resources
                    if (shouldShowImage &&
                        opt.performing != null &&
                        opt.performing!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          opt.performing!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromRGBO(102, 112, 133, 1),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Selection indicator
              if (isSelected)
                const Icon(Icons.check, color: Colors.black, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 0.5,
      thickness: 0.7,
      color: Color.fromRGBO(0, 0, 0, 0.12),
    );
  }

  Widget _buildOptionsList() {
    // Get options from search handler if search is enabled, otherwise use widget options
    final displayOptions =
    widget.isSearchEnabled == true && _searchHandler != null
        ? _searchHandler.filteredOptions
        : (widget.options ?? <UdfOptionsModel>[]);

    if (_searchHandler?.error != null) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No element found !!',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.darkBlack,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Use the search handler's grouped options helper
    final groupedOptions =
        _searchHandler?.groupedOptions ?? _groupOptions(displayOptions);

    List<Widget> _buildItemList(List<UdfOptionsModel> options) {
      return [
        for (int i = 0; i < options.length; i++) ...[
          _buildOptionItem(options[i]),
          if (i < options.length - 1) _buildDivider(),
        ],
      ];
    }

    List<Widget> _buildGroupedSection(
        String groupName,
        List<UdfOptionsModel> options,
        ) {
      final isExpanded = _expandedGroups[groupName] ?? false;
      final shouldCollapse = options.length > 5 && !isExpanded;
      final visibleOptions =
      shouldCollapse ? options.take(5).toList() : options;

      return [
        if (groupName.isNotEmpty) // Only show header for named groups
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 16, 8),
            child: Text(
              groupName,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                color: AppColors.darkBlack,
              ),
            ),
          ),
        ..._buildItemList(visibleOptions),
        if (shouldCollapse)
          InkWell(
            onTap: () {
              setState(() {
                _expandedGroups[groupName] = true;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Show more',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
      ];
    }

    final items = <Widget>[
      // Show loading indicator when searching
      if (_searchHandler?.isLoading ?? false)
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: CircularProgressIndicator()),
        )
      else ...[
        // Grouped sections
        for (var entry in groupedOptions.entries)
          ..._buildGroupedSection(entry.key, entry.value),
      ],

      // Show "No results" message
      if (_searchHandler?.hasNoResults ?? false)
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'No results found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ),
    ];

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(padding: EdgeInsets.zero, children: items),
      ),
    );
  }

  Map<String, List<UdfOptionsModel>> _groupOptions(
      List<UdfOptionsModel> options,
      ) {
    final grouped = <String, List<UdfOptionsModel>>{};
    final ungrouped = <UdfOptionsModel>[];

    for (final option in options) {
      final group = option.performing?.trim();
      if (group != null && group.isNotEmpty) {
        grouped.putIfAbsent(group, () => []).add(option);
      } else {
        ungrouped.add(option);
      }
    }

    if (ungrouped.isNotEmpty) {
      grouped[''] = ungrouped;
    }

    return grouped;
  }

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
    if (widget.isPriority == true && widget.options != null) {
      return CustomWheelPicker(
        onSelected: (map) {
          setState(() {
            _pickedLabel = map.name;
            _pickedColor = map.color!;
            _pickedId = map.id;
          });
        },
        options: widget.options!,
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
          regex: widget.regex,
          maxInputLength: widget.maxInputLength,
          minInputLength: widget.minInputLength,
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
          child: Form(
            key: _formKey,
            child: TextFormField(
              expands: true,
              maxLines: null,
              minLines: null,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(fontSize: 16),
              onChanged: (v) {
                setState(() {
                  textValue = v;
                });
              },
              validator: (value) {
                final input = value ?? '';
                final minLength = widget.minInputLength?.toInt() ?? 0;
                final maxLength = widget.maxInputLength?.toInt();

                if (input.length < minLength) {
                  return 'Value cannot be less than $minLength characters';
                }
                if (maxLength != null && input.length > maxLength) {
                  return 'Value cannot be greater than $maxLength characters';
                }

                if (widget.regex != null) {
                  final regex = RegExp(widget.regex!);
                  if (!regex.hasMatch(input)) {
                    return 'Invalid input format';
                  }
                }

                return null;
              },
              decoration: const InputDecoration.collapsed(
                hintText: 'Type Something...',
              ),
            ),
          ),
        ),
      );
    }

    if (widget.DDMS == true) {
      // Get options from search handler for DDMS too
      final ddmsOptions =
      widget.isSearchEnabled == true && _searchHandler != null
          ? _searchHandler.filteredOptions
          : widget.options!;

      return DDMSSelectableList(
        options: ddmsOptions,
        selectedItems: _ddmsSelections,
        onSelectionChanged:
            (newSel) => setState(() => _ddmsSelections = newSel),
        showCheckboxes: widget.showCheckboxes ?? true,
      );
    }

    // if ((widget.resourceOptions != null &&
    //     widget.resourceOptions!.isNotEmpty)) {
    //   return Expanded(child: _buildResourceOptionsList());
    // } else {}
    return _buildOptionsList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          const Divider(height: 0.5, color: Color.fromRGBO(0, 0, 0, 0.12)),
          if (widget.isSearchEnabled == true) ...[
            _buildSearchField(),
            _buildContent(),
          ] else ...[
            _buildContent(),
          ],
        ],
      ),
    );
  }
}
// class _BottomSheetOptionsState extends State<BottomSheetOptions> {
//   final TextEditingController _searchController = TextEditingController();
//   String? _selectedOption;
//   String textValue = '';
//   List<UdfOptionsModel> _ddmsSelections = [];
//   late DateTime _localDate;
//   late bool _timePicked = false;
//   late TimeOfDay _localTime;
//   late Color _localColor;
//   String _pickedLabel = 'None';
//   Color _pickedColor = Colors.transparent;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final Map<String, bool> _expandedGroups = {};
//   late final UnifiedSearchHandler _searchHandler;
//   Timer? _debounceTimer;
//   List<UdfOptionsModel> _searchResults = [];
//   bool _isSearching = false;
//   String _lastSearchQuery = '';
//
//   static const List<String> _networkFieldTypes = ['PRJSS', 'RSRSS', 'REQSS'];
//
//   @override
//   void initState() {
//     super.initState();
//     _localColor = Colors.transparent;
//     _localDate = widget.initialDate ?? DateTime.now();
//     _localTime = widget.initialFromTime ?? TimeOfDay.now();
//
//     if (widget.DDMS == true && widget.initialSelectedOptions != null) {
//       _ddmsSelections.addAll(widget.initialSelectedOptions!);
//     }
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     _debounceTimer?.cancel();
//     super.dispose();
//   }
//
//
//   void _handleDone() {
//     print('handle done called');
//     if (widget.isTextFieldNeeded == true && _formKey.currentState != null) {
//       final isValid = _formKey.currentState!.validate();
//       if (!isValid) return;
//       print('texfield se exit');
//     }
//     String result = '';
//     Map<String, dynamic> resultData;
//     if (widget.DDMS == true) {
//       if (_ddmsSelections.isNotEmpty) {
//         final first = _ddmsSelections.first;
//         final extra = _ddmsSelections.length - 1;
//         result = extra > 0 ? '${first.name} +$extra' : '${first.name}';
//         print('DDMS se exit');
//       }
//     } else if (widget.customTextField != null) {
//       result = widget.customTextField!.controller?.text.trim() ?? '';
//       print('customfield se exit');
//     } else if (widget.isTextFieldNeeded == true) {
//       result = textValue;
//       print('txf se exit');
//     } else if (_selectedOption != null) {
//       result = _selectedOption!;
//       print('_selectionOption se exit');
//     } else if (widget.isPriority == true) {
//       Navigator.pop<Map<String, dynamic>>(context, {
//         'label': _pickedLabel,
//         'color': _pickedColor,
//       });
//       print('ispriority se exit');
//       return;
//     } else if (widget.isColorPalleteNeeded == true) {
//       result = _localColor.value.toString();
//       print('Colorpallete se exit');
//     } else if (widget.isDateWidget!) {
//       if (widget.isTimeWidget!) {
//         final TimeOfDay useTime = _timePicked ? _localTime : TimeOfDay.now();
//         final dt = DateTime(
//           _localDate.year,
//           _localDate.month,
//           _localDate.day,
//           useTime.hour,
//           useTime.minute,
//         );
//         result = DateFormat('d MMM yyyy, h:mm a').format(dt);
//         print('TimeWidget se exit');
//       } else {
//         result = DateFormat('d MMM yyyy').format(_localDate);
//         print('DateWidget se exit');
//       }
//     }
//
//     print('_ddmsSelections: ${_ddmsSelections.length}');
//     print('result form show bottom sheet: $result');
//
//     Navigator.pop(context, _ddmsSelections.isEmpty ? result : _ddmsSelections);
//     widget.onDone?.call();
//   }
//
//   Widget _buildResourceOptionsList() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: ListView.separated(
//         itemCount: widget.resourceOptions!.length,
//         separatorBuilder:
//             (_, __) => const Divider(
//           height: 0.5,
//           thickness: 0.7,
//           color: Color.fromRGBO(0, 0, 0, 0.12),
//         ),
//         itemBuilder: (ctx, i) {
//           final resource = widget.resourceOptions![i];
//           return Material(
//             color: Colors.transparent,
//             child: InkWell(
//               onTap: () {
//                 Navigator.pop(context, resource);
//               },
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       backgroundImage: NetworkImage(resource.imageUrl),
//                       radius: 25,
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             resource.name,
//                             style: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           Text(
//                             resource.designation,
//                             style: const TextStyle(
//                               fontSize: 12,
//                               color: Color.fromRGBO(102, 112, 133, 1),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//   Widget _buildHeader() => Column(
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       if (widget.isDragHandleNeeded!)
//         Center(
//           child: Container(
//             width: 29,
//             height: 4,
//             margin: const EdgeInsets.only(top: 5),
//             decoration: BoxDecoration(
//               color: const Color(0xFFD0D5DD),
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//         ),
//       Padding(
//         padding: const EdgeInsets.symmetric(vertical: 2.0),
//         child: SizedBox(
//           height: 50,
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     child: Text(
//                       'Cancel',
//                       style: TextStyle(
//                         color: Color.fromRGBO(242, 48, 48, 1),
//                         fontSize: 16,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Center(
//                 child: Text(
//                   widget.title,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 16,
//                     color: Color.fromRGBO(51, 51, 51, 1),
//                   ),
//                 ),
//               ),
//               if (widget.isDonethere == true)
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: GestureDetector(
//                     onTap: _handleDone,
//                     child: const Padding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 10,
//                       ),
//                       child: Text(
//                         'Done',
//                         style: TextStyle(
//                           color: Colors.blue,
//                           fontSize: 17,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     ],
//   );
//
//
//   Widget _buildSearchField() => Padding(
//     padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//     child: SizedBox(
//       width: double.infinity,
//       height: 40,
//       child: TextField(
//         controller: _searchController,
//         style: const TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w400,
//           color: Colors.black,
//         ),
//         decoration: InputDecoration(
//           hintText: widget.SearchHintText ?? 'Search...',
//           hintStyle: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w400,
//             color: Color.fromRGBO(102, 112, 133, 0.5),
//           ),
//           prefixIcon: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _isSearching
//                     ? const SizedBox(
//                   width: 16,
//                   height: 16,
//                   child: CircularProgressIndicator(strokeWidth: 2),
//                 )
//                     : const Icon(CupertinoIcons.search, color: Colors.grey),
//                 const SizedBox(width: 12),
//                 Container(width: 1, height: 25, color: const Color(0xFFE0E0E0)),
//               ],
//             ),
//           ),
//           prefixIconConstraints: const BoxConstraints(
//             minWidth: 0,
//             minHeight: 0,
//           ),
//           suffixIcon:
//           _searchController.text.isNotEmpty
//               ? GestureDetector(
//             onTap:
//                 () => setState(() {
//               _searchController.clear();
//             }),
//             child: Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: SvgPicture.asset(
//                 'assets/icons/scheduling/booking/close.svg',
//                 width: 16,
//                 height: 16,
//                 fit: BoxFit.contain,
//               ),
//             ),
//           )
//               : null,
//           filled: true,
//           fillColor: const Color.fromRGBO(245, 246, 248, 1),
//           contentPadding: const EdgeInsets.symmetric(
//             vertical: 9.5,
//             horizontal: 9.5,
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide.none,
//           ),
//         ),
//       ),
//     ),
//   );
//
//   Widget _buildOptionItem(UdfOptionsModel opt) {
//     final isSelected = opt.name == _selectedOption;
//
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: () {
//           setState(() => _selectedOption = opt.name);
//           if (!widget.isDonethere!) {
//             Navigator.pop(context, opt.name);
//           }
//         },
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 10),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   opt.name,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ),
//               if (isSelected) const Icon(Icons.check, color: Colors.black),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDivider() {
//     return const Divider(
//       height: 0.5,
//       thickness: 0.7,
//       color: Color.fromRGBO(0, 0, 0, 0.12),
//     );
//   }
//
//
//   Widget _buildOptionsList() {
//     final displayOptions =
//     widget.isSearchEnabled == true && _searchResults.isNotEmpty
//         ? _searchResults
//         : (widget.options ?? <UdfOptionsModel>[]);
//
//     // Group options
//     final groupedOptions = <String, List<UdfOptionsModel>>{};
//     final ungroupedOptions = <UdfOptionsModel>[];
//
//     for (final opt in displayOptions) {
//       final performing = opt.performing?.trim();
//       if (performing != null && performing.isNotEmpty) {
//         groupedOptions.putIfAbsent(performing, () => []).add(opt);
//       } else {
//         ungroupedOptions.add(opt);
//       }
//     }
//
//     List<Widget> _buildItemList(List<UdfOptionsModel> options) {
//       return [
//         for (int i = 0; i < options.length; i++) ...[
//           _buildOptionItem(options[i]),
//           if (i < options.length - 1) _buildDivider(),
//         ],
//       ];
//     }
//
//     List<Widget> _buildGroupedSection(
//         String groupName,
//         List<UdfOptionsModel> options,
//         ) {
//       final isExpanded = _expandedGroups[groupName] ?? false;
//       final shouldCollapse = options.length > 5 && !isExpanded;
//       final visibleOptions =
//       shouldCollapse ? options.take(5).toList() : options;
//
//       return [
//         Padding(
//           padding: const EdgeInsets.fromLTRB(0, 16, 16, 8),
//           child: Text(
//             groupName,
//             style: const TextStyle(
//               fontSize: 16,
//               fontFamily: 'Inter',
//               fontWeight: FontWeight.w500,
//               color: AppColors.darkBlack,
//             ),
//           ),
//         ),
//         ..._buildItemList(visibleOptions),
//         if (shouldCollapse)
//           InkWell(
//             onTap: () {
//               setState(() {
//                 _expandedGroups[groupName] = true;
//               });
//             },
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8),
//               child: Text(
//                 'Show more',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontFamily: 'Inter',
//                   fontWeight: FontWeight.w400,
//                   color: Theme.of(context).primaryColor,
//                 ),
//               ),
//             ),
//           ),
//       ];
//     }
//
//     final items = <Widget>[
//       // Show loading indicator when searching
//       if (_isSearching && widget.isSearchEnabled!)
//         const Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Center(child: CircularProgressIndicator()),
//         )
//       else ...[
//         // Grouped sections
//         for (var entry in groupedOptions.entries)
//           ..._buildGroupedSection(entry.key, entry.value),
//         if (ungroupedOptions.isNotEmpty) ..._buildItemList(ungroupedOptions),
//       ],
//
//       // Show "No results" message
//       if (!_isSearching &&
//           displayOptions.isEmpty &&
//           _searchController.text.isNotEmpty)
//         const Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Center(
//             child: Text(
//               'No results found',
//               style: TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//           ),
//         ),
//     ];
//
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: ListView(padding: EdgeInsets.zero, children: items),
//       ),
//     );
//   }
//
//   Widget _buildContent() {
//     if (widget.unifiedcontainercontent != null) {
//       return Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: widget.unifiedcontainercontent!,
//       );
//     }
//     if (widget.isColorPalleteNeeded == true) {
//       return Expanded(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: ColorPickerGrid(
//             onColorSelected:
//                 (c) => setState(() {
//               _localColor = c;
//             }),
//           ),
//         ),
//       );
//     }
//     if (widget.isPriority == true && widget.options != null) {
//       return CustomWheelPicker(
//         onSelected: (map) {
//           setState(() {
//             _pickedLabel = map.name;
//             _pickedColor = map.color!;
//           });
//         },
//         options: widget.options!,
//       );
//     }
//     if (widget.isDateWidget == true && widget.isTimeWidget == true) {
//       return UnifiedCalendar(
//         initialDate: _localDate,
//         initialFromTime: _localTime,
//         showTime: true,
//         onDateSelected: (combined) {
//           setState(() {
//             _localDate = combined;
//             _localTime = TimeOfDay.fromDateTime(combined);
//             _timePicked = true;
//           });
//         },
//       );
//     }
//     if (widget.isDateWidget == true) {
//       return UnifiedCalendar(
//         initialDate: _localDate,
//         initialFromTime: _localTime,
//         showTime: false,
//         onDateSelected:
//             (v) => setState(() {
//           _localDate = v;
//         }),
//       );
//     }
//
//     if (widget.isTextFieldNeeded == true) {
//       return Expanded(
//         child:
//         (widget.customTextField != null)
//             ? CustomTextField(
//           hintText: widget.customTextField!.hintText,
//           regex: widget.regex,
//           maxInputLength: widget.maxInputLength,
//           minInputLength: widget.minInputLength,
//           controller: widget.customTextField?.controller,
//           keyboardType: widget.customTextField!.keyboardType,
//           inputFormatters: widget.customTextField!.inputFormatters,
//           onChanged: (v) {
//             setState(() => textValue = v);
//             widget.customTextField!.onChanged?.call(v);
//           },
//         )
//             : Padding(
//           padding: const EdgeInsets.all(16),
//           child: Form(
//             key: _formKey,
//             child: TextFormField(
//               expands: true,
//               maxLines: null,
//               minLines: null,
//               keyboardType: TextInputType.multiline,
//               style: const TextStyle(fontSize: 16),
//               onChanged: (v) {
//                 setState(() {
//                   textValue = v;
//                 });
//               },
//               validator: (value) {
//                 final input = value ?? '';
//                 final minLength = widget.minInputLength?.toInt() ?? 0;
//                 final maxLength = widget.maxInputLength?.toInt();
//
//                 if (input.length < minLength) {
//                   return 'Value cannot be less than $minLength characters';
//                 }
//                 if (maxLength != null && input.length > maxLength) {
//                   return 'Value cannot be greater than $maxLength characters';
//                 }
//
//                 if (widget.regex != null) {
//                   final regex = RegExp(widget.regex!);
//                   if (!regex.hasMatch(input)) {
//                     return 'Invalid input format';
//                   }
//                 }
//
//                 return null;
//               },
//               decoration: const InputDecoration.collapsed(
//                 hintText: 'Type Something...',
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//
//     if (widget.DDMS == true) {
//       return DDMSSelectableList(
//         options:
//         widget.isSearchEnabled == true && _searchResults.isNotEmpty? _searchResults : widget.options!,
//         selectedItems: _ddmsSelections,
//         onSelectionChanged:
//             (newSel) => setState(() => _ddmsSelections = newSel),
//         showCheckboxes: widget.showCheckboxes ?? true,
//       );
//     }
//
//     if ((widget.resourceOptions != null &&
//         widget.resourceOptions!.isNotEmpty)) {
//       return Expanded(child: _buildResourceOptionsList());
//     } else {
//       // options for the single selection
//       return _buildOptionsList();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Column(
//         children: [
//           _buildHeader(),
//           const Divider(height: 0.5, color: Color.fromRGBO(0, 0, 0, 0.12)),
//           if (widget.isSearchEnabled == true) ...[
//             _buildSearchField(),
//             _buildContent(),
//           ] else ...[
//             _buildContent(),
//           ],
//         ],
//       ),
//     );
//   }
// }

