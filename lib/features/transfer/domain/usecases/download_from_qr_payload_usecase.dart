import '../entities/transfer_download_update.dart';
import '../repositories/receiver_transfer_repository.dart';

class DownloadFromQrPayloadUseCase {
  const DownloadFromQrPayloadUseCase(this._repository);

  final ReceiverTransferRepository _repository;

  Stream<TransferDownloadUpdate> call(String rawPayload) {
    return _repository.downloadFromQrPayload(rawPayload);
  }
}
