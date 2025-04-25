import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 350,
                height: 310,
                child: Image.asset(
                  'assets/images/dashboard/schedule_nodata.png',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 17),
              Text(
                'No Data to Display',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(51, 51, 51, 1),
                ),
              ),
            ],
          ),
      ),
    );

  }
}
