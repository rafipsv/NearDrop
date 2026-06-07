import '../repositories/sender_server_repository.dart';

class StopSenderServerUseCase {
  const StopSenderServerUseCase(this._repository);

  final SenderServerRepository _repository;

  Future<void> call() {
    return _repository.stopServer();
  }
}
