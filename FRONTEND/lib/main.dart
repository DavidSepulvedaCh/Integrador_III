import 'package:integrador/widgets/newProm.dart';
import 'package:integrador/pages/system/index.dart';
import 'package:integrador/routes/imports.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedService.setUp();
  /* await dotenv.load(); 
  String apiKey = dotenv.env['apiKey']!;
  print(apiKey); */
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodHub',
      debugShowCheckedModeBanner: false,
      initialRoute: '/index',
      routes: {
        '/':(context) => const IsLoggedMiddleware(),
        '/login':(context) => const Login(),
        '/signUp':(context) => const Register(),
        '/signUpRestaurant':(context) => const RegisterRestaurant(),
        '/index': ((context) => const Index()),
        '/restaurant':(context) => const LoginRestaurante(),
        '/restaurantIndex':(context) =>  const HomeRestaurante(),
        '/nuevapromocion': (context) => const NuevaPromo(),
      },
    );
  }
}
