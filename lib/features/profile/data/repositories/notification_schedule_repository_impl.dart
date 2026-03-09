import 'package:auri_sign/features/profile/data/datasources/local_notifications_data_source.dart';
import 'package:auri_sign/features/profile/domain/entities/daily_reminder_schedule.dart';
import 'package:auri_sign/features/profile/domain/entities/schedule_precision.dart';
import 'package:auri_sign/features/profile/domain/repositories/notification_schedule_repository.dart';

class NotificationScheduleRepositoryImpl
    implements NotificationScheduleRepository {
  const NotificationScheduleRepositoryImpl({
    required LocalNotificationsDataSource dataSource,
  }) : _dataSource = dataSource;

  final LocalNotificationsDataSource _dataSource;

  @override
  Future<void> initialize({required String timezoneName}) {
    return _dataSource.initialize(timezoneName: timezoneName);
  }

  @override
  Future<bool> hasPendingNotification({required int notificationId}) async {
    final pending = await _dataSource.getPendingNotifications();
    return pending.any((item) => item.id == notificationId);
  }

  @override
  Future<bool> ensureNotificationPermission() {
    return _dataSource.ensureNotificationPermission();
  }

  @override
  Future<SchedulePrecision> resolveSchedulePrecision() {
    return _dataSource.resolveSchedulePrecision();
  }

  @override
  Future<void> scheduleDailyReminder({
    required DailyReminderSchedule schedule,
    required SchedulePrecision precision,
  }) {
    return _dataSource.scheduleDailyReminder(
      schedule: schedule,
      precision: precision,
    );
  }

  @override
  Future<void> cancelNotification({required int notificationId}) {
    return _dataSource.cancelNotification(notificationId: notificationId);
  }
}
