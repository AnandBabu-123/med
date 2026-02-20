
part of 'login_bloc.dart';

class LoginEvent extends Equatable{
  const LoginEvent();

  List<Object?> get props => [];
}

class EmailChange extends LoginEvent {
  const EmailChange({required this.email});
  final String email;

  List<Object?> get props => [email];
}

class EmailUnFocused extends LoginEvent{}

class PasswordChange extends LoginEvent{
  const PasswordChange({required this.password});

  final String password;
  List<Object?> get props => [password];
}

class PasswordUnFocused extends LoginEvent{}

class LoginApi extends LoginEvent{}