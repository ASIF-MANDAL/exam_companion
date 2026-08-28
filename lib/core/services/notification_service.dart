import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(
      android: androidSettings,
    );

    await _plugin.initialize(
      settings: settings,
    );

    final androidPlugin =
    _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();
  }

  static Future<void> scheduleExamReminder({
    required String examId,
    required String subject,
    required DateTime examDate,
  }) async {
    final reminderDate = DateTime(
      examDate.year,
      examDate.month,
      examDate.day - 1,
      7,
      0,
    );

    if (reminderDate.isBefore(DateTime.now())) {
      return;
    }

    final notificationId =
    examId.hashCode & 0x7fffffff;

    final scheduledDate = tz.TZDateTime.from(
      reminderDate,
      tz.local,
    );

    await _plugin.zonedSchedule(
      id: notificationId,
      title: 'Exam Reminder',
      body: '$subject exam is tomorrow',
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'exam_reminders',
          'Exam Reminders',
          channelDescription:
          'Notifications for upcoming exams',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode:
      AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  static Future<void> cancelExamReminder(
      String examId,
      ) async {
    final notificationId =
    examId.hashCode & 0x7fffffff;

    await _plugin.cancel(
      id: notificationId,
    );
  }
}