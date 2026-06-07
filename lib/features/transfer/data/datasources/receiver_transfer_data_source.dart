import '../../domain/entities/transfer_download_update.dart';

abstract interface class ReceiverTransferDataSource {
  Stream<TransferDownloadUpdate> downloadFromQrPayload(String rawPayload);
}
