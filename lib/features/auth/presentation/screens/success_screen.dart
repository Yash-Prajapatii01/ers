import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../shared/constants/app_constants.dart';
import '../../../../shared/theme/app_colors.dart';
import '../widgets/login_background.dart';
import 'login_screen.dart';

class SuccessScreen extends StatelessWidget {
  static const routePath = '/success_screen';

  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: FloatingActionButton(
          onPressed: () {
            context.go(LoginScreen.routePath);
          },
          tooltip: 'Login Page',
          backgroundColor: AppColors.buttonActive,
          shape: const CircleBorder(),
          child: const Icon(Icons.arrow_forward, color: AppColors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: Stack(
        children: [
          LoginBackground(showLogo: false),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                Lottie.asset(
                  'assets/lottie/success.lottie',
                  repeat: false,
                  height: AppConstants.height(150),
                  width: AppConstants.width(150),
                ),

                SizedBox(height: AppConstants.height(20)),
                Text(
                  "Success!",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w100),
                ),
                SizedBox(height: AppConstants.height(20)),
                Text(
                  "Your password has been updated successfully. Use your new password to Log in securely.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Spacer(),
                SizedBox(),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
