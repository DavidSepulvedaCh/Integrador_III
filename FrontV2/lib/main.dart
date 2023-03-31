import 'package:app_vendedor/exports.dart';
import 'package:get/get.dart';
import '/vistasR/nuevapromo.dart';
import 'home.dart';
import 'vistasR/restaurantehome.dart';
import 'vistasR/restaurantelogin.dart';
import 'vistasR/restauranteperfil.dart';
import 'vistasR/restauranteregistro.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Shared.setUp();
  await SecureStorageService.setUp();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FoodHub',
      home: const Home(),
      routes: {
        '/restauranteregistro': (context) => const RegistroRestaurante(),
        '/restauranteperfil': (context) => const PerfilRestaurante(),
        '/restaurantelogin': (context) => const LoginRestaurante(),
        '/restaurantehome': (context) => const HomeRestaurante(),
        '/nuevapromocion': (context) => const NuevaPromo(),
        '/home': (context) => const Home(),
      },
    ),
  );
}
