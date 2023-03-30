import '../exports.dart';

class Shared {
  static late SharedPreferences prefs;

  static Future<void> setUp() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> isLoggedIn() async {
    final bool isKeyExists = prefs.containsKey('token');
    if (isKeyExists) {
      final String token = prefs.getString('token') ?? 'default';
      return await APIservice.isValidToken(token);
    } else {
      return false;
    }
  }

  static Future<void> setLogginDetails(LoginResponseModel model) async {
    final email = model.email ?? 'default';
    final token = model.token ?? 'default';

    if (email == 'default' || token == 'default') {
      return;
    }

    await Future.wait([
      prefs.setString('email', email),
      prefs.setString('token', token),
    ]);
  }

  static String getToken() {
    return prefs.getString('token') ?? 'default';
  }

  
}
