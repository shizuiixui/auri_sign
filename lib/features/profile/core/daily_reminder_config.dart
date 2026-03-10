import 'package:auri_sign/features/profile/domain/entities/daily_reminder_schedule.dart';

class DailyReminderConfig {
  static const String timezoneName = 'Asia/Manila';

  static const DailyReminderSchedule schedule = DailyReminderSchedule(
    notificationId: 1,
    title: 'Scheduled title',
    body: 'Daily reminder notification',
    hour: 10,
    minute: 0,
    channelId: 'daily_reminder_channel_id',
    channelName: 'Daily Reminders',
    channelDescription: 'Reminder to complete daily habits',
  );
}
