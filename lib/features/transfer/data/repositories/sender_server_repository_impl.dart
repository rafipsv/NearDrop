import '../../domain/entities/file_item_entity.dart';
import '../../domain/entities/transfer_session_entity.dart';
import '../../domain/repositories/sender_server_repository.dart';
import '../datasources/local_sender_server_data_source.dart';

class SenderServerRepositoryImpl implements SenderServerRepository {
  const SenderServerRepositoryImpl(this._dataSource);

  final LocalSenderServerDataSource _dataSource;

  @override
  Future<TransferSessionEntity> startServer(List<FileItemEntity> files) {
    return _dataSource.start(files);
  }

  @override
  Future<void> stopServer() {
    return _dataSource.stop();
  }
}
