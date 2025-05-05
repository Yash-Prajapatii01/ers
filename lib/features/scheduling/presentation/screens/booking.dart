import 'package:ers_linux/features/scheduling/presentation/screens/NotesPageScreen.dart';
import 'package:ers_linux/features/scheduling/presentation/widgets/unifiedCalender.dart';
import 'package:ers_linux/shared/constants/text_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/resource_component.dart';
import '../widgets/unifiedCalenderTemp.dart';
import '../widgets/unifiedContainerTile.dart';

class BookingForm extends StatelessWidget {
  static const routePath = '/booking_form';

  const BookingForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(245, 250, 255, 1),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left),
        ),
        title: Text(
          'Booking',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(78, 78, 78, 1),
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(16, 24, 40, 0.05),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(28, 121, 212, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 8.h,
                  ),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: TextSizes().bodyMedium,
                    fontWeight: FontWeight.w600,
                    // fontFamily: 'Inter'
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Details',
                    style: TextStyle(
                      fontSize: TextSizes().bodyMedium,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(51, 51, 51, 1),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              UnifiedContainerTile(
                title: 'Requirement',
                iconPath: 'assets/icons/scheduling/booking/requirements.svg',
                interactionType: TileInteractionType.bottomSheet,
                // isSearchEnabled: true,
                bottomSheetContent: BottomSheetOptions(
                  title: 'Requirements',
                  isSearchEnabled: true,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  options: [
                    'ID 2 / Project b / 45 Hours',
                    'ID 3 / Project A / 30 Hours',
                    'ID 1 / Project X / 11 Hours',
                    'ID 5 / Project C / 20 Hours',
                  ],
                ),
              ),

              // ContainerTile(
              //   title: 'Requirement',
              //   itemText: 'ID 2 / Project b...',
              //   iconPath: 'assets/icons/scheduling/booking/requirements.svg',
              //   bottomSheetContent: BottomSheetOptions(
              //     isSearchEnabled: true,
              //     title: 'Requirements',
              //     options: [
              //       'ID 2 / Project b / 45 Hours',
              //       'ID 3 / Project A / 30 Hours',
              //       'ID 2 / Project X / 11 Hours',
              //       'ID 5 / Project C / 20 Hours',
              //     ],
              //   ),
              // ),
              SizedBox(height: 24),
              ResourceSelector(
                avatarUrls: [
                  'https://avatar.iran.liara.run/public/19',
                  'https://avatar.iran.liara.run/public/20',
                  'https://avatar.iran.liara.run/public/29',
                  'https://avatar.iran.liara.run/public/31',
                ],
              ),
              SizedBox(height: 24),
              UnifiedCalendar(
                initialDate: DateTime.now(),
                isRangePicker: true,
                showTime: true,
                initialFromTime: TimeOfDay(hour: 9, minute: 00),
                repeatOptions: ['Daily', 'Weekly', 'Monthly', 'Yearly', 'None'],
              ),
              SizedBox(height: 24),
              UnifiedContainerTile(
                title: 'Email',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/email.svg',
                interactionType: TileInteractionType.bottomSheet,
                bottomSheetContent: BottomSheetOptions(
                  title: 'Email',
                  isTextFieldNeeded: true,
                  customTextField: CustomTextField(hintText: 'Email'),
                ),
              ),
              SizedBox(height: 24),
              UnifiedContainerTile(
                title: 'Performing Role',
                iconPath: 'assets/icons/scheduling/booking/roles.svg',
                interactionType: TileInteractionType.bottomSheet,
                bottomSheetContent: const BottomSheetOptions(
                  isSearchEnabled: true,
                  options: [
                    'Software Engineer',
                    'IT Engineer',
                    'Quality Assurance Engineer',
                    'Software Development Engineer',
                  ],
                ),
              ),
              SizedBox(height: 24),
              UnifiedContainerTile(
                title: 'Number',
                iconPath: 'assets/icons/scheduling/booking/numbers.svg',
                interactionType: TileInteractionType.bottomSheet,
                bottomSheetContent: BottomSheetOptions(
                  title: 'Number',
                  isTextFieldNeeded: true,
                  customTextField: CustomTextField(
                    hintText: 'Number',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ),
              SizedBox(height: 24),
              UnifiedContainerTile(
                title: 'Fractional Number',
                iconPath: 'assets/icons/scheduling/booking/fraction.svg',
                interactionType: TileInteractionType.bottomSheet,
                bottomSheetContent: BottomSheetOptions(
                  title: 'Fractional Number',
                  isTextFieldNeeded: true,
                  customTextField: CustomTextField(
                    hintText: 'Fractional Number',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              UnifiedContainerTile(
                title: 'Simple Text',
                iconPath: 'assets/icons/scheduling/booking/text_format.svg',
                interactionType: TileInteractionType.bottomSheet,
                bottomSheetContent: const BottomSheetOptions(
                  title: 'Simple Text',
                  isTextFieldNeeded: true,
                ),
              ),
              SizedBox(height: 24),
              UnifiedContainerTile(
                title: 'Date',
                iconPath: 'assets/icons/scheduling/booking/date.svg',
                interactionType: TileInteractionType.bottomSheet,
                bottomSheetContent: const BottomSheetOptions(
                  title: 'Date',
                  isDateWidget: true,
                ),
              ),
              SizedBox(height: 24),
              UnifiedContainerTile(
                title: 'Progress',
                iconPath: 'assets/icons/scheduling/booking/slider.svg',
                interactionType: TileInteractionType.expandable,
              ),
              SizedBox(height: 24),
              UnifiedContainerTile(
                title: 'Department',
                iconPath: 'assets/icons/scheduling/booking/ddss.svg',
                interactionType: TileInteractionType.bottomSheet,
                bottomSheetContent: const BottomSheetOptions(
                  title: 'Department',
                  isDonethere: false,
                  isSearchEnabled: true,
                  options: [
                    'Research',
                    'UI UX',
                    'Software Development',
                    'User Testing',
                  ],
                ),
              ),
              SizedBox(height: 24),
              UnifiedContainerTile(
                title: 'Skill',
                iconPath: 'assets/icons/scheduling/booking/ddms.svg',
                interactionType: TileInteractionType.bottomSheet,
                bottomSheetContent: const BottomSheetOptions(
                  DDMS: true,
                  title: 'Select the Skills',
                  isSearchEnabled: true,
                  options: [
                    'Research',
                    'UI UX',
                    'Software Development',
                    'User Testing',
                  ],
                ),
              ),
              SizedBox(height: 24),
              UnifiedContainerTile(
                title: 'Select an option',
                iconPath: 'assets/icons/scheduling/booking/uss.svg',
                interactionType: TileInteractionType.bottomSheet,
                bottomSheetContent: const BottomSheetOptions(
                  isSearchEnabled: true,
                  title: 'Select an option',
                  isDonethere: false,
                  options: [
                    'Alex Martin',
                    'Albert Murphy',
                    'John Will',
                    'Harsh Patel',
                  ],
                ),
              ),
              SizedBox(height: 24),
              UnifiedContainerTile(
                title: 'Select an options',
                iconPath: 'assets/icons/scheduling/booking/ums.svg',
                interactionType: TileInteractionType.bottomSheet,
                bottomSheetContent: const BottomSheetOptions(
                  title: 'Select Options',
                  isDonethere: true,
                  isSearchEnabled: true,
                  DDMS: true,
                  options: [
                    'Alex Martin',
                    'Albert Murphy',
                    'John Will',
                    'Harsh Patel',
                  ],
                ),
              ),
              SizedBox(height: 24),
              // //todo start from here.
              UnifiedContainerTile(
                title: 'Priority',
                iconPath: 'assets/icons/scheduling/booking/label.svg',
                interactionType: TileInteractionType.bottomSheet,
                bottomSheetContent: BottomSheetOptions(
                  isColorPalleteNeeded: true,
                ),
              ),
              SizedBox(height: 24),
              UnifiedContainerTile(
                title: 'Colors',
                iconPath: 'assets/icons/scheduling/booking/color.svg',
                interactionType: TileInteractionType.bottomSheet,
                bottomSheetContent: BottomSheetOptions(
                  isColorPalleteNeeded: true,
                ),
              ),
              SizedBox(height: 24),
              UnifiedContainerTile(
                title: 'Time Zone',
                iconPath: 'assets/icons/scheduling/booking/time_zone.svg',
                interactionType: TileInteractionType.bottomSheet,
                bottomSheetContent: const BottomSheetOptions(
                  isSearchEnabled: true,
                  options: [
                    '(UTC-11:00) Pacific/Midway (SST) ',
                    '(UTC-11:00) Pacific/Samoa (SST)  ',
                    '(UTC-11:00) US/Samoa (SST)',
                    '(UTC-10:00) Pacific/Honolulu (HST)',
                    '(UTC-09:00) US/Aleutian (HADT)',
                  ],
                ),
              ),
              SizedBox(height: 24),
              UnifiedContainerTile(
                title: 'Effort',
                iconPath: 'assets/icons/scheduling/booking/efforts.svg',
                interactionType: TileInteractionType.popupMenu,
                isPinTextNeeded: true,
                options: ['% Capacity', 'Hours', 'FTE'],
              ),
              // PopupmenuTile(
              //   title: 'Effort',
              //   // itemText: '20',
              //   iconPath: 'assets/icons/scheduling/booking/efforts.svg',
              //   isPinTextNeeded: true,
              //   options: ['% Capacity', 'Hours', 'FTE'],
              //   // itemText: '',
              // ),
              SizedBox(height: 24),
              UnifiedContainerTile(
                title: 'Confirmed',
                iconPath: 'assets/icons/scheduling/booking/confirmed.svg',
                interactionType: TileInteractionType.popupMenu,
                options: [
                  'Yes','No'
                ],
              ),

              // PopupmenuTile(
              //   title: 'Confirmed',
              //   // itemText: '',
              //   iconPath: 'assets/icons/scheduling/booking/confirmed.svg',
              //   isPinTextNeeded: false,
              //   options: ['Yes', 'No'],
              // ),
              SizedBox(height: 24),
              UnifiedContainerTile(
                title: 'Travel Required',
                iconPath: 'assets/icons/scheduling/booking/confirmed.svg',
                interactionType: TileInteractionType.popupMenu,
                options: [
                  'Yes','No'
                ],
              ),
              // PopupmenuTile(
              //   title: 'Travel Required',
              //   // itemText: '',
              //   iconPath: 'assets/icons/scheduling/booking/confirmed.svg',
              //   isPinTextNeeded: false,
              //   options: ['Yes', 'No'],
              // ),
              SizedBox(height: 24),
              UnifiedContainerTile(
                title: 'Date & Time',
                iconPath: 'assets/icons/scheduling/booking/date.svg',
                interactionType: TileInteractionType.bottomSheet,
                bottomSheetContent: const BottomSheetOptions(
                  title: 'Date & Time',
                  isDateWidget: true,
                  isTimeWidget: true,
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    'Financials',
                    style: TextStyle(
                      fontSize: TextSizes().bodyMedium,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(51, 51, 51, 1),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              UnifiedContainerTile(
                title: 'Billing Status',
                iconPath: 'assets/icons/scheduling/booking/projects.svg',
                interactionType: TileInteractionType.popupMenu,
                options: ['Inherit from Project', 'Billable', 'Non Billable'],
              ),
              SizedBox(height: 24),
              UnifiedContainerTile(
                title: 'Billing Rate',
                iconPath: 'assets/icons/scheduling/booking/requirements.svg',
                interactionType: TileInteractionType.bottomSheet,
                bottomSheetContent: const BottomSheetOptions(
                  isDonethere: true,
                  options: [
                    'Inherit from Project',
                    'Inherit from Resource',
                    'Inherit from Role',
                    'Custom',
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    'Notes',
                    style: TextStyle(
                      fontSize: TextSizes().bodyMedium,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(51, 51, 51, 1),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              UnifiedContainerTile(
                title: 'Notes',
                iconPath: 'assets/icons/scheduling/booking/notes.svg',
                interactionType: TileInteractionType.navigation,
                navigationTarget: NotesPageScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
