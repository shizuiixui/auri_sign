import 'package:auri_sign/features/profile/domain/entities/daily_reminder_schedule.dart';
import 'package:auri_sign/features/profile/domain/entities/schedule_precision.dart';

abstract class NotificationScheduleRepository {
  Future<void> initialize({required String timezoneName});

  Future<bool> hasPendingNotification({required int notificationId});

  Future<bool> ensureNotificationPermission();

  Future<SchedulePrecision> resolveSchedulePrecision();

  Future<void> scheduleDailyReminder({
    required DailyReminderSchedule schedule,
    required SchedulePrecision precision,
  });

  Future<void> cancelNotification({required int notificationId});
}
