import 'package:auri_sign/features/profile/domain/repositories/notification_schedule_repository.dart';

class InitializeNotificationsUseCase {
  const InitializeNotificationsUseCase(this._repository);

  final NotificationScheduleRepository _repository;

  Future<void> call({required String timezoneName}) {
    return _repository.initialize(timezoneName: timezoneName);
  }
}
