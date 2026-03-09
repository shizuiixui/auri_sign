import 'package:flutter/foundation.dart';
import 'package:auri_sign/features/profile/domain/entities/daily_reminder_schedule.dart';
import 'package:auri_sign/features/profile/domain/usecases/get_schedule_enabled_usecase.dart';
import 'package:auri_sign/features/profile/domain/usecases/initialize_notifications_usecase.dart';
import 'package:auri_sign/features/profile/domain/usecases/set_schedule_enabled_usecase.dart';

class NotificationScheduleViewModel extends ChangeNotifier {
  NotificationScheduleViewModel({
    required InitializeNotificationsUseCase initializeNotifications,
    required GetScheduleEnabledUseCase getScheduleEnabled,
    required SetScheduleEnabledUseCase setScheduleEnabled,
    required DailyReminderSchedule schedule,
    required String timezoneName,
  }) : _initializeNotifications = initializeNotifications,
       _getScheduleEnabled = getScheduleEnabled,
       _setScheduleEnabled = setScheduleEnabled,
       _schedule = schedule,
       _timezoneName = timezoneName {
    _initializationFuture = _initialize();
  }

  final InitializeNotificationsUseCase _initializeNotifications;
  final GetScheduleEnabledUseCase _getScheduleEnabled;
  final SetScheduleEnabledUseCase _setScheduleEnabled;
  final DailyReminderSchedule _schedule;
  final String _timezoneName;

  late final Future<void> _initializationFuture;
  bool _isScheduleEnabled = false;
  bool _isUpdatingSchedule = false;

  bool get isScheduleEnabled => _isScheduleEnabled;
  bool get isUpdatingSchedule => _isUpdatingSchedule;

  Future<void> _initialize() async {
    try {
      await _initializeNotifications.call(timezoneName: _timezoneName);
      await refreshScheduleState();
    } catch (error) {
      debugPrint('Notification initialization skipped: $error');
    }
  }

  Future<void> refreshScheduleState() async {
    final isEnabled = await _getScheduleEnabled.call(
      notificationId: _schedule.notificationId,
    );
    _isScheduleEnabled = isEnabled;
    notifyListeners();
  }

  Future<SetScheduleResult> setScheduleEnabled(bool enabled) async {
    if (_isUpdatingSchedule) {
      return const SetScheduleResult(status: SetScheduleStatus.busy);
    }

    _isUpdatingSchedule = true;
    notifyListeners();

    try {
      await _initializationFuture;
      final result = await _setScheduleEnabled.call(
        enabled: enabled,
        schedule: _schedule,
      );

      if (result.status == SetScheduleStatus.permissionDenied) {
        _isScheduleEnabled = false;
      } else if (result.status == SetScheduleStatus.enabledExact ||
          result.status == SetScheduleStatus.enabledInexact ||
          result.status == SetScheduleStatus.disabled) {
        _isScheduleEnabled = enabled;
      }

      return result;
    } finally {
      _isUpdatingSchedule = false;
      notifyListeners();
    }
  }
}