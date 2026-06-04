import '../entities/file_item_entity.dart';
import '../repositories/file_selection_repository.dart';

class PickFilesUseCase {
  const PickFilesUseCase(this._repository);

  final FileSelectionRepository _repository;

  Future<List<FileItemEntity>> call({required bool allowMultiple}) {
    return _repository.pickFiles(allowMultiple: allowMultiple);
  }
}
