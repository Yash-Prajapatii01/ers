
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../shared/constants/app_constants.dart';
import '../../../../shared/theme/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/login_background.dart';
import 'login_screen.dart';
import 'otp_verification.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static const routePath = '/forgot_password';

  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = TextEditingController();

    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          final forgotPassState =
              state is ForgotPasswordState
                  ? state
                  : const ForgotPasswordState();

          return Scaffold(
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
                          "Forgot Password",
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w100),
                        ),
                      ),
                      SizedBox(height: AppConstants.height(50)),
                      TextFieldCustom(
                        hintText: "Login ID",
                        obscureText: false,
                        controller: loginController,
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
                        onChanged: (value) {
                          context.read<AuthenticationBloc>().add(
                            ForgotPasswordEmailChanged(value),
                          );
                        },
                      ),
                      SizedBox(height: AppConstants.height(10)),
                      Row(
                        children: [
                          Text(
                            "Note:",
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Login ID might not be same as email address",
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.lightText),
                            ),
                          ),
                        ],
                      ),

                      if (forgotPassState.errorMessage != null) ...[
                        SizedBox(height: AppConstants.height(20)),
                        Text(
                          forgotPassState.errorMessage!,
                          style: const TextStyle(color: AppColors.error),
                        ),
                      ],
                      SizedBox(height: AppConstants.height(40)),
                      ButtonCustom(
                        onPressed:
                            forgotPassState.isEmailFilled
                                ? () => context.read<AuthenticationBloc>().add(
                                  GetOtpPressed(loginController.text.trim()),
                                )
                                : null,

                        text: "Get OTP",
                        backgroundColor:
                            forgotPassState.isEmailFilled
                                ? AppColors.buttonActive
                                : AppColors.buttonDisable,
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
          );
        },
        listener: (context, state) {
          if (state is OtpSendSuccess) {
            context.push(OtpVerification.routePath, extra: state.email);
          }
        },
      );
  }
}
