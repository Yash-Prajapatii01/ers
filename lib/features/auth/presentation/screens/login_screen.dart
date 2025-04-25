import 'package:ers_linux/features/auth/presentation/screens/single_sign_on.dart';
import 'package:ers_linux/features/auth/presentation/screens/two_factor_authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/constants/app_constants.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../shell/presentation/screens/dashboard_screen.dart';
import '../../data/repositories/shake_animation.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_button.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/login_background.dart';
import 'forgot_login_id.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatelessWidget {
  static const routePath = '/login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = TextEditingController();
    final passwordController = TextEditingController();

    return BlocProvider(
      create: (_) => AuthenticationBloc(initialState: const LoginFormState()),
      child: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            context.go(DashboardScreen.routePath);
          }
          if (state is ShowTwoFactorVerification) {
            context.go(VerificationScreen.routePath);
          }
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            final formState =
                state is LoginFormState ? state : const LoginFormState();

            return Scaffold(
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
                        SizedBox(height: AppConstants.height(20)),
                        Text(
                          "Login to your account",
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w100),
                        ),
                        SizedBox(height: AppConstants.height(30)),
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
                          onChanged:
                              (value) => context.read<AuthenticationBloc>().add(
                                LoginFieldChanged(
                                  value,
                                  passwordController.text,
                                ),
                              ),
                        ),
                        SizedBox(height: AppConstants.height(10)),
                        TextFieldCustom(
                          hintText: "Password",
                          obscureText: true,
                          controller: passwordController,
                          prefixIcon: Transform.scale(
                            scale: 0.5,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 4,
                              ),
                              child: Image.asset(
                                "assets/icons/password.png",
                                width: 24,
                              ),
                            ),
                          ),
                          onChanged:
                              (value) => context.read<AuthenticationBloc>().add(
                                LoginFieldChanged(loginController.text, value),
                              ),
                        ),
                        SizedBox(height: AppConstants.height(20)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextButton(
                              text: "Forgot Login ID?",
                              onPressed:
                                  () => context.push(ForgotLoginID.routePath),
                              color: AppColors.black,
                            ),
                            CustomTextButton(
                              text: "Forgot Password?",
                              onPressed:
                                  () => context.push(
                                    ForgotPasswordScreen.routePath,
                                  ),
                              color: AppColors.black,
                            ),
                          ],
                        ),
                        if (formState.errorMessage != null) ...[
                          SizedBox(height: AppConstants.height(20)),
                          ShakingErrorText(
                            errorMessage: formState.errorMessage!,
                          ),
                        ],

                        SizedBox(height: AppConstants.height(20)),
                        // FormSubmitButton(
                        //   makeEvent: (state) {
                        //     final s = state as LoginFormState;
                        //     return LoginSubmitted(s.login, s.password);
                        //   },
                        // ),
                        ButtonCustom(
                          onPressed: formState.isFormFilled
                              ? () => context.read<AuthenticationBloc>().add(
                            LoginSubmitted(
                              loginController.text.trim(),
                              passwordController.text.trim(),
                            ),
                          )
                              : null,
                          text: "Login",
                          backgroundColor: formState.isFormFilled
                              ?  AppColors.buttonActive
                              :  AppColors.buttonDisable,
                        ),
                        SizedBox(height: AppConstants.height(20)),
                        ButtonCustom(
                          onPressed: () => context.push(SingleSignOn.routePath),
                          text: "Single Sign on",
                          backgroundColor: AppColors.white,
                          textColor: AppColors.black,
                          iconAsImage: "assets/icons/sso-icon.png",
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
