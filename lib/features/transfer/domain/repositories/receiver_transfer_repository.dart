import '../entities/transfer_download_update.dart';

abstract interface class ReceiverTransferRepository {
  Stream<TransferDownloadUpdate> downloadFromQrPayload(String rawPayload);
}
