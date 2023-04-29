import 'package:integrador/models/login_response_model.dart';
import 'package:integrador/models/restaurant_details_response.dart';
import 'package:integrador/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedService{
  
  static late SharedPreferences prefs;

  static Future<void> setUp() async{
    prefs = await SharedPreferences.getInstance();
  }
  
  static Future<int> isLoggedIn() async {
    bool isKeyExists = prefs.containsKey('token');
    if(isKeyExists){
      String token = prefs.getString('token') ?? 'default';
      return await APIService.isValidToken(token);
    }else{
      return -1;
    }
  }

  static Future<void> setLogginDetails(LoginResponseModel model) async {
    var id = model.id ?? 'default';
    var name= model.name ?? 'default';
    var email = model.email ?? 'default';
    var photo = model.photo ?? 'https://bit.ly/3Lstjcq';
    var role = model.role ?? 'default';
    var token = model.token ?? 'default';
    if(name!= 'default' && token != 'default' && email != 'default' && id != 'default' && role != 'default'){
      await prefs.setString('id', id);
      await prefs.setString('email', email);
      await prefs.setString('name', name);
      await prefs.setString('role', role);
      await prefs.setString('token', token);
    }
    await prefs.setString("photo", photo);
  }

  static Future<void> setRestaurantDetails(RestaurantDetailsResponse model) async {
    var latitude = model.latitude ?? 'default';
    var longitude = model.longitude ?? 'default';
    var address = model.address ?? 'default';
    var city = model.city ?? 'default';
    var description = model.description ?? "";
    if(longitude!= 'default' && latitude != 'default' ){
      await prefs.setString('latitude', latitude);
      await prefs.setString('longitude', longitude);
      if(address != 'default'){
        await prefs.setString('address', address);
      }
      if(city != 'default'){
        await prefs.setString('city', city);
      }
      await prefs.setString("description", description);
    }
  }

  static Future<void> updateRestaurantName(String name) async {
    await prefs.setString("name", name);
  }

  static Future<void> updateRestaurantPhoto(String photo) async {
    await prefs.setString("photo", photo);
  }

  static Future<void> updateRestaurantDescription(String description) async {
    await prefs.setString("description", description);
  }
}