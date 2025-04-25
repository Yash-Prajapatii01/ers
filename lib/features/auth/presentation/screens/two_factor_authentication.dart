
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../shared/constants/app_constants.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../shell/presentation/screens/dashboard_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/login_background.dart';
import '../widgets/otp_input_field.dart';

class VerificationScreen extends StatefulWidget {
  static const routePath = '/verification_screen';

  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _otpCtrl = TextEditingController();
  String? challengeId;
  String? factorId;
  bool rememberDevice = false;

  @override
  void initState() {
    super.initState();
    _initMFA();
  }

  Future<void> _initMFA() async {
    final factors = await Supabase.instance.client.auth.mfa.listFactors();
    if (factors.all.isEmpty) return;

    factorId = factors.all.first.id;

    final challenge = await Supabase.instance.client.auth.mfa.challenge(
      factorId: factorId!,
    );

    setState(() {
      challengeId = challenge.id;
    });
  }

  Future<void> _verifyOTP() async {
    try {
      await Supabase.instance.client.auth.mfa.verify(
        factorId: factorId!,
        challengeId: challengeId!,
        code: _otpCtrl.text.trim(),
      );

      context.go(DashboardScreen.routePath);
    } catch (e) {
      debugPrint('Verification Error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Verification Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const LoginBackground(showLogo: true),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Text(
                  "Two factor Authentication",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w100,
                  ),
                ),
                SizedBox(height: AppConstants.height(30)),
                Text(
                  "To continue, please enter the 6-digit verification code from your authenticator app.",
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.lightText),
                ),
                SizedBox(height: AppConstants.height(30)),
                OTPInputField(controller: _otpCtrl),
                SizedBox(height: AppConstants.height(40)),
                ButtonCustom(
                  onPressed: _verifyOTP,
                  text: "Continue",
                  backgroundColor: AppColors.buttonActive,
                  textColor: AppColors.white,
                ),
                SizedBox(height: AppConstants.height(80)),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
