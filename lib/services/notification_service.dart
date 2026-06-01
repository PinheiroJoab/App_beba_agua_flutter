import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'dart:async';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> inicializar() async {
    tz.initializeTimeZones();

    try {
      final dynamic localTimezone = await FlutterTimezone.getLocalTimezone();
      final String timeZoneName = localTimezone.toString();

      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);

    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }
  }

  static Future<void> dispararTesteInstantaneo() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'canal_teste',
          'Testes',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        );

    await _notificationsPlugin.show(
      99,
      'Está na Hora! 🌊',
      'Vamos lá, hora de se hidratar!',
      const NotificationDetails(android: androidDetails),
    );
  }

  static Future<void> cancelarTodosOsAlarmes() async {
    await _notificationsPlugin.cancelAll();
  }
}
