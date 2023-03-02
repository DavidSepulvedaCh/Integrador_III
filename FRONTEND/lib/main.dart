import 'package:integrador/pages/welcome.dart';
import 'package:integrador/routes/imports.dart';
import 'package:integrador/services/shared_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedService.setUp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String> sessionOpen() async {
    var session = await SharedService.isLoggedIn();
    if(session){
      return '/secondPage';
    }
    return '/';
  }

  @override
  Widget build(BuildContext context) {
    Future<String> page = sessionOpen();
    return MaterialApp(
      title: 'FoodHub',
      debugShowCheckedModeBanner: false,
      initialRoute: page.toString(),
      routes: {
        '/':(context) => const Login(),
        '/signUp':(context) => const Register(),
        '/secondPage': ((context) => const SecondPage())
      },
    );
  }
}
