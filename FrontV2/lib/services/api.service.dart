import 'dart:convert';
import '../exports.dart';
import 'package:http/http.dart' as http;

class APIservice {
  static const headers = {
    "Access-Control-Allow-Origin": "*",
    'Content-Type': 'application/json',
    'Accept': '*/*'
  };

  static Future<int> login(LoginRequestModel model) async {
    Uri url = Uri.http(Config.apiURL, Config.loginAPI);
    final header = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    final dataBody = json.encode(model.toJson());
    try {
      final response = await http
          .post(url, headers: header, body: dataBody)
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        await Shared.setLogginDetails(loginResponseModel(response.body));
        return 0;
      } else {
        return 1;
      }
    } catch (e) {
      print(e);
      return 2;
    }
  }

  //indica si el token es válido o no.
  static Future<bool> isValidToken(String token) async {
    final url = Uri.http(Config.apiURL, Config.isValidTokenAPI);

    try {
      // Realiza una solicitud HTTP POST a la URL definida anteriormente. Incluye el cuerpo de la solicitud, que es un objeto JSON que contiene el `token`.
      final response = await http
          .post(url, headers: headers, body: jsonEncode({'token': token}))
          .timeout(
            const Duration(seconds: 3),
          ); // Establece un tiempo de espera máximo de 3 segundos para la respuesta.

      // Verifica si la respuesta tiene un código de estado HTTP 200 (OK). Si es así, devuelve `true`. De lo contrario, devuelve `false`.
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
    // Obtiene el token de autenticación del almacenamiento compartido.
    final token = Shared.getToken();
    if (token == 'default') {
      // Si el token es el valor predeterminado, devuelve 0 para indicar un error.
      return 0;
    }

    final url = Uri.http(Config.apiURL, Config.registerBiometric);

    final body =
        json.encode({"email": email, "password": password, "token": token});

    try {
      // Realiza una solicitud HTTP POST a la URL definida anteriormente. Incluye el cuerpo de la solicitud, que es el objeto JSON construido anteriormente.
      final response = await http
          .post(url, headers: headers, body: body)
          .timeout(
            const Duration(seconds: 5),
          ); // Establece un tiempo de espera máximo de 5 segundos para la respuesta.

      // indica el resultado de la operación de registro biométrico.
      if (response.statusCode == 200) {
        //almacena el token biométrico en el almacenamiento seguro y devuelve que el registro se ha realizado correctamente.
        await SecureStorageService.setBiometricToken(jsonDecode(response.body));
        return 1;
      } else if (response.statusCode == 402) {
        // Si la respuesta tiene un código de estado HTTP 402, devuelve 2 para indicar que el usuario no está suscrito a la función de autenticación biométrica.
        return 2;
      } else if (response.statusCode == 409) {
        // Si la respuesta tiene un código de estado HTTP 409, devuelve 3 para indicar que ya hay un usuario registrado con la dirección de correo electrónico proporcionada.
        return 3;
      } else {
        // En cualquier otro caso, devuelve 4 para indicar un error.
        return 4;
      }
    } catch (e) {
      return 5;
    }
  }

  static Future<bool> removeBiometric() async {
    // Obtenemos el token actual
    final token = Shared.getToken();

    // Obtenemos el token biométrico actual
    final biometricToken = await SecureStorageService.getBiometricToken();

    if (token == 'default' || biometricToken == 'default') {
      return false;
    }

    final url = Uri.http(Config.apiURL, Config.removeBiometric);

    final body = json.encode(
      {"token": token, "biometricToken": biometricToken},
    );
    try {
      final response =
          await http.post(url, headers: headers, body: body).timeout(
                const Duration(seconds: 5),
              );

      // Si la respuesta tiene un status code de 200, borramos el token biométrico y devolvemos true
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

    //cuerpo de la petición
    final body = json.encode({
      "token": token,
      "biometricToken": biometricToken,
    });

    try {
      //petición POST
      final response =
          await http.post(url, headers: headers, body: body).timeout(
                const Duration(seconds: 5),
              );

      //guardamos los detalles del inicio de sesión y devolvemos true
      if (response.statusCode == 200) {
        final loginDetails = loginResponseModel(response.body);
        await Shared.setLogginDetails(loginDetails);
        return true;
      }
    } catch (e) {}

    return false;
  }
}
