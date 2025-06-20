import 'package:ers_linux/features/scheduling/data/models/udfOptionsModel.dart';
import 'package:ers_linux/features/scheduling/presentation/screens/NotesPageScreen.dart';
import 'package:ers_linux/features/scheduling/presentation/widgets/shared/CustomTextField.dart';
import 'package:ers_linux/features/scheduling/presentation/widgets/shared/resource_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../data/models/udfModel.dart';
import '../utils/showBottomSheet.dart';
import 'UnifiedCalender/CustomContent/CustomMenu.dart';
import 'UnifiedCalender/unifiedCalender.dart';
import 'UnifiedContainerTile/tile_interaction_type.dart';
import 'UnifiedContainerTile/unifiedContainerTile.dart';
import 'shared/CustomRateSheet.dart';

class UdfTileBuilder extends StatefulWidget {
  final UdfModel udf;
  final Function(String, dynamic)? onValueChanged;
  final bool showTaskField;
  final Map<String, List<UdfModel>>? originalFieldTypes; // New parameter

  const UdfTileBuilder({
    super.key,
    required this.udf,
    this.onValueChanged,
    this.showTaskField = false,
    this.originalFieldTypes,
  });

  @override
  State<UdfTileBuilder> createState() => _UdfTileBuilderState();
}

