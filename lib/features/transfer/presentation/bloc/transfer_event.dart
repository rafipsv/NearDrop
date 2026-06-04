import 'package:equatable/equatable.dart';

import '../../domain/entities/transfer_progress_entity.dart';
import '../../domain/entities/transfer_session_entity.dart';

abstract class TransferEvent extends Equatable {
  const TransferEvent();

  @override
  List<Object?> get props => [];
}

class PickFiles extends TransferEvent {
  const PickFiles();
}

class StartSenderServer extends TransferEvent {
  const StartSenderServer();
}

class CreateTransferSession extends TransferEvent {
  const CreateTransferSession(this.session);

  final TransferSessionEntity session;

  @override
  List<Object?> get props => [session];
}

class StartDownload extends TransferEvent {
  const StartDownload(this.session);

  final TransferSessionEntity session;

  @override
  List<Object?> get props => [session];
}

class UpdateTransferProgress extends TransferEvent {
  const UpdateTransferProgress(this.progress);

  final TransferProgressEntity progress;

  @override
  List<Object?> get props => [progress];
}

class CancelTransfer extends TransferEvent {
  const CancelTransfer();
}

class RetryTransfer extends TransferEvent {
  const RetryTransfer();
}

class CompleteTransfer extends TransferEvent {
  const CompleteTransfer();
}

class FailTransfer extends TransferEvent {
  const FailTransfer(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
