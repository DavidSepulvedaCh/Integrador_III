import 'package:integrador/pages/edit_user.dart';
import 'package:integrador/widgets/new_promo.dart';
import 'package:integrador/pages/system/index.dart';
import 'package:integrador/routes/imports.dart';

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
      initialRoute: '/',
      routes: {
        '/':(context) => const IsLoggedMiddleware(),
        '/login':(context) => const Login(),
        '/signUp':(context) => const Register(),
        '/signUpRestaurant':(context) => const RegisterRestaurant(),
        '/index': ((context) => const Index()),
        '/restaurantIndex':(context) =>  const HomeRestaurante(),
      },
    );
  }
}