class _UdfTileBuilderState extends State<UdfTileBuilder>
    with AutomaticKeepAliveClientMixin<UdfTileBuilder> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _fractionController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _numberController.dispose();
    _fractionController.dispose();
    _urlController.dispose();
    super.dispose();
  }
  String parseColorFromString(String colorString) {
    // Parse the decimal string to an integer
    int colorValue = int.parse(colorString);

    // Extract ARGB components
    int alpha = (colorValue >> 24) & 0xFF;
    int red   = (colorValue >> 16) & 0xFF;
    int green = (colorValue >> 8) & 0xFF;
    int blue  = colorValue & 0xFF;

    // Format RGB as hex, alpha as normalized float
    String hex = '#${red.toRadixString(16).padLeft(2, '0').toUpperCase()}'
        '${green.toRadixString(16).padLeft(2, '0').toUpperCase()}'
        '${blue.toRadixString(16).padLeft(2, '0').toUpperCase()}';

    String alphaFloat = (alpha / 255).toStringAsFixed(0); // No decimals since you wanted `;1`

    return '$hex;$alphaFloat';
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    final udf = widget.udf;

    switch (udf.fieldType) {
      case 'REQSS':
        return UnifiedContainerTile(
          iconPath: 'requirements',
          title: udf.displayName,
          interactionType: TileInteractionType.bottomSheet,
          fullSizeBottomSheet: true,
          bottomSheetContent: BottomSheetOptions(
            isSearchEnabled: true,
            options: udf.udfOptionsList,
            udfModel: udf,
            isDonethere: false,
          ),
          onOptionSelected: (v) {
            print("Updating!!!!");
            widget.onValueChanged?.call(udf.code, v);
          },
        );
      // case 'PRJSS':
      case 'TSKSS':
        return UnifiedContainerTile(
          title: 'Task',
          iconPath: 'ddss',
          interactionType: TileInteractionType.bottomSheet,
          bottomSheetContent: BottomSheetOptions(
            isSearchEnabled: true,
            title: 'Tasks',
            udfModel: udf,
            isDonethere: false,
            options: udf.udfOptionsList,
          ),
          onOptionSelected: (value) {
            widget.onValueChanged?.call(udf.code, value);
          },
        );

      case 'RESOURCE_PROJECT_GROUP':
        return ResourceSelector(
          showTaskField: widget.showTaskField,
          ResourceProjectUdf: udf,
          originalFieldTypes: widget.originalFieldTypes,
          onProjectValueChanged: (code, value) {
            widget.onValueChanged?.call(code, value);
          },
          // Pass the original field types
          onValueChanged: (value) {
            widget.onValueChanged?.call(udf.code, value);
          },
        );

      case 'ROLEPS':
        return UnifiedContainerTile(
          iconPath: 'roles',
          title: udf.displayName,
          interactionType: TileInteractionType.bottomSheet,
          bottomSheetContent: BottomSheetOptions(
            isSearchEnabled: true,
            udfModel: udf,
            isDonethere: false,
            options: udf.udfOptionsList,
          ),
          onOptionSelected: (value) {
            widget.onValueChanged?.call(udf.code, value);
          },
        );

      // case 'DATIM':
      //   if (udf.code == 'start_time') {
      //     return UnifiedCalendar(
      //       initialDate: DateTime.now(),
      //       isRangePicker: true,
      //       showTime: true,
      //       initialFromTime: const TimeOfDay(hour: 9, minute: 0),
      //       repeatOptions: [
      //         'None',
      //         'Daily',
      //         'Weekly',
      //         'Monthly',
      //         'Yearly',
      //         'Custom',
      //       ],
      //       onRepeatSelected: (value) {
      //         if (value == 'Custom') {
      //           BottomSheetService.showCustomBottomSheet(
      //             context: context,
      //             child: BottomSheetOptions(
      //               title: 'Custom',
      //               unifiedcontainercontent: Column(children: [CustomMenu()]),
      //             ),
      //           );
      //         }
      //       },
      //       onDateSelected: (value) {
      //         widget.onValueChanged?.call(udf.code, value);
      //       },
      //     );
      //   }
      //   if (udf.code == 'end_time') {
      //     return SizedBox.shrink();
      //   } else {
      //     return UnifiedContainerTile(
      //       title: udf.displayName,
      //       iconPath: 'date',
      //       interactionType: TileInteractionType.bottomSheet,
      //       fullSizeBottomSheet: true,
      //       bottomSheetContent: BottomSheetOptions(
      //         title: udf.displayName,
      //         isDateWidget: true,
      //         isTimeWidget: true,
      //       ),
      //     );
      //   }
      case 'DATIM':
        if (udf.code == 'start_time') {
          return UnifiedCalendar(
            initialDate: DateTime.now(),
            isRangePicker: true,
            showTime: true,
            initialFromTime: const TimeOfDay(hour: 9, minute: 0),
            initialToTime: const TimeOfDay(hour: 17, minute: 0),
            repeatOptions: [
              'None',
              'Daily',
              'Weekly',
              'Monthly',
              'Yearly',
              'Custom',
            ],
            onRepeatSelected: (value) {
              if (value == 'Custom') {
                BottomSheetService.showCustomBottomSheet(
                  context: context,
                  child: BottomSheetOptions(
                    title: 'Custom',
                    unifiedcontainercontent: Column(children: [CustomMenu()]),
                  ),
                );
              }
            },
            onRangeChanged: (fromDate, fromTime, toDate, toTime) {
              final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
              final startDateTime = formatter.format(
                DateTime(
                  fromDate.year,
                  fromDate.month,
                  fromDate.day,
                  fromTime.hour,
                  fromTime.minute,
                ),
              );
              final endDateTime = formatter.format(
                DateTime(
                  toDate.year,
                  toDate.month,
                  toDate.day,
                  toTime.hour,
                  toTime.minute,
                ),
              );
              widget.onValueChanged?.call('start_time', startDateTime);
              widget.onValueChanged?.call('end_time', endDateTime);
            },
          );
        } else if (udf.code == 'end_time') {
          return SizedBox.shrink();
        } else {
          return UnifiedContainerTile(
            title: udf.displayName,
            iconPath: 'date',
            interactionType: TileInteractionType.bottomSheet,
            fullSizeBottomSheet: true,
            bottomSheetContent: BottomSheetOptions(
              title: udf.displayName,
              isDateWidget: true,
              isTimeWidget: true,
            ),
            onOptionSelected: (value) {
              print("Here is the value -> $value");
              final localDateTime = DateFormat(
                'dd MMM yyyy, hh:mm a',
              ).parse(value);
              final isoUtcString = localDateTime.toUtc().toIso8601String();
              print(isoUtcString);
              widget.onValueChanged?.call(udf.code, isoUtcString);
            },
          );
        }

      case 'EFFORT':
        return UnifiedContainerTile(
          title: udf.displayName,
          iconPath: 'efforts',
          interactionType: TileInteractionType.popupMenu,
          isPinTextNeeded: true,
          popMenuOptions: ['% Capacity', 'Hours', 'FTE'],
          onOptionSelected: (value) {
            print("UdfTile -> $value");
            widget.onValueChanged?.call(udf.code, value);
          },
        );

      case 'CHK':
        return UnifiedContainerTile(
          title: udf.displayName,
          iconPath: 'confirmed',
          interactionType: TileInteractionType.popupMenu,
          popMenuOptions: ['Yes', 'No'],
          onOptionSelected: (value) {
            final boolValue = value == 'Yes' ? true : false;
            widget.onValueChanged?.call(udf.code, boolValue);
          },
        );

      case 'INT':
        if (udf.code == 'progress') {
          return UnifiedContainerTile(
            title: udf.displayName,
            iconPath: 'slider',
            interactionType: TileInteractionType.expandable,
            onSliderChanged: (value) {
              widget.onValueChanged?.call(udf.code, value.toInt());
            },
          );
        } else {
          return UnifiedContainerTile(
            title: udf.displayName,
            iconPath: 'numbers',
            interactionType: TileInteractionType.bottomSheet,
            bottomSheetContent: BottomSheetOptions(
              title: udf.displayName,
              isTextFieldNeeded: true,
              udfModel: udf,
              customTextField: CustomTextField(
                hintText: udf.displayName,
                controller: _numberController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                regex: udf.regex,
                onChanged: (_) => setState(() {}),
              ),
              onDone: () => setState(() {}),
            ),
            onOptionSelected: (value) {
              widget.onValueChanged?.call(udf.code, value);
            },
          );
        }

      case 'FLOAT':
        return UnifiedContainerTile(
          title: udf.displayName,
          iconPath: 'fraction',
          interactionType: TileInteractionType.bottomSheet,
          bottomSheetContent: BottomSheetOptions(
            title: udf.displayName,
            udfModel: udf,
            isTextFieldNeeded: true,
            customTextField: CustomTextField(
              hintText: udf.displayName,
              controller: _numberController,
              keyboardType: TextInputType.number,
              regex: udf.regex,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
              ],
              onChanged: (_) => setState(() {}),
            ),
            onDone: () => setState(() {}),
          ),
          onOptionSelected: (value) {
            widget.onValueChanged?.call(udf.code, value);
          },
        );

      case 'USS':
        return UnifiedContainerTile(
          title: udf.displayName,
          iconPath: 'ddss',
          interactionType: TileInteractionType.bottomSheet,
          bottomSheetContent: BottomSheetOptions(
            title: udf.displayName,
            udfModel: udf,
            isDonethere: false,
            isSearchEnabled: true,
            options: udf.udfOptionsList,
          ),
          onOptionSelected: (value) {
            widget.onValueChanged?.call(udf.code, value);
          },
        );

      case 'TAGS':
        return UnifiedContainerTile(
          title: udf.displayName,
          iconPath: 'tags',
          interactionType: TileInteractionType.bottomSheet,
          bottomSheetContent: BottomSheetOptions(
            title: udf.displayName,
            options: udf.udfOptionsList,
            isSearchEnabled: true,
            udfModel: udf,
            DDMS: true,
            showCheckboxes: false,
          ),
          onMultipleOptionsSelected: (value) {
            widget.onValueChanged?.call(udf.code, value);
          },
        );

      case 'TEXT':
      case 'MLTEXT':
        if (udf.code == 'udf_note') {
          return UnifiedContainerTile(
            title: udf.displayName,
            iconPath: 'notes',
            interactionType: TileInteractionType.navigation,
            navigationTarget: NotesPageScreen(),
          );
        } else {
          return UnifiedContainerTile(
            title: udf.displayName,
            iconPath: 'text_format',
            interactionType: TileInteractionType.bottomSheet,
            bottomSheetContent: BottomSheetOptions(
              title: udf.displayName,
              isTextFieldNeeded: true,
              udfModel: udf,
              maxInputLength: udf.maxLength,
              regex: udf.regex,
              minInputLength: udf.minLength,
            ),
            onOptionSelected: (value) {
              widget.onValueChanged?.call(udf.code, value);
            },
          );
        }
      case 'DATE':
        return UnifiedContainerTile(
          title: udf.displayName,
          iconPath: 'date',
          interactionType: TileInteractionType.bottomSheet,
          fullSizeBottomSheet: true,
          bottomSheetContent: BottomSheetOptions(
            title: udf.displayName,
            udfModel: udf,
            isDateWidget: true,
          ),
          onOptionSelected: (value) {
            print("Here is the Vlaue -> $value");
            final parsedDate = DateFormat('dd MMM yyyy').parse(value);
            final formatted = DateFormat('yyyy-MM-dd').format(parsedDate);
            print(formatted);
            widget.onValueChanged?.call(udf.code, formatted);
          },
        );

      case 'EMAIL':
        return UnifiedContainerTile(
          title: udf.displayName,
          itemText: _emailController.text,
          iconPath: 'email',
          interactionType: TileInteractionType.bottomSheet,
          bottomSheetContent: BottomSheetOptions(
            title: udf.displayName,
            isTextFieldNeeded: true,
            udfModel: udf,
            customTextField: CustomTextField(
              hintText: udf.displayName,
              controller: _emailController,
              onChanged: (_) => setState(() {}),
              regex: r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
            ),
            onDone: () {
              setState(() {});
            },
          ),
          onOptionSelected: (value) {
            widget.onValueChanged?.call(udf.code, value);
          },
        );

      case 'URL':
        return UnifiedContainerTile(
          title: udf.displayName,
          itemText: _urlController.text,
          iconPath: 'link',
          interactionType: TileInteractionType.bottomSheet,
          bottomSheetContent: BottomSheetOptions(
            title: udf.displayName,
            isTextFieldNeeded: true,
            udfModel: udf,
            customTextField: CustomTextField(
              hintText: udf.displayName,
              controller: _urlController,
              onChanged: (_) => setState(() {}),
            ),
            onDone: () {
              setState(() {});
            },
          ),
          onOptionSelected: (value) {
            widget.onValueChanged?.call(udf.code, value);
          },
        );
      case 'CHGRP':
        return UnifiedContainerTile(
          title: udf.displayName,
          iconPath: 'ddms',
          interactionType: TileInteractionType.bottomSheet,
          bottomSheetContent: BottomSheetOptions(
            title: udf.displayName,
            isDonethere: true,
            udfModel: udf,
            isSearchEnabled: true,
            DDMS: true,
            options: udf.udfOptionsList,
          ),
          onMultipleOptionsSelected: (value) {
            widget.onValueChanged?.call(udf.code, value);
          },
        );

      case 'RDGRP':
        return UnifiedContainerTile(
          title: udf.displayName,
          iconPath: 'ddss',
          interactionType: TileInteractionType.bottomSheet,
          bottomSheetContent: BottomSheetOptions(
            isSearchEnabled: true,
            udfModel: udf,
            title: udf.displayName,
            isDonethere: false,
            options: udf.udfOptionsList,
          ),
          onOptionSelected: (value) {
            widget.onValueChanged?.call(udf.code, value);
          },
        );
      case 'COLPICK':
        return UnifiedContainerTile(
          title: 'Colors',
          iconPath: 'color',
          interactionType: TileInteractionType.bottomSheet,
          bottomSheetContent: BottomSheetOptions(isColorPalleteNeeded: true),
          onOptionSelected: (value) {
            widget.onValueChanged?.call(udf.code, parseColorFromString(value));
          },
        );

      ///here we have to add the priority bar
      case 'LABL':
        return UnifiedContainerTile(
          title: udf.displayName,
          iconPath: 'label',
          interactionType: TileInteractionType.bottomSheet,
          bottomSheetContent: BottomSheetOptions(
            title: udf.displayName,
            udfModel: udf,
            isPriority: true,
            options: udf.udfOptionsList,
          ),
          onOptionSelected: (value) {
            print("Label case -> $value");
            widget.onValueChanged?.call(udf.code, value);
          },
        );
      case 'DDSS':
        if (udf.code == 'disable_parallel') {
          return UnifiedContainerTile(
            title: udf.displayName,
            iconPath: 'ddss',
            interactionType: TileInteractionType.bottomSheet,

            bottomSheetContent: BottomSheetOptions(
              title: udf.displayName,
              isDonethere: false,
              udfModel: udf,
              isSearchEnabled: true,
              DDMS: false,
              options: [
                UdfOptionsModel(id: 1, name: 'on select project'),
                UdfOptionsModel(id: 2, name: 'on select resource'),
                UdfOptionsModel(id: 3, name: 'on select project or resource'),
              ],
            ),
            onOptionSelected: (value) {
              widget.onValueChanged?.call(udf.code, value);
            },
          );
        } else {
          return UnifiedContainerTile(
            title: udf.displayName,
            iconPath: 'ddss',
            interactionType: TileInteractionType.bottomSheet,
            bottomSheetContent: BottomSheetOptions(
              isSearchEnabled: true,
              udfModel: udf,
              title: udf.displayName,
              isDonethere: false,
              options: udf.udfOptionsList,
            ),
            onOptionSelected: (value) {
              widget.onValueChanged?.call(udf.code, value);
            },
          );
        }

      case 'DDMS':
        return UnifiedContainerTile(
          title: udf.displayName,
          iconPath: 'ddms',
          interactionType: TileInteractionType.bottomSheet,
          bottomSheetContent: BottomSheetOptions(
            title: udf.displayName,
            isDonethere: true,
            udfModel: udf,
            isSearchEnabled: true,
            DDMS: true,
            options: udf.udfOptionsList,
            // Pass currently selected options to show them as selected
            initialSelectedOptions:
                udf.udfOptionsList
                    .where((option) => option.isSelected ?? false)
                    .toList(),
          ),
          onMultipleOptionsSelected: (ids) {
            widget.onValueChanged?.call(udf.code, ids);
          },
        );
      case 'UMS':
        return UnifiedContainerTile(
          title: udf.displayName,
          iconPath: 'ddms',
          interactionType: TileInteractionType.bottomSheet,
          bottomSheetContent: BottomSheetOptions(
            title: udf.displayName,
            isDonethere: true,
            udfModel: udf,
            isSearchEnabled: true,
            DDMS: true,
            options: udf.udfOptionsList,
            // Pass currently selected options to show them as selected
            initialSelectedOptions:
                udf.udfOptionsList
                    .where((option) => option.isSelected ?? false)
                    .toList(),
          ),
          onMultipleOptionsSelected: (ids) {
            widget.onValueChanged?.call(udf.code, ids);
          },
        );
      case 'BLSTS':
        return UnifiedContainerTile(
          title: udf.displayName,
          iconPath: 'projects',
          interactionType: TileInteractionType.popupMenu,
          popMenuOptions: ['Inherit from Project', 'Billable', 'Non Billable'],
          onOptionSelected: (value) {
            widget.onValueChanged?.call(udf.code, value);
          },
        );

      case 'RTFRM':
        return UnifiedContainerTile(
          title: udf.displayName,
          iconPath: 'requirements',
          interactionType: TileInteractionType.bottomSheet,
          bottomSheetContent: BottomSheetOptions(
            isDonethere: false,
            options: [
              UdfOptionsModel(id: 1, name: 'Inherit from Project'),
              UdfOptionsModel(id: 2, name: 'Inherit from Resource'),
              UdfOptionsModel(id: 3, name: 'Inherit from Role'),
              UdfOptionsModel(id: 3, name: 'Custom'),
            ],
            udfModel: udf,
          ),
          onOptionSelected: (value) {
            print("Here i am -> $value");
            if (value == '3') {
              BottomSheetService.showCustomBottomSheet(
                context: context,
                startFullSize: false,
                child: BottomSheetOptions(
                  title: 'Custom',
                  unifiedcontainercontent: Column(
                    children: [CustomRateSheet()],
                  ),
                ),
              );
            }
            widget.onValueChanged?.call(udf.code, value);
          },
        );

      default:
        return UnifiedContainerTile(
          title: udf.displayName,
          interactionType: TileInteractionType.none,
        );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
