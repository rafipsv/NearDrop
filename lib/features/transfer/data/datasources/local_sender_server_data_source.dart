import '../../domain/entities/file_item_entity.dart';
import '../../domain/entities/transfer_session_entity.dart';

abstract interface class LocalSenderServerDataSource {
  Future<TransferSessionEntity> start(List<FileItemEntity> files);

  Future<void> stop();
}
