import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chit_chat/home/navigation_service.dart';
import 'package:flutter_chit_chat/locator.dart';
import 'package:flutter_chit_chat/pending_navigation.dart';
import 'package:flutter_chit_chat/services/firestore_db_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.data.isNotEmpty) {
    // Handle data message
    final dynamic data = message.data;
    print("Arka planda gelen data: ${data.toString()}");
    NotificationHandler.instance._showLocalNotification(message);
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  if (response.payload == null) return;

  final data =
  Map<String, dynamic>.from(jsonDecode(response.payload!));

  // Save for later — DO NOT navigate here
  PendingNavigation.instance.save(data);
}

class NotificationHandler {
  NotificationHandler._();

  static final NotificationHandler instance = NotificationHandler._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirestoreDBService _firebaseFirestore = locator<FirestoreDBService>();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'fcm_channel',
    'FCM Notifications',
    description: 'Used for FCM notifications',
    importance: Importance.high,
  );

  void _onNotificationTapped(Map<String, dynamic> data) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // 🚨 cannot navigate yet
      PendingNavigation.instance.save(data);
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      NavigationService.instance.push('/chat', args: data);
    });
  }

  /// Call this ONCE at app startup
  Future<void> init() async {
    await _requestPermission();
    await _initLocalNotifications();
    await _configureFirebaseListeners();
    await _logToken();
    await _saveTokenIfNeeded();
  }

  // ---------------------------------------------------------------------------
  // Permissions
  // ---------------------------------------------------------------------------
  Future<void> _requestPermission() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    // iOS foreground display
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('ic_stat_notify');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(settings, onDidReceiveNotificationResponse: (response){
      _onNotificationTapped(Map<String, dynamic>.from(jsonDecode(response.payload!)));
    }, onDidReceiveBackgroundNotificationResponse: notificationTapBackground);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;
    if(FirebaseAuth.instance.currentUser == null) return;

    var userURLPath = await _downloadImage(message.data["profile_url"]);

    _localNotifications.show(
      message.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'fcm_channel',
          'FCM Notifications',
          importance: Importance.max,
          priority: Priority.high,
          category: AndroidNotificationCategory.message,
          // 👇 THIS is the key
          largeIcon: userURLPath != null
              ? FilePathAndroidBitmap(userURLPath)
              : null,

          // 👇 Keep notification compact
          styleInformation: const DefaultStyleInformation(true, true),
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  // ---------------------------------------------------------------------------
  // Firebase listeners
  // ---------------------------------------------------------------------------
  Future<void> _configureFirebaseListeners() async {
    //await _messaging.subscribeToTopic("mesaj");
    // Foreground
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('FCM Foreground: ${message.data}');
      _showLocalNotification(message);
    });

    // App opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('FCM Clicked: ${message.data}');
      _onNotificationTapped(message.data);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    final message =
    await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onNotificationTapped(message.data);
      });
    }
  }

  // ---------------------------------------------------------------------------
  // Token handling
  // ---------------------------------------------------------------------------
  Future<void> _logToken() async {
    final token = await _messaging.getToken();
    debugPrint('FCM Token: $token');

    _messaging.onTokenRefresh.listen((newToken) async {
      debugPrint('FCM Token refreshed: $newToken');
      // saveTokenToBackend(newToken);
      User? _currentUser = await FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.doc('tokens/${_currentUser?.uid}').set({
        'token': newToken,
      });
    });
  }

  Future<void> _saveTokenIfNeeded() async {
    final token = await _messaging.getToken();
    if (token == null) return;
    User? _currentUser = await FirebaseAuth.instance.currentUser;
    await _firebaseFirestore.saveToken(_currentUser!.uid, token);
  }

  Future<String?> _downloadImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/profile.jpg';

      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      return filePath;
    } catch (e) {
      return null;
    }
  }
}
