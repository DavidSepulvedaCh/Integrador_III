import '../exports.dart';

class SecureStorageService {
  static late FlutterSecureStorage storage;

  static Future<void> setUp() async {
    storage = const FlutterSecureStorage();
  }

  static Future<void> setBiometricToken(Map<String, dynamic> json) async {
    String token = json['token'];
    await storage.write(key: "biometricToken", value: token);
  }

  static Future<bool> isUsingBiometric2() async {
    final response = await storage.read(key: 'biometricToken');
    return response != null;
  }

  static Future<void> clearBiometricToken() async {
    await storage.deleteAll();
  }

  static Future<bool> isUsingBiometric() async {
    final response = await storage.read(key: 'usingBiometric');
    return response == 'true';
  }

  static Future<String> getBiometricToken() async {
    final token = await storage.read(key: 'biometricToken');
    return token ?? 'default';
  }
}
