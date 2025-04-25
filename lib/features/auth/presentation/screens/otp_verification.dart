// import 'package:ers_linux/features/auth/presentation/screens/set_new_password.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import '../../../../shared/constants/app_constants.dart';
// import '../../../../shared/theme/app_colors.dart';
// import '../widgets/constants.dart';
// import '../widgets/custom_button.dart';
// import '../widgets/custom_textfield.dart';
// import '../widgets/login_background.dart';
// import 'login_screen.dart';

// class OtpVerification extends StatefulWidget {
//   static const routePath = '/otp_verification';
//   final String? email;

//   const OtpVerification({super.key, required this.email});

//   @override
//   State<OtpVerification> createState() => _OtpVerificationState();
// }

// class _OtpVerificationState extends State<OtpVerification> {
//   final _otpController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _otpController.addListener(() => setState(() {}));
//   }

//   @override
//   void dispose() {
//     _otpController.dispose();
//     super.dispose();
//   }

//   void _resendOtp() {
//     // Resend OTP logic
//   }

//   Future<void> _verifyOtp() async {
//     final otp = _otpController.text.trim();

//     try {
//       final res = await Supabase.instance.client.auth.verifyOTP(
//         email: widget.email,
//         token: otp,
//         type: OtpType.email,
//       );

//       if (res.user != null) {
//         ConstantWidget.showSnack(context, 'OTP Verified! Now log in.');
//         context.push(SetNewPassword.routePath);
//       } else {
//         ConstantWidget.showSnack(context, 'Invalid OTP');
//       }
//     } on AuthException catch (e) {
//       ConstantWidget.showSnack(context, 'Error: ${e.message}');
//     } catch (e) {
//       ConstantWidget.showSnack(context, 'An unexpected error occurred');
//     }
//   }

  // String obscureEmail(String email) {
  //   final parts = email.split('@');
  //   if (parts.length != 2) return email;
  //   return '●●●●●@${parts[1]}';
  // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       resizeToAvoidBottomInset: false,
//       body: Stack(
//         children: [
//           const LoginBackground(showLogo: true),
//           SingleChildScrollView(
//             padding: EdgeInsets.only(
//               left: 16.w,
//               right: 16.w,
//               top: AppConstants.height(50),
//               bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 IconButton(
//                   onPressed: () => context.pop(),
//                   icon: const Icon(Icons.arrow_back, color: AppColors.black),
//                 ),
//                 SizedBox(height: AppConstants.height(140)),
//                 Center(
//                   child: Text(
//                     "OTP Verification",
//                     style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w100),

//                   ),
//                 ),
//                 SizedBox(height: AppConstants.height(20)),
//                 Center(
//                   child: Text(
//                     "A 6-digit verification code was sent to ${obscureEmail(widget.email!)}.",
//                     textAlign: TextAlign.center,
//                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.lightText),

//                   ),
//                 ),

//                 SizedBox(height: AppConstants.height(20)),
//                 TextFieldCustom(
//                   hintText: "Enter your 6-digit OTP",
//                   obscureText: false,
//                   controller: _otpController,
//                   inputFormatters: [
//                     LengthLimitingTextInputFormatter(6),
//                     FilteringTextInputFormatter.digitsOnly,
//                   ],
//                   prefixIcon: Transform.scale(
//                     scale: 0.5,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 2,
//                         horizontal: 4,
//                       ),
//                       child: Image.asset("assets/icons/user.png", width: 24),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: AppConstants.height(40)),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Didn’t receive a code? ",
//                       style: Theme.of(context).textTheme.bodySmall,

//                     ),
//                     GestureDetector(
//                       onTap: _resendOtp,
//                       child: Text(
//                         "Resend again",
//                         style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.buttonActive),

