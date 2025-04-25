
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../../../shared/constants/app_constants.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/utils/webview.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_button.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/login_background.dart';

class SingleSignOn extends StatefulWidget {
  static const routePath = '/single_sign_on';

  const SingleSignOn({super.key});

  @override
  State<SingleSignOn> createState() => _SingleSignOnState();
}

class _SingleSignOnState extends State<SingleSignOn> {
  final emailController = TextEditingController();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    emailController.removeListener(_onFormChanged);
    emailController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    setState(() {});
  }

  Future<void> _handleSso(BuildContext context, String accountID) async {
    var uri = Uri.parse('https://test.eresourcescheduler.cloud/login/saml');

    var response = await http.post(
      uri,
      body: {
        'accountid': accountID,
        'locationHash': '',
      },
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    debugPrint("response statuscode:${response.statusCode}");
    debugPrint(" request:${response.request}");
    debugPrint(" headers:${response.headers}");
    debugPrint(" is redirect:${response.isRedirect}");


    if (response.statusCode == 302 || response.isRedirect) {
      // Extract redirected URL
      final redirectUrl = response.headers['location'];

      if (redirectUrl != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SsoWebView(url: Uri.parse(redirectUrl)),
          ),
        );
      } else {
        // Handle missing redirect URL
        debugPrint('Redirect location missing in response');
      }
    } else {
      // Handle non-redirect response
      debugPrint('Unexpected status: ${response.statusCode}');
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
                    "Login with SSO",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w100),
                  ),
                ),
                SizedBox(height: AppConstants.height(50)),
                TextFieldCustom(
                  hintText: "Enter Account ID",
                  obscureText: false,
                  controller: emailController,
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
                SizedBox(height: AppConstants.height(10)),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      _errorMessage!,
                      style:  TextStyle(color: AppColors.error),
                    ),
                  ),
                SizedBox(height: AppConstants.height(30)),
                ButtonCustom(
                  onPressed:
                      emailController.text.isNotEmpty
                          ? () => _handleSso(context, emailController.text)
                          : null,
                  text: "Continue",
                  backgroundColor:
                      emailController.text.isNotEmpty
                          ? AppColors.buttonActive
                          : AppColors.buttonDisable
                ),
                SizedBox(height: AppConstants.height(10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextButton(
                      text: "Back",
                      onPressed: () {
                        context.pop();
                      },
                      color: AppColors.black,
                    ),
                    CustomTextButton(
                      text: "Help",
                      onPressed: () {},
                      color: AppColors.black,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
