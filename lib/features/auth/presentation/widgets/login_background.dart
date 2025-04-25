import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/theme/app_colors.dart';
import 'constants.dart';

class LoginBackground extends StatelessWidget {
  final bool? showLogo;
  const LoginBackground({super.key, required this.showLogo});

  @override
  Widget build(BuildContext context) {

    return Container(
      color: AppColors.white,
      width: 1.sw,
      height: 1.sh,
      child: Stack(
        children: [
          Positioned(
            bottom: 50.h,
            left: 30.w,
            child: Text(
              "Enbraun Technologies Private Limited © 2025",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.lightText),
            ),
          ),

          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/images/login-footer.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          if (showLogo!)
            Positioned(
              top: 82.h,
              left: 100.w,
              child: SizedBox(
                width: 0.5.sw,
                height: 0.2.sh,
                child: Image.asset(
                  'assets/images/login-header.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

          Positioned(
            top: 103.h,
            left: -25.w,
            child: ConstantWidget.loginCircularBar(
              125.w,
              59.h,
              BorderRadius.circular(50.r),
              const Color.fromRGBO(235, 229, 247, 0.2),
            ),
          ),
          Positioned(
            top: 187.h,
            right: -25.w,
            child: ConstantWidget.loginCircularBar(
              110.w,
              58.h,
              BorderRadius.circular(50.r),
              const Color.fromRGBO(255, 253, 230, 0.5),
            ),
          ),
          Positioned(
            top: 348.h,
            left: -40.w,
            child: ConstantWidget.loginCircularBar(
              125.w,
              59.h,
              BorderRadius.circular(50.r),
              const Color.fromRGBO(242, 249, 255, 1),
            ),
          ),
          Positioned(
            top: 440.h,
            right: -30.w,
            child: ConstantWidget.loginCircularBar(
              90.w,
              69.h,
              BorderRadius.circular(50.r),
              const Color.fromRGBO(245, 240, 254, 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