//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: AppConstants.height(25)),
//                 ButtonCustom(
//                   onPressed:
//                       _otpController.text.length == 6 ? _verifyOtp : null,
//                   text: "Verify OTP",
//                   backgroundColor:
//                       _otpController.text.length == 6
//                           ? AppColors.buttonActive
//                           : AppColors.buttonDisable
//                 ),
//                 SizedBox(height: AppConstants.height(25)),
//                 Center(
//                   child: InkWell(
//                     onTap: () => context.go(LoginScreen.routePath),
//                     child: const Text("Login"),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:ers_linux/core/config/injection.dart';
import 'package:ers_linux/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ers_linux/features/auth/presentation/screens/login_screen.dart';
import 'package:ers_linux/features/auth/presentation/screens/set_new_password.dart';
import 'package:ers_linux/features/auth/presentation/widgets/constants.dart';
import 'package:ers_linux/features/auth/presentation/widgets/custom_button.dart';
import 'package:ers_linux/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:ers_linux/features/auth/presentation/widgets/login_background.dart';
import 'package:ers_linux/shared/constants/app_constants.dart';
import 'package:ers_linux/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OtpVerification extends StatelessWidget {
  static const routePath = '/otp_verification';
  final String email;

   OtpVerification({Key? key, required this.email}) : super(key: key);
  final TextEditingController _otpController = TextEditingController();

  String obscureEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    return '●●●●●@${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create: (context) => getIt<AuthenticationBloc>(
      ),
      child: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is OtpVerificationState) {
            switch (state.status) {
              case OtpVerificationStatus.success:
                context.push(SetNewPassword.routePath);
                break;
              case OtpVerificationStatus.failure:
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
                break;
              case OtpVerificationStatus.resent:
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('OTP resent successfully')),
                );
                break;
              default:
                break;
            }
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.white,
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              const LoginBackground(showLogo: true),
              SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: AppConstants.height(50),
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: AppConstants.height(140)),
                    Center(
                      child: Text(
                        "OTP Verification",
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w100),
                      ),
                    ),
                    SizedBox(height: AppConstants.height(20)),
                    Center(
                      child: Text(
                        "A 6-digit code was sent to ${obscureEmail(email)}.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.lightText,
                        ),
                      ),
                    ),
                    SizedBox(height: AppConstants.height(20)),
                    BlocBuilder<AuthenticationBloc, AuthenticationState>(
                      builder: (context, state) {
                        final otpState =
                            state is OtpVerificationState
                                ? state
                                : const OtpVerificationState();

                        return Column(
                          children: [
                            TextFieldCustom(
                              controller: _otpController,
                              hintText: "Enter your 6-digit OTP",
                              obscureText: false,
                              onChanged:
                                  (value) => context
                                      .read<AuthenticationBloc>()
                                      .add(OtpFieldChanged(value)),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(6),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              prefixIcon: Transform.scale(
                                scale: 0.5,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 4,
                                  ),
                                  child: Image.asset(
                                    "assets/icons/user.png",
                                    width: 24,
                                  ),
                                ),
                              ),
                              // errorText:
                              //     otpState.status == OtpVerificationStatus.failure
                              //         ? otpState.errorMessage
                              //         : null,
                            ),
                            SizedBox(height: AppConstants.height(40)),
                            if (otpState.status ==
                                OtpVerificationStatus.submitting)
                              const Center(child: CircularProgressIndicator())
                            else
                              ButtonCustom(
                                onPressed:
                                    otpState.otp.length == 6
                                        ? () => context
                                            .read<AuthenticationBloc>()
                                            .add(
                                              OtpSubmitted(otpState.otp, email),
                                            )
                                        : null,
                                text: "Verify OTP",
                                backgroundColor:
                                    otpState.otp.length == 6
                                        ? AppColors.buttonActive
                                        : AppColors.buttonDisable,
                              ),
                            SizedBox(height: AppConstants.height(25)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Didn’t receive a code? "),
                                GestureDetector(
                                  onTap:
                                      () => context
                                          .read<AuthenticationBloc>()
                                          .add(OtpResendPressed(email)),
                                  child: Text(
                                    "Resend again",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
                                      color: AppColors.buttonActive,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),

                    SizedBox(height: AppConstants.height(25)),
                    Center(
                      child: InkWell(
                        onTap: () => context.go(LoginScreen.routePath),
                        child: const Text("Login"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
