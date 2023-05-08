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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    PushNotificationService.messageStream.listen((event) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => RestaurantSelected(restaurant: event),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodHub',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      navigatorKey: navigatorKey,
      routes: {
        '/': (context) => const IsLoggedMiddleware(),
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
