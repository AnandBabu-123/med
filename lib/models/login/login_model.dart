class LoginModel {
  String? responseMessage;
  String? details;
  bool? status;
  String? userId;
  String? username;
  String? userType;
  String? userEmailAddress;
  String? userContact;
  String? token;
  String? dashboardRole;

  LoginModel(
      {this.responseMessage,
        this.details,
        this.status,
        this.userId,
        this.username,
        this.userType,
        this.userEmailAddress,
        this.userContact,
        this.token,
        this.dashboardRole});

  LoginModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    details = json['details'];
    status = json['status'];
    userId = json['userId'];
    username = json['username'];
    userType = json['userType'];
    userEmailAddress = json['userEmailAddress'];
    userContact = json['userContact'];
    token = json['token'];
    dashboardRole = json['dashboardRole'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseMessage'] = this.responseMessage;
    data['details'] = this.details;
    data['status'] = this.status;
    data['userId'] = this.userId;
    data['username'] = this.username;
    data['userType'] = this.userType;
    data['userEmailAddress'] = this.userEmailAddress;
    data['userContact'] = this.userContact;
    data['token'] = this.token;
    data['dashboardRole'] = this.dashboardRole;
    return data;
  }
}
