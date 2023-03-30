import 'dart:convert';
import '../exports.dart';
import 'package:http/http.dart' as http;

class APIservice{
  static const headers = {
    "Access-Control-Allow-Origin": "*",
    'Content-Type': 'application/json',
    'Accept': '*/*'
  };

  static Future<int> login(LoginRequestModel model) async {
    final url = Uri.http(Config.apiURL, Config.loginAPI);
    final dataBody = json.encode(model.toJson());
    try {
      final response = await http
          .post(url, headers: headers, body: dataBody)
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        await Shared.setLogginDetails(loginResponseModel(response.body));
        return 0;
      } else {
        return 1;
      }
    } catch (e) {
      return 2;
    }
  }

  static Future<bool> isValidToken(String token) async {
    final url = Uri.http(Config.apiURL, Config.isValidTokenAPI);
    try {
      final response = await http
          .post(url, headers: headers, body: jsonEncode({'token': token}))
          .timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<int> biometricRegister(String email, String password) async {
    final token = Shared.getToken();
    if (token == 'default') {
      return 0;
    }
    final url = Uri.http(Config.apiURL, Config.registerBiometric);
    final body =
        json.encode({"email": email, "password": password, "token": token});
    try {
      final response = await http
          .post(url, headers: headers, body: body)
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        await SecureStorageService.setBiometricToken(jsonDecode(response.body));
        return 1;
      } else if (response.statusCode == 402) {
        return 2;
      } else if (response.statusCode == 409) {
        return 3;
      } else {
        return 4;
      }
    } catch (e) {
      return 5;
    }
  }

  static Future<bool> removeBiometric() async {
    final token = Shared.getToken();
    final biometricToken = await SecureStorageService.getBiometricToken();
    if (token == 'default' || biometricToken == 'default') {
      return false;
    }
    final url = Uri.http(Config.apiURL, Config.removeBiometric);
    final body =
        json.encode({"token": token, "biometricToken": biometricToken});
    try {
      final response = await http
          .post(url, headers: headers, body: body)
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        await SecureStorageService.clearBiometricToken();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> biometricLogin() async {
    final token = Shared.getToken();
    final biometricToken = await SecureStorageService.getBiometricToken();

    if (biometricToken == 'default') {
      return false;
    }

    final url = Uri.http(Config.apiURL, Config.loginBiometric);
    final headers = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };

    final body = json.encode({
      "token": token,
      "biometricToken": biometricToken,
    });

    try {
      final response = await http
          .post(url, headers: headers, body: body)
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final loginDetails = loginResponseModel(response.body);
        await Shared.setLogginDetails(loginDetails);
        return true;
      }
    } catch (e) {
      // fall through
    }
    return false;
  }
}
