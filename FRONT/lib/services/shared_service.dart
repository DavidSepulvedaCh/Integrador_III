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
    var name= model.name ?? 'default';
    var email = model.email ?? 'default';
    var token = model.token ?? 'default';
    if(name!= 'default' && token != 'default' && email != 'default'){
      await prefs.setString('name', name);
      await prefs.setString('token', token);
      await prefs.setString('email', email);
    }
  }

}