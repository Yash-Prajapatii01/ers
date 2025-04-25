
import 'package:ers_linux/features/auth/presentation/screens/success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../shared/constants/app_constants.dart';
import '../../../../shared/theme/app_colors.dart';
import '../widgets/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/login_background.dart';
import 'login_screen.dart';

class SetNewPassword extends StatefulWidget {
  static const routePath = '/set_new_password';

  const SetNewPassword({super.key});

  @override
  State<SetNewPassword> createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showMismatchError = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordController.addListener(_onFormChanged);
    _confirmPasswordController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_onFormChanged);
    _confirmPasswordController.removeListener(_onFormChanged);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    setState(() {});
  }

  Future<void> _saveNewPassword() async {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      setState(() {
        _showMismatchError = true;
      });
    } else {
      setState(() {
        _showMismatchError = false;
      });

      try {
        final supabase = Supabase.instance.client;

        await supabase.auth.updateUser(
          UserAttributes(password: confirmPassword),
        );
        if (mounted) {
          context.go(SuccessScreen.routePath);
        }

        ConstantWidget.showSnack(context, 'Password updated successfully');
      } on AuthException catch (e) {
        ConstantWidget.showSnack(context, 'Error: ${e.message}');
      } catch (e) {
        ConstantWidget.showSnack(context, 'An unexpected error occurred');
      }
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
                    "Set New Password",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
                SizedBox(height: AppConstants.height(20)),
                Center(
                  child: Text(
                    "Set the new password for your account so you can login and access.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.lightText,
                    ),
                  ),
                ),
                SizedBox(height: AppConstants.height(20)),
                TextFieldCustom(
                  hintText: "New Password",
                  obscureText: true,
                  controller: _passwordController,
                  prefixIcon: Transform.scale(
                    scale: 0.5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 4,
                      ),
                      child: Image.asset("assets/icons/user.png", width: 24),
                    ),
                  ),
                ),
                SizedBox(height: AppConstants.height(5)),
                Text(
                  "Length 8-50 with numbers, letters and special characters.",
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.lightText,
                  ),
                ),
                SizedBox(height: AppConstants.height(20)),
                TextFieldCustom(
                  hintText: "Confirm New Password",
                  obscureText: true,
                  controller: _confirmPasswordController,
                  prefixIcon: Transform.scale(
                    scale: 0.5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 4,
                      ),
                      child: Image.asset("assets/icons/user.png", width: 24),
                    ),
                  ),
                ),
                if (_showMismatchError) ...[
                  SizedBox(height: AppConstants.height(25)),
                  Center(
                    child: Text(
                      "The confirm password does not match.",
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.error),
                    ),
                  ),
                ],
                SizedBox(height: AppConstants.height(25)),
                ButtonCustom(
                  onPressed:
                      _passwordController.text.isNotEmpty &&
                              _confirmPasswordController.text.isNotEmpty
                          ? _saveNewPassword
                          : null,
                  text: "Save Changes",
                  backgroundColor:
                      _passwordController.text.isNotEmpty &&
                              _confirmPasswordController.text.isNotEmpty
                          ? AppColors.buttonActive
                          : AppColors.buttonDisable
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
  }
}
