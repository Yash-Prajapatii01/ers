// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../shared/theme/app_colors.dart';
// import '../bloc/auth_bloc.dart';
// import 'custom_button.dart';

// typedef EventFactory = AuthenticationEvent Function(AuthenticationState);

// class FormSubmitButton extends StatelessWidget {
//   final EventFactory makeEvent;
//   final String? textOverride;

//   const FormSubmitButton({
//     Key? key,
//     required this.makeEvent,
//     this.textOverride,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AuthenticationBloc, AuthenticationState>(
//       builder: (context, state) {
//         final enabled = state.isValid;
//         final event   = enabled ? makeEvent(state) : null;

//         // Default labels per state type
//         final defaultLabel = state is LoginFormState
//             ? 'Login'
//             : state is ForgotLoginIdState
//                 ? 'Send My Login ID'
//                 : state is OtpVerificationState
//                     ? 'Verify OTP'
//                     : '';

//         return ButtonCustom(
//           onPressed: event == null
//               ? null
//               : () => context.read<AuthenticationBloc>().add(event),
//           text: textOverride ?? defaultLabel,
//           backgroundColor:
//               enabled ? AppColors.buttonActive : AppColors.buttonDisable,
//         );
//       },
//     );
//   }
// }
