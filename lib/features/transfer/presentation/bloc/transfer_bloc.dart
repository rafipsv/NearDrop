import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/file_item_entity.dart';
import '../../domain/usecases/download_from_qr_payload_usecase.dart';
import '../../domain/usecases/pick_files_usecase.dart';
import '../../domain/usecases/start_sender_server_usecase.dart';
import '../../domain/usecases/stop_sender_server_usecase.dart';
import '../../domain/value_objects/qr_transfer_payload.dart';
import '../../domain/value_objects/receiver_transfer_exception.dart';
import 'transfer_event.dart';
import 'transfer_state.dart';

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  TransferBloc(
    this._pickFilesUseCase,
    this._startSenderServerUseCase,
    this._stopSenderServerUseCase,
    this._downloadFromQrPayloadUseCase,
  ) : super(const TransferInitial()) {
    on<PickFiles>(_onPickFiles);
    on<FilesPicked>(_onFilesPicked);
    on<RemoveSelectedFile>(_onRemoveSelectedFile);
    on<ClearSelectedFiles>(_onClearSelectedFiles);
    on<StartSenderServer>(_onStartSenderServer);
    on<CreateTransferSession>(
      (event, emit) => emit(TransferReady(session: event.session)),
    );
    on<StartDownload>(
      (event, emit) => emit(TransferReady(session: event.session)),
    );
    on<StartQrDownload>(_onStartQrDownload);
    on<UpdateTransferProgress>(
      (event, emit) => emit(
        state.session == null
            ? TransferFailure(
                'No active transfer session.',
                progress: event.progress,
              )
            : TransferInProgress(
                session: state.session!,
                progress: event.progress,
              ),
      ),
    );
    on<CancelTransfer>(_onCancelTransfer);
    on<RetryTransfer>(_onRetryTransfer);
    on<CompleteTransfer>(_onCompleteTransfer);
    on<FailTransfer>(_onFailTransfer);
  }

  final PickFilesUseCase _pickFilesUseCase;
  final StartSenderServerUseCase _startSenderServerUseCase;
  final StopSenderServerUseCase _stopSenderServerUseCase;
  final DownloadFromQrPayloadUseCase _downloadFromQrPayloadUseCase;

  Future<void> _onPickFiles(
    PickFiles event,
    Emitter<TransferState> emit,
  ) async {
    final wasSharing = state.session != null;
    final currentFiles = state.files;
    if (wasSharing) {
      await _stopSenderServerUseCase();
    }
    emit(FilePicking(files: currentFiles));

    try {
      final pickedFiles = await _pickFilesUseCase(
        allowMultiple: event.allowMultiple,
      );
      if (pickedFiles.isEmpty) {
        emit(
          currentFiles.isEmpty
              ? const TransferInitial()
              : wasSharing
              ? FilesSelected(files: _clearDownloadUrls(currentFiles))
              : FilesSelected(files: currentFiles),
        );
        return;
      }

      add(
        FilesPicked([
          ...wasSharing ? _clearDownloadUrls(currentFiles) : currentFiles,
          ...pickedFiles,
        ]),
      );
    } catch (_) {
      emit(
        TransferFailure(
          'Could not pick files. Please try again.',
          files: wasSharing ? _clearDownloadUrls(currentFiles) : currentFiles,
        ),
      );
    }
  }

  Future<void> _onFilesPicked(
    FilesPicked event,
    Emitter<TransferState> emit,
  ) async {
    if (state.session != null) {
      await _stopSenderServerUseCase();
    }
    emit(FilesSelected(files: _deduplicateFiles(event.files)));
  }

  Future<void> _onRemoveSelectedFile(
    RemoveSelectedFile event,
    Emitter<TransferState> emit,
  ) async {
    if (state.session != null) {
      await _stopSenderServerUseCase();
    }
    final files = state.files
        .where((file) => file.id != event.fileId)
        .map((file) => file.copyWith(downloadUrl: ''))
        .toList(growable: false);

    emit(files.isEmpty ? const TransferInitial() : FilesSelected(files: files));
  }

  Future<void> _onClearSelectedFiles(
    ClearSelectedFiles event,
    Emitter<TransferState> emit,
  ) async {
    await _stopSenderServerUseCase();
    emit(const TransferInitial());
  }

  Future<void> _onStartSenderServer(
    StartSenderServer event,
    Emitter<TransferState> emit,
  ) async {
    final files = state.files;
    if (files.isEmpty) {
      emit(const TransferFailure('Select files before starting sharing.'));
      return;
    }

    emit(SenderServerStarting(files: files));

    try {
      final session = await _startSenderServerUseCase(files);
      emit(TransferReady(session: session));
    } catch (_) {
      emit(
        TransferFailure(
          'Could not start local sharing. Check network access and try again.',
          files: files,
        ),
      );
    }
  }

  Future<void> _onCancelTransfer(
    CancelTransfer event,
    Emitter<TransferState> emit,
  ) async {
    await _stopSenderServerUseCase();
    emit(TransferCancelled(files: state.files, session: state.session));
  }

  Future<void> _onStartQrDownload(
    StartQrDownload event,
    Emitter<TransferState> emit,
  ) async {
    await _stopSenderServerUseCase();
    emit(const ReceiverPreparing());

    try {
      await emit.forEach(
        _downloadFromQrPayloadUseCase(event.rawPayload),
        onData: (update) => update.isComplete
            ? TransferSuccess(session: update.session)
            : TransferInProgress(
                session: update.session,
                progress: update.progress,
              ),
        onError: (error, _) => TransferFailure(
          _downloadErrorMessage(error),
          files: state.files,
          session: state.session,
          progress: state.progress,
        ),
      );
    } catch (error) {
      emit(TransferFailure(_downloadErrorMessage(error)));
    }
  }

  Future<void> _onRetryTransfer(
    RetryTransfer event,
    Emitter<TransferState> emit,
  ) async {
    await _stopSenderServerUseCase();
    emit(const TransferInitial());
  }

  Future<void> _onCompleteTransfer(
    CompleteTransfer event,
    Emitter<TransferState> emit,
  ) async {
    final session = state.session;
    await _stopSenderServerUseCase();
    emit(
      session == null
          ? const TransferInitial()
          : TransferSuccess(session: session),
    );
  }

  Future<void> _onFailTransfer(
    FailTransfer event,
    Emitter<TransferState> emit,
  ) async {
    final files = state.files;
    final session = state.session;
    final progress = state.progress;
    await _stopSenderServerUseCase();
    emit(
      TransferFailure(
        event.message,
        files: files,
        session: session,
        progress: progress,
      ),
    );
  }

  List<FileItemEntity> _deduplicateFiles(List<FileItemEntity> files) {
    final filesById = <String, FileItemEntity>{};
    for (final file in files) {
      filesById[file.id] = file;
    }
    return filesById.values.toList(growable: false);
  }

  List<FileItemEntity> _clearDownloadUrls(List<FileItemEntity> files) {
    return files
        .map((file) => file.copyWith(downloadUrl: ''))
        .toList(growable: false);
  }

  String _downloadErrorMessage(Object error) {
    if (error is QrTransferPayloadException) return error.message;
    if (error is ReceiverTransferException) return error.message;
    return 'Could not receive files from this QR code.';
  }

  @override
  Future<void> close() async {
    await _stopSenderServerUseCase();
    return super.close();
  }
}
