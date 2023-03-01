import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:integrador/models/login_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedService{
  
  static late SharedPreferences prefs;

  static Future<void> setUp() async{
    prefs = await SharedPreferences.getInstance();
  }
  
  static Future<bool> isLoggedIn() async {
    var isKeyExists = await APICacheManager().isAPICacheKeyExist('login_details');

    return isKeyExists;
  }

  static Future<void> setLogginDetails(LoginResponseModel model) async {
    var email = model.name ?? 'default';
    var token = model.token ?? 'default';
    if(email != 'default' && token != 'default'){
      await prefs.setString('name', email);
      await prefs.setString('token', token);
    }
  }

}