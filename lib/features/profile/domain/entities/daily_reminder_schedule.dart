class DailyReminderSchedule {
  const DailyReminderSchedule({
    required this.notificationId,
    required this.title,
    required this.body,
    required this.hour,
    required this.minute,
    required this.channelId,
    required this.channelName,
    required this.channelDescription,
  });

  final int notificationId;
  final String title;
  final String body;
  final int hour;
  final int minute;
  final String channelId;
  final String channelName;
  final String channelDescription;
}
