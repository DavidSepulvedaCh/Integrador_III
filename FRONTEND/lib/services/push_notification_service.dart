import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:integrador/routes/imports.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  static final StreamController<Restaurant> _messageStream =
      StreamController.broadcast();
  static Stream<Restaurant> get messageStream => _messageStream.stream;

  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> setUp() async {
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();

    // Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@drawable/ic_stat_foodhub");
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: _onSelectedNotification);
  }

  static Future<void> _backgroundHandler(RemoteMessage message) async {
    final idRestaurant = message.data['idRestaurant'] ?? "No-data";
    int isLoggedIn = await SharedService.isLoggedIn();
    if (isLoggedIn == -1 || idRestaurant == "No-data") {
      return;
    }
    Restaurant? restaurant = await APIService.getRestaurantById(idRestaurant);
    if (restaurant == null) {
      return;
    }
    _messageStream.add(restaurant);
  }

  static Future<void> _onMessageHandler(RemoteMessage message) async {
    final idRestaurant = message.data['idRestaurant'] ?? "No-data";
    int isLoggedIn = await SharedService.isLoggedIn();
    if (isLoggedIn == -1 || idRestaurant == "No-data") {
      return;
    }
    _showNotification(message.notification?.title ?? "",
        message.notification?.body ?? "", idRestaurant);
  }

  static Future<void> _onMessageOpenApp(RemoteMessage message) async {
    final idRestaurant = message.data['idRestaurant'] ?? "No-data";
    int isLoggedIn = await SharedService.isLoggedIn();
    if (isLoggedIn == -1 || idRestaurant == "No-data") {
      return;
    }
    Restaurant? restaurant = await APIService.getRestaurantById(idRestaurant);
    if (restaurant == null) {
      return;
    }
    _messageStream.add(restaurant);
  }

  static Future<void> _showNotification(
      String title, String body, String idRestaurant) async {
    if (title == "" || body == "") {
      return;
    }
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("FoodHub", "FoodHub_Notifications",
            importance: Importance.max,
            priority: Priority.high,
            playSound: true);

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await _flutterLocalNotificationsPlugin
        .show(1, title, body, notificationDetails, payload: idRestaurant);
  }

  static void _onSelectedNotification(
      NotificationResponse? notification) async {
    if (notification == null) {
      return;
    }
    if (notification.payload != null) {
      int isLoggedIn = await SharedService.isLoggedIn();
      if (isLoggedIn == -1) {
        return;
      }
      Restaurant? restaurant =
          await APIService.getRestaurantById(notification.payload!);
      if (restaurant == null) {
        return;
      }
      _messageStream.add(restaurant);
    }
  }
}
