import '../../domain/entities/transfer_download_update.dart';
import '../../domain/repositories/receiver_transfer_repository.dart';
import '../datasources/receiver_transfer_data_source.dart';

class ReceiverTransferRepositoryImpl implements ReceiverTransferRepository {
  const ReceiverTransferRepositoryImpl(this._dataSource);

  final ReceiverTransferDataSource _dataSource;

  @override
  Stream<TransferDownloadUpdate> downloadFromQrPayload(String rawPayload) {
    return _dataSource.downloadFromQrPayload(rawPayload);
  }
}
