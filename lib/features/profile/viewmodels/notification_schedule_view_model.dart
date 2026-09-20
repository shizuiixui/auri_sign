import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auri_sign/features/profile/domain/usecases/get_schedule_enabled_usecase.dart';
import 'package:auri_sign/features/profile/domain/usecases/set_schedule_enabled_usecase.dart';
import 'package:auri_sign/features/profile/domain/entities/daily_reminder_schedule.dart';

class NotificationScheduleViewModel extends ChangeNotifier {
  final GetScheduleEnabledUseCase _getScheduleUseCase;
  final SetScheduleEnabledUseCase _setScheduleUseCase;

  static const String _prefKeyDailyReminder = 'daily_practice_reminder_enabled';
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
    ensureScheduleInitialized();
  }

  DailyReminderSchedule? _schedule;
  DailyReminderSchedule? get schedule => _schedule;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> ensureScheduleInitialized() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      // Default to true for daily practice reminders so users stay engaged
      final bool isEnabled = prefs.getBool(_prefKeyDailyReminder) ?? true;

      final isPending = await _getScheduleUseCase.call(
        notificationId: _defaultNotificationId,
      );

      if (isEnabled) {
        _schedule = _defaultSchedule;
        if (!isPending) {
          // Reschedule if not currently registered in OS alarms (e.g. after phone reboot or fresh install)
          debugPrint("⏰ Auto-scheduling daily practice reminder at 8:00 AM...");
          await _setScheduleUseCase.call(
            enabled: true,
            schedule: _defaultSchedule,
          );
        }
        await prefs.setBool(_prefKeyDailyReminder, true);
      } else {
        _schedule = null;
        if (isPending) {
          await _setScheduleUseCase.call(
            enabled: false,
            schedule: _defaultSchedule,
          );
        }
        await prefs.setBool(_prefKeyDailyReminder, false);
      }
    } catch (e) {
      debugPrint("Error initializing notification schedule: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<SetScheduleResult> setScheduleEnabled(bool enabled) async {
    _isLoading = true;
    notifyListeners();

    final result = await _setScheduleUseCase.call(
      enabled: enabled,
      schedule: _defaultSchedule,
    );

    final prefs = await SharedPreferences.getInstance();
    if (result.status == SetScheduleStatus.enabledExact ||
        result.status == SetScheduleStatus.enabledInexact) {
      _schedule = _defaultSchedule;
      await prefs.setBool(_prefKeyDailyReminder, true);
    } else if (result.status == SetScheduleStatus.disabled) {
      _schedule = null;
      await prefs.setBool(_prefKeyDailyReminder, false);
    }

    _isLoading = false;
    notifyListeners();
    return result;
  }
}
