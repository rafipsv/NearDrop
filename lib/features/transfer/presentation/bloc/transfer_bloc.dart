import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/file_item_entity.dart';
import '../../domain/usecases/pick_files_usecase.dart';
import 'transfer_event.dart';
import 'transfer_state.dart';

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  TransferBloc(this._pickFilesUseCase) : super(const TransferInitial()) {
    on<PickFiles>(_onPickFiles);
    on<FilesPicked>(_onFilesPicked);
    on<RemoveSelectedFile>(_onRemoveSelectedFile);
    on<ClearSelectedFiles>(_onClearSelectedFiles);
    on<StartSenderServer>(
      (event, emit) => emit(SenderServerRunning(files: state.files)),
    );
    on<CreateTransferSession>(
      (event, emit) => emit(TransferReady(session: event.session)),
    );
    on<StartDownload>(
      (event, emit) => emit(TransferReady(session: event.session)),
    );
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
    on<CancelTransfer>(
      (event, emit) =>
          emit(TransferCancelled(files: state.files, session: state.session)),
    );
    on<RetryTransfer>((event, emit) => emit(const TransferInitial()));
    on<CompleteTransfer>(
      (event, emit) => state.session == null
          ? emit(const TransferInitial())
          : emit(TransferSuccess(session: state.session!)),
    );
    on<FailTransfer>(
      (event, emit) => emit(
        TransferFailure(
          event.message,
          files: state.files,
          session: state.session,
          progress: state.progress,
        ),
      ),
    );
  }

  final PickFilesUseCase _pickFilesUseCase;

  Future<void> _onPickFiles(
    PickFiles event,
    Emitter<TransferState> emit,
  ) async {
    final currentFiles = state.files;
    emit(FilePicking(files: currentFiles));

    try {
      final pickedFiles = await _pickFilesUseCase(
        allowMultiple: event.allowMultiple,
      );
      if (pickedFiles.isEmpty) {
        emit(
          currentFiles.isEmpty
              ? const TransferInitial()
              : FilesSelected(files: currentFiles),
        );
        return;
      }

      add(FilesPicked([...currentFiles, ...pickedFiles]));
    } catch (_) {
      emit(
        TransferFailure(
          'Could not pick files. Please try again.',
          files: currentFiles,
        ),
      );
    }
  }

  void _onFilesPicked(FilesPicked event, Emitter<TransferState> emit) {
    emit(FilesSelected(files: _deduplicateFiles(event.files)));
  }

  void _onRemoveSelectedFile(
    RemoveSelectedFile event,
    Emitter<TransferState> emit,
  ) {
    final files = state.files
        .where((file) => file.id != event.fileId)
        .toList(growable: false);

    emit(files.isEmpty ? const TransferInitial() : FilesSelected(files: files));
  }

  void _onClearSelectedFiles(
    ClearSelectedFiles event,
    Emitter<TransferState> emit,
  ) {
    emit(const TransferInitial());
  }

  List<FileItemEntity> _deduplicateFiles(List<FileItemEntity> files) {
    final filesById = <String, FileItemEntity>{};
    for (final file in files) {
      filesById[file.id] = file;
    }
    return filesById.values.toList(growable: false);
  }
}
