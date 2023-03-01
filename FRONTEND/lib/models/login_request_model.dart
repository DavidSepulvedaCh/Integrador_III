class LoginRequestModel {
  String? email;
  String? password;

  LoginRequestModel({this.email, this.password});

  String getEmail(){
    String returnEmail = email ?? 'default';
    return returnEmail;
  }

  LoginRequestModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}