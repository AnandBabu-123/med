part of 'login_bloc.dart';


class LoginStates extends Equatable {
  const LoginStates({
    this.email = '',
    this.password = '',
    this.message = '',
    this.userId = 0,
    this.postApiStatus = PostApiStatus.initial,
  });

  final String email;
  final String password;
  final String message;
  final int userId;   // ✅ FIXED TYPE
  final PostApiStatus postApiStatus;

  LoginStates copyWith({
    String? email,
    String? password,
    String? message,
    int? userId,                // ✅ ADDED
    PostApiStatus? postApiStatus,
  }) {
    return LoginStates(
      email: email ?? this.email,
      password: password ?? this.password,
      message: message ?? this.message,
      userId: userId ?? this.userId,        // ✅ ADDED
      postApiStatus: postApiStatus ?? this.postApiStatus,
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    message,
    userId,              // ✅ ADDED
    postApiStatus,
  ];
}
