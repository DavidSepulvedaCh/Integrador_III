import '../exports.dart';

class SecureStorageService {
  static late FlutterSecureStorage storage;

  //Se inicia el almacenamiento seguro (toca llamarla en el main)
  static Future<void> setUp() async {
    storage = const FlutterSecureStorage();
  }

// guarda el token biométrico
  static Future<void> setBiometricToken(Map<String, dynamic> json) async {
    // Obtenemos el token de la respuesta JSON
    String token = json['token'];
    // Se guarda
    await storage.write(key: "biometricToken", value: token);
  }

// verificar si se está utilizando el token biométrico
  static Future<bool> isUsingBiometric2() async {
    // lee el valor asociado a la clave 'biometricToken' del almacenamiento seguro
    final response = await storage.read(key: 'biometricToken');
    // se revisa si hay un valor o no
    return response != null;
  }

// borrar el token biométrico
  static Future<void> clearBiometricToken() async {
    await storage.deleteAll();
  }

// verificar si se está utilizando el token biométrico
  static Future<bool> isUsingBiometric() async {
    // lee el valor asociado a la clave 'usingBiometric' del almacenamiento seguro
    final response = await storage.read(key: 'usingBiometric');
    // se revisa si hse utiliza o no
    return response == 'true';
  }

// obtener el token biométrico
  static Future<String> getBiometricToken() async {
    // lee el valor asociado a la clave 'biometricToken' del almacenamiento seguro
    final token = await storage.read(key: 'biometricToken');
    // si no hay un valor, devolvemos 'default'
    return token ?? 'default';
  }
}
