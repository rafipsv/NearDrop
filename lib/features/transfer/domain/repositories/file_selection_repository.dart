import '../entities/file_item_entity.dart';

abstract interface class FileSelectionRepository {
  Future<List<FileItemEntity>> pickFiles({required bool allowMultiple});
}
