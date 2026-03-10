import 'package:auri_sign/features/profile/domain/entities/daily_reminder_schedule.dart';
import 'package:auri_sign/features/profile/domain/entities/schedule_precision.dart';
import 'package:auri_sign/features/profile/domain/repositories/notification_schedule_repository.dart';

enum SetScheduleStatus {
  enabledExact,
  enabledInexact,
  disabled,
  permissionDenied,
  failed,
  busy,
}

class SetScheduleResult {
  const SetScheduleResult({
    required this.status,
    this.error,
  });

  final SetScheduleStatus status;
  final Object? error;
}

class SetScheduleEnabledUseCase {
  const SetScheduleEnabledUseCase(this._repository);

  final NotificationScheduleRepository _repository;

  Future<SetScheduleResult> call({
    required bool enabled,
    required DailyReminderSchedule schedule,
  }) async {
    try {
      if (!enabled) {
        await _repository.cancelNotification(
          notificationId: schedule.notificationId,
        );
        return const SetScheduleResult(status: SetScheduleStatus.disabled);
      }

      final hasPermission = await _repository.ensureNotificationPermission();
      if (!hasPermission) {
        return const SetScheduleResult(
          status: SetScheduleStatus.permissionDenied,
        );
      }

      final precision = await _repository.resolveSchedulePrecision();
      await _repository.scheduleDailyReminder(
        schedule: schedule,
        precision: precision,
      );

      final status = precision == SchedulePrecision.exact
          ? SetScheduleStatus.enabledExact
          : SetScheduleStatus.enabledInexact;
      return SetScheduleResult(status: status);
    } catch (error) {
      return SetScheduleResult(
        status: SetScheduleStatus.failed,
        error: error,
      );
    }
  }
}
