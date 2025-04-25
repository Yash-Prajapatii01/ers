part of 'auth_bloc.dart';

 class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class LoginFieldChanged extends AuthenticationEvent {
  final String login;
  final String password;

  const LoginFieldChanged(this.login, this.password);

  @override
  List<Object> get props => [login, password];
}

class LoginSubmitted extends AuthenticationEvent {
  final String login;
  final String password;

  const LoginSubmitted(this.login, this.password);

  @override
  List<Object> get props => [login, password];
}

class ForgotPasswordEmailChanged extends AuthenticationEvent {
  final String email;

  const ForgotPasswordEmailChanged(this.email);

  @override
  List<Object> get props => [email];
}


class GetOtpPressed extends AuthenticationEvent {
  final String email;

  const GetOtpPressed(this.email);

  @override
  List<Object> get props => [email];
}

class ForgotLoginIdFieldChanged extends AuthenticationEvent{
  final String email;

  const ForgotLoginIdFieldChanged(this.email);

  @override
  List<Object> get props => [email];
}

class ForgotLoginIdSubmitted extends AuthenticationEvent{
  final String email;

  const ForgotLoginIdSubmitted(this.email);

  @override
  List<Object> get props => [email];
}

class OtpFieldChanged extends AuthenticationEvent {
  final String otp;

  const OtpFieldChanged(this.otp);

  @override
  List<Object> get props => [otp];
}
class OtpSubmitted extends AuthenticationEvent {
  final String email;
  final String otp;

  const OtpSubmitted(this.otp, this.email);

  @override
  List<Object> get props => [otp, email] ;
}
class OtpResendPressed extends AuthenticationEvent {
  final String email;

  const OtpResendPressed(this.email);

  @override
  List<Object> get props => [email];
}