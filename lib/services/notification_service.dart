import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// خدمة الإشعارات المحلية (Singleton)
class NotificationService {
  // 1. إنشاء الكائن الوحيد (singleton)
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  // 2. كائن الإشعارات من الحزمة
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // 3. إعداد قناة للأندرويد
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'todo_channel', // معرف القناة
    'Todo Reminders', // اسم القناة للمستخدم
    description: 'تذكيرات مهام التطبيق',
    importance: Importance.max,
  );

  /// 4. دالة التهيئة: timezone + إعداد القناة + initialize plugin
  Future<void> init() async {
    // 4.1 بيانات المناطق الزمنية
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Hebron'));

    // 4.2 تهيئة الإشعارات
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSInit = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iOSInit),
      onDidReceiveNotificationResponse: (details) {
        // عند النقر على الإشعار، يمكن التنقل أو تنفيذ أي منطق هنا
      },
    );

    // 4.3 إنشاء قناة الأندرويد مرة واحدة
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    // 4.4 طلب إذن الإشعارات من المستخدم (لأندرويد 13+)
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  /// 5. جدولة إشعار
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    final tzDate = tz.TZDateTime.from(scheduledDate, tz.local);
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          ticker: 'Todo Reminder',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: '$id',
    );
  }

  /// 6. إلغاء إشعار مجدول
  Future<void> cancelNotification(int id) => _plugin.cancel(id);
}
