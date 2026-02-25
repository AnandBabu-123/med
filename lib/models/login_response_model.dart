class LoginResponseModel {
  final bool status;
  final String message;
  final UserResponse response;

  LoginResponseModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      status: json["status"],
      message: json["message"],
      response: UserResponse.fromJson(json["response"]),
    );
  }
}

class UserResponse {
  final int id;
  final int mobile;
  final String email;
  final String authToken;

  UserResponse({
    required this.id,
    required this.mobile,
    required this.email,
    required this.authToken,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json["id"],
      mobile: json["mobile"],
      email: json["email"] ?? "",
      authToken: json["auth_token"] ?? "",
    );
  }
}