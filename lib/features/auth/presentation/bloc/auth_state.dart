part of 'auth_bloc.dart';

 class AuthenticationState extends Equatable {
  const AuthenticationState();


  @override
  List<Object?> get props => [];
}

class LoginFormState extends AuthenticationState {

  final String login;
  final String password;
  final String? errorMessage;

  const LoginFormState({
    this.login = '',
    this.password = '',
    this.errorMessage,
  });

  bool get isFormFilled => login.isNotEmpty && password.isNotEmpty;


  LoginFormState copyWith({
    String? login,
    String? password,
    String? errorMessage,
  }) {
    return LoginFormState(
      login: login ?? this.login,
      password: password ?? this.password,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [login, password, errorMessage];
  
}

class LoginSuccess extends AuthenticationState {
}

class ShowTwoFactorVerification extends AuthenticationState {
}

class ForgotPasswordState extends AuthenticationState {
  
  final String email;
  final String? errorMessage;

  const ForgotPasswordState({this.email = '', this.errorMessage});

  bool get isEmailFilled => email.isNotEmpty;

  ForgotPasswordState copyWith({String? email, String? errorMessage}) {
    return ForgotPasswordState(
      email: email ?? this.email,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [email, errorMessage];
  
  }

class OtpSendSuccess extends AuthenticationState {
  final String email;

  const OtpSendSuccess(this.email);

  @override
  List<Object> get props => [email];
}

class ForgotLoginIdState extends AuthenticationState {
  final String email;
  final String? errorMessage;

  const ForgotLoginIdState({this.email = '', this.errorMessage});

  bool get isEmailFilled => email.isNotEmpty;

  ForgotLoginIdState copyWith({String? email, String? errorMessage}) {
    return ForgotLoginIdState(
      email: email ?? this.email,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [email, errorMessage];
}
enum OtpVerificationStatus { initial, submitting, success, failure, resent }
class OtpVerificationState extends AuthenticationState {
  final String email;
  final OtpVerificationStatus status;
  final String otp;
  final String? errorMessage;

  const OtpVerificationState({
    this.email = '',
    this.status = OtpVerificationStatus.initial,
    this.otp = '',
    this.errorMessage,
  });

  bool get isOtpFilled => otp.isNotEmpty;

  OtpVerificationState copyWith({
    String? email,
    OtpVerificationStatus? status,
    String? otp,
    String? errorMessage,
  }) {
    return OtpVerificationState(
      email: email ?? this.email,
      status: status ?? this.status,
      otp: otp ?? this.otp,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [email, status, otp, errorMessage];
  
}
