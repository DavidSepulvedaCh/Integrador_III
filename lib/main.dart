import 'package:integrador/routes/imports.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodHub',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/':(context) => Login(),
        '/signUp':(context) => const Register()
      },
    );
  }
}
