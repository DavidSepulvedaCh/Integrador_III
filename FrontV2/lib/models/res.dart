import 'dart:convert';

class LoginResponseModel {
  final String? email;
  final String? token;

  LoginResponseModel({this.email, this.token});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      email: json['email'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'token': token,
    };
  }
}

LoginResponseModel loginResponseModel(String str) {
  final decodedJson = jsonDecode(str);
  return LoginResponseModel.fromJson(decodedJson);
}
