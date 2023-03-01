import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:integrador/config.dart';
import 'package:integrador/models/login_response_model.dart';
import 'package:integrador/models/login_request_model.dart';
import 'package:integrador/services/shared_service.dart';

class APIService {
  static var client = http.Client();

  static Future<int> login(LoginRequestModel model) async {
    Uri url = Uri.http(Config.apiURL, Config.loginAPI);
    final header = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    final dataBody = json.encode(model.toJson());
    try {
      final response = await http.post(url, headers: header, body: dataBody).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        await SharedService.setLogginDetails(loginResponseModel(response.body));
        return 0;
      } else {
        return 1;
      }
    } catch (e) {
      return 2;
    }
  }
}
