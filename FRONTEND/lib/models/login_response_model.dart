import 'dart:convert';

LoginResponseModel loginResponseModel(String str){
  return LoginResponseModel.fromJson(jsonDecode(str));
}

class LoginResponseModel {
    String? name;
    String? token;

    LoginResponseModel({this.name, this.token}); 

    LoginResponseModel.fromJson(Map<String, dynamic> json) {
        name = json['name'];
        token = json['token'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['name'] = name;
        data['token'] = token;
        return data;
    }
}