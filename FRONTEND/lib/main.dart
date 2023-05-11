import 'package:flutter/material.dart';
import 'package:integrador/pages/system/index.dart';
import 'package:integrador/routes/imports.dart';
import 'package:integrador/services/push_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationService.setUp();
  await SharedService.setUp();
  await SecureStorageService.setUp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodHub',
      debugShowCheckedModeBanner: false,
      home: Splash(),
      routes: {
        '/login': (context) => const Login(),
        '/signUp': (context) => const Register(),
        '/signUpRestaurant': (context) => const RegisterRestaurant(),
        '/index': ((context) => const Index()),
        '/restaurantIndex': (context) => const HomeRestaurante(),
        '/mapa': (context) => const MapSample(),
      },
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const IsLoggedMiddleware()),
      );
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/foodhubL.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
