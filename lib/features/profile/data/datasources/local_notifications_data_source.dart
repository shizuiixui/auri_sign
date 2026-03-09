import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:auri_sign/features/profile/domain/entities/daily_reminder_schedule.dart';
import 'package:auri_sign/features/profile/domain/entities/schedule_precision.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationsDataSource {
  LocalNotificationsDataSource({required FlutterLocalNotificationsPlugin plugin})
    : _plugin = plugin;

  final FlutterLocalNotificationsPlugin _plugin;
  bool _isInitialized = false;

  Future<void> initialize({required String timezoneName}) async {
    if (_isInitialized) {
      return;
    }

    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(timezoneName));

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _plugin.initialize(initializationSettings);
    _isInitialized = true;
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() {
    return _plugin.pendingNotificationRequests();
  }

  Future<bool> ensureNotificationPermission() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      final enabled = await androidPlugin.areNotificationsEnabled();
      if (enabled ?? false) {
        return true;
      }
      final granted = await androidPlugin.requestNotificationsPermission();
      return granted ?? false;
    }

    final iosPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (iosPlugin != null) {
      final granted = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true;
  }

  Future<SchedulePrecision> resolveSchedulePrecision() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) {
      return SchedulePrecision.exact;
    }

    final canScheduleExact = await androidPlugin.canScheduleExactNotifications();
    if (canScheduleExact ?? false) {
      return SchedulePrecision.exact;
    }

    await androidPlugin.requestExactAlarmsPermission();
    final canScheduleExactAfterRequest =
        await androidPlugin.canScheduleExactNotifications();
    if (canScheduleExactAfterRequest ?? false) {
      return SchedulePrecision.exact;
    }

    return SchedulePrecision.inexact;
  }

  Future<void> scheduleDailyReminder({
    required DailyReminderSchedule schedule,
    required SchedulePrecision precision,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      schedule.hour,
      schedule.minute,
    );

    if (!scheduledDate.isAfter(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final androidScheduleMode = precision == SchedulePrecision.exact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    await _plugin.zonedSchedule(
      schedule.notificationId,
      schedule.title,
      schedule.body,
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          schedule.channelId,
          schedule.channelName,
          channelDescription: schedule.channelDescription,
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: androidScheduleMode,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelNotification({required int notificationId}) {
    return _plugin.cancel(notificationId);
  }
}
