import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';

import '../../domain/entities/file_item_entity.dart';
import '../../domain/repositories/file_selection_repository.dart';
import '../datasources/file_picker_data_source.dart';

class FileSelectionRepositoryImpl implements FileSelectionRepository {
  const FileSelectionRepositoryImpl(this._dataSource);

  final FilePickerDataSource _dataSource;

  @override
  Future<List<FileItemEntity>> pickFiles({required bool allowMultiple}) async {
    final pickedFiles = await _dataSource.pickFiles(
      allowMultiple: allowMultiple,
    );

    return pickedFiles
        .where((file) => file.path != null)
        .map(_mapPlatformFile)
        .toList(growable: false);
  }

  FileItemEntity _mapPlatformFile(PlatformFile file) {
    final path = file.path!;
    final mimeType = lookupMimeType(path) ?? 'application/octet-stream';

    return FileItemEntity(
      id: '$path-${file.size}',
      name: file.name,
      path: path,
      size: file.size,
      mimeType: mimeType,
      downloadUrl: '',
    );
  }
}
