import 'dart:convert';

LoginResponseModel loginResponseModel(String str){
  return LoginResponseModel.fromJson(jsonDecode(str));
}

class LoginResponseModel {
    String? id;
    String? name;
    String? email;
    String? photo;
    String? role;
    String? token;

    LoginResponseModel({this.id, this.name, this.email, this.photo, this.role, this.token});

    LoginResponseModel.fromJson(Map<String, dynamic> json) {
        id = json['id'];
        name = json['name'];
        email = json['email'];
        photo = json['photo'];
        role = json['role'];
        token = json['token'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['id'] = id;
        data['name'] = name;
        data['email'] = email;
        data['photo'] = photo;
        data['role'] = role;
        data['token'] = token;
        return data;
    }
}