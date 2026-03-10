import 'package:flutter/material.dart';
import 'package:auri_sign/features/profile/domain/usecases/get_schedule_enabled_usecase.dart';
import 'package:auri_sign/features/profile/domain/usecases/set_schedule_enabled_usecase.dart';
import 'package:auri_sign/features/profile/domain/entities/daily_reminder_schedule.dart';

class NotificationScheduleViewModel extends ChangeNotifier {
  final GetScheduleEnabledUseCase _getScheduleUseCase;
  final SetScheduleEnabledUseCase _setScheduleUseCase;

  static const int _defaultNotificationId = 1001;
  final DailyReminderSchedule _defaultSchedule = DailyReminderSchedule(
    notificationId: _defaultNotificationId,
    title: 'Time to Practice AuriSign!',
    body: 'Keep your streak alive. Jump in for a quick sign language lesson.',
    hour: 8,
    minute: 0,
    channelId: 'auri_daily_reminders',
    channelName: 'Daily Reminders',
    channelDescription: 'Reminders to practice daily',
  );

  NotificationScheduleViewModel({
    required GetScheduleEnabledUseCase getScheduleUseCase,
    required SetScheduleEnabledUseCase setScheduleUseCase,
  }) : _getScheduleUseCase = getScheduleUseCase,
       _setScheduleUseCase = setScheduleUseCase {
    _loadCurrentSchedule();
  }

  DailyReminderSchedule? _schedule;
  DailyReminderSchedule? get schedule => _schedule;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> _loadCurrentSchedule() async {
    _isLoading = true;
    notifyListeners();

    final isPending = await _getScheduleUseCase.call(
      notificationId: _defaultNotificationId,
    );

    if (isPending) {
      _schedule = _defaultSchedule;
    } else {
      _schedule = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<SetScheduleResult> setScheduleEnabled(bool enabled) async {
    final result = await _setScheduleUseCase.call(
      enabled: enabled,
      schedule: _defaultSchedule,
    );

    if (result.status == SetScheduleStatus.enabledExact ||
        result.status == SetScheduleStatus.enabledInexact) {
      _schedule = _defaultSchedule;
    } else {
      _schedule = null;
    }

    notifyListeners();
    return result;
  }
}
