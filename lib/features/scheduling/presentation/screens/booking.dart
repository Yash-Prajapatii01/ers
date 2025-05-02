import 'package:ers_linux/features/scheduling/presentation/widgets/CustomTextfield.dart';
import 'package:ers_linux/features/scheduling/presentation/widgets/DateSelector.dart';
import 'package:ers_linux/features/scheduling/presentation/widgets/ExpandableTile.dart';
import 'package:ers_linux/features/scheduling/presentation/widgets/PopupmenuTile.dart';
import 'package:ers_linux/features/scheduling/presentation/widgets/containerTile.dart';
import 'package:ers_linux/shared/constants/text_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/resource_component.dart';

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
              ContainerTile(
                title: 'Requirement',
                itemText: 'ID 2 / Project b...',
                iconPath: 'assets/icons/scheduling/booking/requirements.svg',
                bottomSheetContent: BottomSheetOptions(
                  isSearchEnabled: true,
                  title: 'Requirements',
                  options: [
                    'ID 2 / Project b / 45 Hours',
                    'ID 3 / Project A / 30 Hours',
                    'ID 2 / Project X / 11 Hours',
                    'ID 5 / Project C / 20 Hours',
                  ],
                ),
              ),
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
              DateTimeSelector(),
              SizedBox(height: 24),
              ContainerTile(
                title: 'Email',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/email.svg',
                bottomSheetContent: BottomSheetOptions(
                  title: 'Email',
                  isTextFieldNeeded: true,
                  customTextField: CustomTextField(
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ),
              SizedBox(height: 24),
              ContainerTile(
                title: 'Performing Role',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/roles.svg',
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
              ContainerTile(
                title: 'Number',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/numbers.svg',
                bottomSheetContent: BottomSheetOptions(
                  title: 'Number',
                  isTextFieldNeeded: true,
                  customTextField: CustomTextField(
                    hintText: 'Number',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              SizedBox(height: 24),
              ContainerTile(
                title: 'Fractional Number',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/fraction.svg',
                bottomSheetContent: const BottomSheetOptions(
                  title: 'Fractional Number',
                  isTextFieldNeeded: true,
                  customTextField: CustomTextField(
                    hintText: 'Fractional Number',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              SizedBox(height: 24),
              ContainerTile(
                title: 'Simple Text',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/text_format.svg',
                bottomSheetContent: const BottomSheetOptions(
                  title: 'Simple Text',
                  isTextFieldNeeded: true,
                ),
              ),
              SizedBox(height: 24),
              ContainerTile(
                title: 'Date',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/date.svg',
                bottomSheetContent: const BottomSheetOptions(
                  title: 'Date',
                  isDateWidget: true,
                  isTimeWidget: false,
                ),
              ),
              SizedBox(height: 24),
              ExpandableTile(
                title: 'Progress',
                iconPath: 'assets/icons/scheduling/booking/slider.svg',
              ),
              SizedBox(height: 24),
              ContainerTile(
                title: 'Department',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/ddss.svg',
                bottomSheetContent: const BottomSheetOptions(
                  title: 'Department',
                  isDonethere: false,
                  options: [
                    'Research',
                    'UI UX',
                    'Software Development',
                    'User Testing',
                  ],
                ),
              ),
              SizedBox(height: 24),
              ContainerTile(
                title: 'Skill',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/ddms.svg',
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
              ContainerTile(
                title: 'Select an option',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/uss.svg',
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
              ContainerTile(
                title: 'Select an options',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/ums.svg',
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
              //todo start from here.
              ContainerTile(
                title: 'Priority',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/label.svg',
                bottomSheetContent: BottomSheetOptions(
                  // isColorPalleteNeeded: true,
                ),
              ),
              SizedBox(height: 24),
              ContainerTile(
                title: 'Color picker',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/color.svg',
                bottomSheetContent: BottomSheetOptions(
                  isColorPalleteNeeded: true,
                ),
              ),
              SizedBox(height: 24),
              ContainerTile(
                title: 'Time Zone',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/time_zone.svg',
                bottomSheetContent: const BottomSheetOptions(
                  options: [
                    '(UTC-11:00) Pacific/Midway (SST) ',
                    '(UTC-11:00) Pacific/Samoa (SST)  ',
                    '(UTC-11:00) US/Samoa (SST)',
                    '(UTC-10:00) Pacific/Honolulu (HST)',
                    '(UTC-09:00) US/Aleutian (HADT)',
                  ],
                  isSearchEnabled: true,
                ),
              ),
              SizedBox(height: 24),
              PopupmenuTile(
                title: 'Effort',
                // itemText: '20',
                iconPath: 'assets/icons/scheduling/booking/efforts.svg',
                isPinTextNeeded: true,
                options: [
                  '% Capacity',
                  'Hours',
                  'FTE'
                ],
                // itemText: '',
              ),
              SizedBox(height: 24),
              PopupmenuTile(
                title: 'Confirmed',
                // itemText: '',
                iconPath: 'assets/icons/scheduling/booking/confirmed.svg',
                isPinTextNeeded: false,
                options: [
                  'Yes',
                  'No'
                ],
              ),
              SizedBox(height: 24),
              PopupmenuTile(
                title: 'Travel Required',
                // itemText: '',
                iconPath: 'assets/icons/scheduling/booking/confirmed.svg',
                isPinTextNeeded: false,
                options: [
                  'Yes',
                  'No'
                ],
              ),
              SizedBox(height: 24),
              ContainerTile(
                title: 'Date & Time',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/date.svg',
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
              PopupmenuTile(
                title: 'Billing Status',
                // itemText: '',
                iconPath: 'assets/icons/scheduling/booking/projects.svg',
                isPinTextNeeded: false,
                options: [
                  'Inherit from Project',
                  'Billable',
                  'Non Billable'
                ],
              ),
              SizedBox(height: 24),
              ContainerTile(
                title: 'Billing Rate',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/requirements.svg',
                bottomSheetContent: const BottomSheetOptions(
                  isDonethere: true,
                  options: [
                    'Inherit from Project',
                    'Inherit from Resource',
                    'Inherit from Role',
                    'Custom'
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
              ContainerTile(
                title: 'Notes',
                nextpageto: true,
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/notes.svg',
                bottomSheetContent: const BottomSheetOptions(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
