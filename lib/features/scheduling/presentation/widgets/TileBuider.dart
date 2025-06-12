import 'package:ers_linux/features/scheduling/presentation/screens/NotesPageScreen.dart';
import 'package:ers_linux/features/scheduling/presentation/widgets/shared/CustomTextField.dart';
import 'package:ers_linux/features/scheduling/presentation/widgets/shared/resource_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/models/udfModel.dart';
import '../utils/showBottomSheet.dart';
import 'CustomContent/CustomContent.dart';
import 'UnifiedCalender/unifiedCalender.dart';
import 'UnifiedContainerTile/tile_interaction_type.dart';
import 'UnifiedContainerTile/unifiedContainerTile.dart';

class UdfTileBuilder extends StatefulWidget {
  final UdfModel udf;
  final void Function(String code, dynamic value)? onValueChanged;
  final bool isTaskField;


  const UdfTileBuilder({super.key, required this.udf,required this.onValueChanged, required this.isTaskField});

  @override
  State<UdfTileBuilder> createState() => _UdfTileBuilderState();
}

class _UdfTileBuilderState extends State<UdfTileBuilder> with AutomaticKeepAliveClientMixin<UdfTileBuilder> {

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

  @override
  Widget build(BuildContext context) {
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
            options: udf.udfOptionsList
          ),
          onOptionSelected: (v) {
            widget.onValueChanged?.call(udf.code, v);
          },
        );

      case 'RSRSS':
        print("In resource selector - ${widget.isTaskField}");
        return ResourceSelector(
          isTasksFieldNeeded: widget.isTaskField,
          onValueChanged: (value) {
            widget.onValueChanged?.call(udf.code, value);
          },
        );
      // case 'PRJSS':
      // case 'TSKSS':
      //   return const Offstage();

      case 'ROLEPS':
        return UnifiedContainerTile(
          iconPath: 'roles',
          title: udf.displayName,
          interactionType: TileInteractionType.bottomSheet,
          bottomSheetContent:  BottomSheetOptions(
            isSearchEnabled: true,
            options: udf.udfOptionsList,
          ),
          onOptionSelected: (value){
            widget.onValueChanged?.call(
              udf.code,
              value,
            );
          },
        );

      case 'DATIM':
        if (udf.code == 'start_time') {
          return UnifiedCalendar(
            initialDate: DateTime.now(),
            isRangePicker: true,
            showTime: true,
            initialFromTime: const TimeOfDay(hour: 9, minute: 0),
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
                    unifiedcontainercontent: Column(children: [CustomTab()]),
                  ),
                );
              }
            },
            onDateSelected: (value) {
              widget.onValueChanged?.call(udf.code, value);
            }
          );
        }
        if (udf.code == 'end_time') {
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
            final boolValue = value == 'Yes' ? 'true' : 'false';
            widget.onValueChanged?.call(udf.code, boolValue);
          },
        );

      case 'INT':
        if (udf.code == 'progress') {
          return UnifiedContainerTile(
            title: udf.displayName,
            iconPath: 'slider',
            interactionType: TileInteractionType.expandable,
            onSliderChanged: (value){
              widget.onValueChanged?.call(
                udf.code,
                value.toInt(),
              );
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
              customTextField: CustomTextField(
                hintText: udf.displayName,
                controller: _numberController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => setState(() {}),
              ),
              onDone: () => setState(() {}),
            ),
            onOptionSelected: (value){
              widget.onValueChanged?.call(
                udf.code,
                value,
              );
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
            isTextFieldNeeded: true,
            customTextField: CustomTextField(
              hintText: udf.displayName,
              controller: _numberController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
              ],
              onChanged: (_) => setState(() {}),
            ),
            onDone: () => setState(() {}),
          ),
          onOptionSelected: (value){
            widget.onValueChanged?.call(
              udf.code,
              value,
            );
          },
        );

      // case 'DDSS':
      //   return UnifiedContainerTile(
      //     title: udf.displayName,
      //     iconPath: 'ddss',
      //     interactionType: TileInteractionType.bottomSheet,
      //     bottomSheetContent: BottomSheetOptions(
      //       title: udf.displayName,
      //       isDonethere: false,
      //       isSearchEnabled: true,
      //       options: udf.udfOptionsList
      //   ),onOptionSelected: (value){
      //     widget.onValueChanged?.call(
      //       udf.code,
      //       value,
      //     );
      //   },);

      case 'USS':
        return UnifiedContainerTile(
          title: udf.displayName,
          iconPath: 'ddss',
          interactionType: TileInteractionType.bottomSheet,
          bottomSheetContent: BottomSheetOptions(
              title: udf.displayName,
              isDonethere: false,
              isSearchEnabled: true,
              options: udf.udfOptionsList
          ),onOptionSelected: (value){
          widget.onValueChanged?.call(
            udf.code,
            value,
          );
        },);

      case 'TAGS':
        return UnifiedContainerTile(
          title: udf.displayName,
          iconPath: 'tags',
          interactionType: TileInteractionType.bottomSheet,
          bottomSheetContent: BottomSheetOptions(
            title: udf.displayName,
            options: udf.udfOptionsList
          ),
          onOptionSelected: (value){
            widget.onValueChanged?.call(
              udf.code,
              value,
            );
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
              regex: udf.regex,
              maxInputLength: udf.maxLength,
              minInputLength: udf.minLength,
            ),
            onOptionSelected: (value){
              widget.onValueChanged?.call(
                udf.code,
                value,
              );
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
            isDateWidget: true,
          ),
          onOptionSelected: (value){
            widget.onValueChanged?.call(
              udf.code,
              value,
            );
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
            customTextField: CustomTextField(
              hintText: udf.displayName,
              controller: _emailController,
              onChanged: (_) => setState(() {}),
            ),
            onDone: () {
              setState(() {});
            },
          ),
          onOptionSelected: (value){
            widget.onValueChanged?.call(
              udf.code,
              value,
            );
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
            customTextField: CustomTextField(
              hintText: udf.displayName,
              controller: _urlController,
              onChanged: (_) => setState(() {}),
            ),
            onDone: () {
              setState(() {});
            },
          ),
          onOptionSelected: (value){
            widget.onValueChanged?.call(
              udf.code,
              value,
            );
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
            isSearchEnabled: true,
            DDMS: true,
            /*
            "options": [
                        {
                            "editability": 63,
                            "is_selected": false,
                            "name": "name",
                            "id": 406
                        },
                        {
                            "editability": 63,
                            "is_selected": false,
                            "name": "name1",
                            "id": 407
                        }
                    ],
             */
            options: udf.udfOptionsList,
          ),
          onOptionSelected: (value){
            widget.onValueChanged?.call(
              udf.code,
              value,
            );
          },
        );

      case 'RDGRP':
        return UnifiedContainerTile(
          title: udf.displayName,
          iconPath: 'ddss',
          interactionType: TileInteractionType.bottomSheet,
          bottomSheetContent: BottomSheetOptions(
            isSearchEnabled: true,
            title: udf.displayName,
            isDonethere: false,
            options: udf.udfOptionsList
                // (udf.options)
                //     .map((e) => e['name']?.toString())
                //     .where((name) => name != null)
                //     .cast<String>()
                //     .toList(),
          ),
          onOptionSelected: (value){
            widget.onValueChanged?.call(
              udf.code,
              value,
            );
          },
        );
      case 'COLPICK':
        return UnifiedContainerTile(
          title: 'Colors',
          iconPath: 'color',
          interactionType: TileInteractionType.bottomSheet,
          bottomSheetContent: BottomSheetOptions(isColorPalleteNeeded: true),
          onOptionSelected: (value){
            widget.onValueChanged?.call(
              udf.code,
              value,
            );
          },
        );

      ///here we have to add the priority bar
      case 'LABL':
        // final List<Map<String, dynamic>> parsedOptions =
        //     udf.options.map<Map<String, dynamic>>((e) {
        //       final String label = e['name']?.toString() ?? '';
        //
        //       final String? colorStr = e['color'];
        //       Color color = Colors.transparent;
        //
        //       if (colorStr != null && colorStr.isNotEmpty) {
        //         final String hex = colorStr
        //             .split(';')
        //             .first
        //             .replaceAll('#', '');
        //         if (hex.length == 6) {
        //           try {
        //             color = Color(int.parse('0xFF$hex'));
        //           } catch (_) {
        //             color = Colors.transparent;
        //           }
        //         }
        //       }
        //
        //       return {'label': label, 'color': color};
        //     }).toList();
        // print(parsedOptions);
        return UnifiedContainerTile(
          title: udf.displayName,
          iconPath: 'label',
          interactionType: TileInteractionType.bottomSheet,
          bottomSheetContent: BottomSheetOptions(
            title: udf.displayName,
            isPriority: true,
            options: udf.udfOptionsList,

          ),
          onOptionSelected: (value){
            widget.onValueChanged?.call(
              udf.code,
              value,
            );
          },
        );
      case 'DDSS':
        return UnifiedContainerTile(
          title: udf.displayName,
          iconPath: 'ddss',
          interactionType: TileInteractionType.bottomSheet,
          bottomSheetContent: BottomSheetOptions(
            isSearchEnabled: true,
            title: udf.displayName,
            isDonethere: false,
            options:
                // (udf.options)
                //     .map((e) => e['name']?.toString())
                //     .where((name) => name != null)
                //     .cast<String>()
                //     .toList(),
            udf.udfOptionsList
          ),
          onOptionSelected: (value){
            widget.onValueChanged?.call(
              udf.code,
              value,
            );
          },
        );
      case 'DDMS':
        return UnifiedContainerTile(
        title: udf.displayName,
        iconPath: 'ddms',
        interactionType: TileInteractionType.bottomSheet,
        bottomSheetContent: BottomSheetOptions(
          title: udf.displayName,
          isDonethere: true,
          isSearchEnabled: true,
          DDMS: true,
          options: udf.udfOptionsList,
          // Pass currently selected options to show them as selected
          initialSelectedOptions: udf.udfOptionsList
              .where((option) => option.isSelected ?? false)
              .toList(),
        ),
        onMultipleOptionsSelected: (ids) {
          widget.onValueChanged?.call(
            udf.code,
            ids,
          );
        },
      );
        // return UnifiedContainerTile(
        //   title: udf.displayName,
        //   iconPath: 'ddms',
        //   interactionType: TileInteractionType.bottomSheet,
        //   bottomSheetContent: BottomSheetOptions(
        //     title: udf.displayName,
        //     isDonethere: true,
        //     isSearchEnabled: true,
        //     DDMS: true,
        //     /*
        //     "options": [
        //                 {
        //                     "editability": 63,
        //                     "is_selected": false,
        //                     "name": "name",
        //                     "id": 406
        //                 },
        //                 {
        //                     "editability": 63,
        //                     "is_selected": false,
        //                     "name": "name1",
        //                     "id": 407
        //                 }
        //             ],
        //      */
        //     options: // we are using the names of the options as the options
        //         // (udf.options)
        //         //     .map((e) => e['name']?.toString())
        //         //     .where((name) => name != null)
        //         //     .cast<String>()
        //         //     .toList(),
        //     udf.udfOptionsList
        //   ),
        //   onMultipleOptionsSelected: (id){
        //     widget.onValueChanged?.call(
        //       udf.code,
        //       id,
        //     );
        //   },
        // );
      case 'UMS':
        return  UnifiedContainerTile(
          title: udf.displayName,
          iconPath: 'ddms',
          interactionType: TileInteractionType.bottomSheet,
          bottomSheetContent: BottomSheetOptions(
            title: udf.displayName,
            isDonethere: true,
            isSearchEnabled: true,
            DDMS: true,
            options: udf.udfOptionsList,
            // Pass currently selected options to show them as selected
            initialSelectedOptions: udf.udfOptionsList
                .where((option) => option.isSelected ?? false)
                .toList(),
          ),
          onMultipleOptionsSelected: (ids) {
            widget.onValueChanged?.call(
              udf.code,
              ids,
            );
          },
        );
      case 'BLSTS':
        return UnifiedContainerTile(
          title: 'Billing Status',
          iconPath: 'projects',
          interactionType: TileInteractionType.popupMenu,
          popMenuOptions: ['Inherit from Project', 'Billable', 'Non Billable'],
          onOptionSelected: (value){
            widget.onValueChanged?.call(
              udf.code,
              value,
            );
          },
        );

      case 'RTFRM':
        return UnifiedContainerTile(
          title: 'Billing Rate',
          iconPath: 'requirements',
          interactionType: TileInteractionType.bottomSheet,
          bottomSheetContent:  BottomSheetOptions(
            isDonethere: true,
            options: udf.udfOptionsList
          ),
          onOptionSelected: (value){
            widget.onValueChanged?.call(
              udf.code,
              value,
            );
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
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
