import 'package:auri_sign/features/profile/domain/repositories/notification_schedule_repository.dart';

class GetScheduleEnabledUseCase {
  const GetScheduleEnabledUseCase(this._repository);

  final NotificationScheduleRepository _repository;

  Future<bool> call({required int notificationId}) {
    return _repository.hasPendingNotification(notificationId: notificationId);
  }
}
