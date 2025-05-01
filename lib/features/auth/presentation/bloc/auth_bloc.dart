import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:ers_linux/features/auth/presentation/screens/otp_verification.dart';
import 'package:ers_linux/features/auth/presentation/screens/set_new_password.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

part 'auth_event.dart';

part 'auth_state.dart';

@injectable
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final SupabaseClient supabaseClient;
  AuthenticationBloc({required this.supabaseClient, @factoryParam AuthenticationState? initialState})
    : super(initialState ?? const LoginFormState()) {
    on<LoginFieldChanged>((event, emit) {
      if (state is LoginFormState) {
        emit(
          (state as LoginFormState).copyWith(
            login: event.login,
            password: event.password,
            errorMessage: null,
          ),
        );
      }
    });

    on<LoginSubmitted>((event, emit) async {
      emit(const LoginFormState(login: '', password: '', errorMessage: null));

      try {
        final res = await supabaseClient.auth.signInWithPassword(
          email: event.login,
          password: event.password,
        );

        if (res.user != null) {
          final session = supabaseClient.auth.currentSession;
          final token = session?.accessToken;
          if (token == null) {
            throw Exception('User is not authenticated.');
          }
          final url = Uri.parse(
            'https://jyqqaymjgytkralrxcey.supabase.co/functions/v1/delete-unverified-factors',
          );
          final delres = await http.post(
            url,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          );
          final body = jsonDecode(delres.body);
          if (delres.statusCode == 200) {
            debugPrint(
              '[✅] Deleted ${body['deletedCount']} unverified factors.',
            );
          } else {
            debugPrint('[❌] Status ${delres.statusCode}: ${body}');
            throw Exception('Failed to delete unverified TOTP factors.');
          }
          final factors = await supabaseClient.auth.mfa.listFactors();

          if (factors.all.isNotEmpty) {
            ///////////////////////////////
            final userId = res.user!.id;

            final response =
                await supabaseClient
                    .from('mfa_skip')
                    .select('skip_until')
                    .eq('user_id', userId)
                    .maybeSingle();

            if (response != null) {
              final skipUntil = DateTime.parse(
                response['skip_until'],
              ).toString().replaceAll('Z', '');
              debugPrint('MFA skip valid until: $skipUntil');
              final skipUntilDateTime = DateTime.parse(skipUntil);
              if (skipUntilDateTime.isAfter(DateTime.now())) {
                debugPrint(
                  'MFA skip valid until $skipUntil. Current time: ${DateTime.now()}',
                );
                emit(LoginSuccess());
                return;
              } else {
                try {
                  final deleteResult = await supabaseClient
                      .from('mfa_skip')
                      .delete()
                      .eq('user_id', userId);

                  debugPrint(
                    'Deleted expired mfa_skip for $userId: $deleteResult',
                  );
                } catch (e) {
                  debugPrint('Error deleting expired mfa_skip: $e');
                }
              }
            }

            //////////////////////////////////////
            emit(ShowTwoFactorVerification());
          } else {
            emit(LoginSuccess());
          }
        } else {
          emit(
            const LoginFormState(
              login: '',
              password: '',
              errorMessage: 'Invalid login credentials.',
            ),
          );
        }
      } on AuthException catch (e) {
        emit(
          LoginFormState(
            login: event.login,
            password: event.password,
            errorMessage: 'Login Error: ${e.message}',
          ),
        );
      } catch (e) {
        emit(
          LoginFormState(
            login: event.login,
            password: event.password,
            errorMessage: 'Login failed. Please check your credentials.',
          ),
        );
      }
    });

    on<ForgotPasswordEmailChanged>((event, emit) {
      if (state is ForgotPasswordState) {
        emit(
          (state as ForgotPasswordState).copyWith(
            email: event.email,
            errorMessage: null,
          ),
        );
      }
    });

    on<GetOtpPressed>((event, emit) async {
      final currentEmail =
          (state is ForgotPasswordState)
              ? (state as ForgotPasswordState).email
              : event.email;

      emit(
        (state is ForgotPasswordState)
            ? (state as ForgotPasswordState).copyWith(errorMessage: null)
            : ForgotPasswordState(email: currentEmail),
      );

      try {
        final res = await supabaseClient.functions.invoke(
          'check-user-exists',
          body: {"email": currentEmail},
        );

        debugPrint("status code is : ${res.status.toString()}");

        if (res.status == 200) {
          final data = res.data;
          if (data['exists'] == true) {
            final resolvedEmail = data['email'];
            debugPrint("✅ User exists. Email resolved: $resolvedEmail");
            emit(OtpSendSuccess(resolvedEmail));
            await Supabase.instance.client.auth.signInWithOtp(
              email: resolvedEmail,
            );
          } else {
            emit(
              ForgotPasswordState(
                email: currentEmail,
                errorMessage: 'User not found.',
              ),
            );
          }
        } else {
          emit(
            ForgotPasswordState(
              email: currentEmail,
              errorMessage: 'Please check your email.',
            ),
          );
        }
      } catch (e) {
        emit(
          ForgotPasswordState(
            email: currentEmail,
            errorMessage: 'Login failed. Please check your credentials.',
          ),
        );
      }
    });
    //------------------->fogot login id Bloc start <-------------------
    on<ForgotLoginIdFieldChanged>((event, emit) {
      if (state is ForgotLoginIdState) {
        emit(
          (state as ForgotLoginIdState).copyWith(
            email: event.email,
            errorMessage: null,
          ),
        );
      }
    });
    on<ForgotLoginIdSubmitted>((event, emit) async {
      final currentEmail =
          (state is ForgotLoginIdState)
              ? (state as ForgotLoginIdState).email
              : event.email;

      emit(
        (state is ForgotLoginIdState)
            ? (state as ForgotLoginIdState).copyWith(errorMessage: null)
            : ForgotLoginIdState(email: currentEmail),
      );
    });
    //------------------->fogot login id Bloc end <-------------------

    //------------------->OTP Verification Bloc start <-------------------
    on<OtpFieldChanged>(_onOtpFieldChanged);
    on<OtpSubmitted>(_onOtpSubmitted);
    on<OtpResendPressed>(_onOtpResendPressed);
    //------------------->OTP Verification Bloc End<-------------------
  }

  void _onOtpFieldChanged(
    OtpFieldChanged event,
    Emitter<AuthenticationState> emit,
  ) {
    if (state is OtpVerificationState) {
      emit(
        (state as OtpVerificationState).copyWith(
          otp: event.otp,
          status: OtpVerificationStatus.initial,
          errorMessage: null,
        ),
      );
    }
  }

  Future<void> _onOtpSubmitted(
    OtpSubmitted event,
    Emitter<AuthenticationState> emit,
  ) async {
    // kick off a loading state
    emit(
      OtpVerificationState(
        email: event.email,
        otp: event.otp,
        status: OtpVerificationStatus.submitting,
      ),
    );

    try {
      final res = await supabaseClient.auth.verifyOTP(
        type: OtpType.email,
        token: event.otp,
        email: event.email,
      );

      if (res.user != null) {
        emit(
          OtpVerificationState(
            email: event.email,
            otp: event.otp,
            status: OtpVerificationStatus.success,
          ),
        );
      } else {
        emit(
          OtpVerificationState(
            email: event.email,
            otp: event.otp,
            status: OtpVerificationStatus.failure,
            errorMessage: 'Invalid OTP.',
          ),
        );
      }
    } catch (e) {
      emit(
        OtpVerificationState(
          email: event.email,
          otp: event.otp,
          status: OtpVerificationStatus.failure,
          errorMessage: 'Failed to verify OTP.',
        ),
      );
    }
  }

  Future<void> _onOtpResendPressed(
    OtpResendPressed event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (state is! OtpVerificationState) return;

    // show loading again
    emit(
      (state as OtpVerificationState).copyWith(
        status: OtpVerificationStatus.submitting,
        errorMessage: null,
      ),
    );

    try {
      await supabaseClient.auth.resetPasswordForEmail(event.email);
      emit(
        (state as OtpVerificationState).copyWith(
          status: OtpVerificationStatus.resent,
        ),
      );
    } catch (e) {
      emit(
        (state as OtpVerificationState).copyWith(
          status: OtpVerificationStatus.failure,
          errorMessage: 'Failed to resend OTP.',
        ),
      );
    }
  }
}
