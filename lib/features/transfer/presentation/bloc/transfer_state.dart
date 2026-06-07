import 'package:equatable/equatable.dart';

import '../../domain/entities/file_item_entity.dart';
import '../../domain/entities/transfer_progress_entity.dart';
import '../../domain/entities/transfer_session_entity.dart';

abstract class TransferState extends Equatable {
  const TransferState({this.files = const [], this.session, this.progress});

  final List<FileItemEntity> files;
  final TransferSessionEntity? session;
  final TransferProgressEntity? progress;

  @override
  List<Object?> get props => [files, session, progress];
}

class TransferInitial extends TransferState {
  const TransferInitial();
}

class FilePicking extends TransferState {
  const FilePicking({super.files});
}

class FilesSelected extends TransferState {
  const FilesSelected({required super.files});
}

class SenderServerRunning extends TransferState {
  const SenderServerRunning({required super.files});
}

class SenderServerStarting extends TransferState {
  const SenderServerStarting({required super.files});
}

class TransferReady extends TransferState {
  TransferReady({required TransferSessionEntity session})
    : super(session: session, files: session.files);
}

class TransferInProgress extends TransferState {
  TransferInProgress({
    required TransferSessionEntity session,
    required TransferProgressEntity progress,
  }) : super(session: session, progress: progress, files: session.files);
}

class TransferSuccess extends TransferState {
  TransferSuccess({required TransferSessionEntity session})
    : super(session: session, files: session.files);
}

class TransferFailure extends TransferState {
  const TransferFailure(
    this.message, {
    super.files,
    super.session,
    super.progress,
  });

  final String message;

  @override
  List<Object?> get props => [...super.props, message];
}

class TransferCancelled extends TransferState {
  const TransferCancelled({super.files, super.session});
}
