import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/forgot_login_id.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/otp_verification.dart';
import '../../features/auth/presentation/screens/set_new_password.dart';
import '../../features/auth/presentation/screens/single_sign_on.dart';
import '../../features/auth/presentation/screens/success_screen.dart';
import '../../features/auth/presentation/screens/two_factor_authentication.dart';
import '../../features/shell/presentation/screens/dashboard_screen.dart';
import '../../features/splash_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: SplashScreen.routePath,
    routes: [
      GoRoute(
        path: SplashScreen.routePath,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: LoginScreen.routePath,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: ForgotPasswordScreen.routePath,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: OtpVerification.routePath,
        builder: (context, state) {
          final email = state.extra as String;
          return OtpVerification(email: email);
        },
      ),
      GoRoute(
        path: SetNewPassword.routePath,
        builder: (context, state) => const SetNewPassword(),
      ),
      GoRoute(
        path: SuccessScreen.routePath,
        builder: (context, state) => const SuccessScreen(),
      ),
      GoRoute(
        path: ForgotLoginID.routePath,
        builder: (context, state) => ForgotLoginID(),
      ),
      GoRoute(
        path: SingleSignOn.routePath,
        builder: (context, state) => SingleSignOn(),
      ),
      GoRoute(
        path: DashboardScreen.routePath,
        builder: (context, state) => DashboardScreen(),
      ),
      GoRoute(
        path: VerificationScreen.routePath,
        builder: (context, state) => VerificationScreen(),
      ),
    ],
    errorBuilder:
        (context, state) =>
            const Scaffold(body: Center(child: Text('404 - Page Not Found'))),
  );
}
