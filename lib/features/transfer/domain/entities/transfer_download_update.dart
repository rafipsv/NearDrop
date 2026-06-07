import 'package:equatable/equatable.dart';

import 'transfer_progress_entity.dart';
import 'transfer_session_entity.dart';

class TransferDownloadUpdate extends Equatable {
  const TransferDownloadUpdate({
    required this.session,
    required this.progress,
    this.isComplete = false,
  });

  final TransferSessionEntity session;
  final TransferProgressEntity progress;
  final bool isComplete;

  @override
  List<Object?> get props => [session, progress, isComplete];
}
