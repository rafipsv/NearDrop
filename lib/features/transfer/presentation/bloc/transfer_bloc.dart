import 'package:flutter_bloc/flutter_bloc.dart';

import 'transfer_event.dart';
import 'transfer_state.dart';

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  TransferBloc() : super(const TransferInitial()) {
    on<PickFiles>((event, emit) => emit(const FilePicking()));
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
}
