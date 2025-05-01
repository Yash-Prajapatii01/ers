import 'package:ers_linux/features/scheduling/presentation/widgets/DateSelector.dart';
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
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          'Booking',
          style: TextStyle(
            fontSize: TextSizes().headingMedium,
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
              ),
              SizedBox(height: 24),
              ContainerTile(
                title: 'Fractional Number',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/fraction.svg',
                bottomSheetContent: const BottomSheetOptions(),
              ),
              SizedBox(height: 24),
              ContainerTile(
                title: 'Simple Text',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/text_format.svg',
                bottomSheetContent: const BottomSheetOptions(),
              ),
              SizedBox(height: 24),
              ContainerTile(
                title: 'Date',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/date.svg',
                bottomSheetContent: const BottomSheetOptions(),
              ),
              SizedBox(height: 24),
              ContainerTile(
                title: 'Progress',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/slider.svg',
                bottomSheetContent: const BottomSheetOptions(),
              ),
              SizedBox(height: 24),
              ContainerTile(
                title: 'Department',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/ddss.svg',
                bottomSheetContent: const BottomSheetOptions(),
              ),
              SizedBox(height: 24),
              ContainerTile(
                title: 'Skill',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/ddms.svg',
                bottomSheetContent: const BottomSheetOptions(),
              ),
              SizedBox(height: 24),
              ContainerTile(
                title: 'Select an option',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/uss.svg',
                bottomSheetContent: const BottomSheetOptions(),
              ),
              SizedBox(height: 24),
              ContainerTile(
                title: 'Select an options',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/ums.svg',
                bottomSheetContent: const BottomSheetOptions(),
              ),
              SizedBox(height: 24),
              ContainerTile(
                title: 'Priority',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/label.svg',
                bottomSheetContent: const BottomSheetOptions(),
              ),
              SizedBox(height: 24),
              ContainerTile(
                title: 'Color picker',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/color.svg',
                bottomSheetContent: const BottomSheetOptions(),
              ),
              SizedBox(height: 24),
              ContainerTile(
                title: 'Time Zone',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/time_zone.svg',
                bottomSheetContent: const BottomSheetOptions(),
              ),
              SizedBox(height: 24),
              ContainerTile(
                title: 'Effort',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/efforts.svg',
                bottomSheetContent: const BottomSheetOptions(),
              ),
              SizedBox(height: 24),
              ContainerTile(
                title: 'Confirmed',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/confirmed.svg',
                bottomSheetContent: const BottomSheetOptions(),
              ),
              SizedBox(height: 24),
              ContainerTile(
                title: 'Travel Required',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/confirmed.svg',
                bottomSheetContent: const BottomSheetOptions(),
              ),
              SizedBox(height: 24),
              ContainerTile(
                title: 'Date & Time',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/date.svg',
                bottomSheetContent: const BottomSheetOptions(),
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
              ContainerTile(
                title: 'Billing Status',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/projects.svg',
                bottomSheetContent: const BottomSheetOptions(),
              ),
              SizedBox(height: 24),
              ContainerTile(
                title: 'Billing Rate',
                itemText: '',
                iconPath: 'assets/icons/scheduling/booking/requirements.svg',
                bottomSheetContent: const BottomSheetOptions(),
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
