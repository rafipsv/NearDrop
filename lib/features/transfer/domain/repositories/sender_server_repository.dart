import '../entities/file_item_entity.dart';
import '../entities/transfer_session_entity.dart';

abstract interface class SenderServerRepository {
  Future<TransferSessionEntity> startServer(List<FileItemEntity> files);

  Future<void> stopServer();
}
