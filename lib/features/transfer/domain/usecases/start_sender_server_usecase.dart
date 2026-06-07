import '../entities/file_item_entity.dart';
import '../entities/transfer_session_entity.dart';
import '../repositories/sender_server_repository.dart';

class StartSenderServerUseCase {
  const StartSenderServerUseCase(this._repository);

  final SenderServerRepository _repository;

  Future<TransferSessionEntity> call(List<FileItemEntity> files) {
    return _repository.startServer(files);
  }
}
