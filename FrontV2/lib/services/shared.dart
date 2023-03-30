import '../exports.dart';


class Shared {
  static late SharedPreferences prefs;

  // inicializar las preferencias compartidas
  static Future<void> setUp() async {
    prefs = await SharedPreferences.getInstance();
  }

  // comprobar si el usuario está actualmente autenticado en la aplicación
  static Future<bool> isLoggedIn() async {

    // comprobar si el token está presente en las preferencias compartidas
    final bool isKeyExists = prefs.containsKey('token');
    if (isKeyExists) {
      // obtener el token de las preferencias compartidas
      final String token = prefs.getString('token') ?? 'default';
      // verificar la validez del token llamando a la función APIservice.isValidToken()
      return await APIservice.isValidToken(token);
    } else {
      return false;
    }
  }

  // guardar los detalles del inicio de sesión en las preferencias compartidas
  static Future<void> setLogginDetails(LoginResponseModel model) async {
    
    final email = model.email ?? 'default';
    final token = model.token ?? 'default';

    // si el correo electrónico o el token son 'default', no se guardan
    if (email == 'default' || token == 'default') {
      return;
    }

    // guardar el correo electrónico y el token en las preferencias compartidas
    await Future.wait([
      prefs.setString('email', email),
      prefs.setString('token', token),
    ]);
  }

  // obtener el token almacenado en las preferencias compartidas
  static String getToken() {
    // token de las preferencias compartidas o 'default' si no se encuentra
    return prefs.getString('token') ?? 'default';
  }
}
