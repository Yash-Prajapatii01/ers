
import 'package:ers_linux/features/auth/presentation/screens/otp_verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/constants/app_constants.dart';
import '../../../../shared/theme/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/login_background.dart';
import 'login_screen.dart';

class ForgotLoginID extends StatelessWidget {
  static const routePath = '/forgot_login_id';

  const ForgotLoginID({super.key});

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}\$');
    return emailRegex.hasMatch(email);
  }

  void _getOtp(BuildContext context, String login) {
    if (isValidEmail(login)) {
      context.push(OtpVerification.routePath, extra: login);
    } else {
      ConstantWidget.showSnack(context, "Enter a valid email");
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    return BlocProvider(
      create: (_) => AuthenticationBloc(
        initialState: ForgotLoginIdState()
      ),
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          final formState = state as ForgotLoginIdState;

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
                        icon: const Icon(Icons.arrow_back, color: AppColors.black),
                      ),
                      SizedBox(height: AppConstants.height(140)),
                      Center(
                        child: Text(
                          "Forgot Login ID",
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w100),


                        ),
                      ),
                      SizedBox(height: AppConstants.height(50)),
                      TextFieldCustom(
                        hintText: "Email",
                        obscureText: false,
                        controller: emailController,
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
                        onChanged:
                            (value) => context.read<AuthenticationBloc>().add(
                          ForgotLoginIdFieldChanged(value),
                            ),
                      ),

                      SizedBox(height: AppConstants.height(40)),
                      ButtonCustom(
                        onPressed:
                            formState.email.isNotEmpty
                                ? () => _getOtp(context, formState.email)
                                : null,
                        text: "Submit",
                        backgroundColor:
                            formState.email.isNotEmpty
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
      ),
    );
  }
}
