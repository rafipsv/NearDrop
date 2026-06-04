import 'package:file_picker/file_picker.dart';

import 'file_picker_data_source.dart';

class FilePickerDataSourceImpl implements FilePickerDataSource {
  const FilePickerDataSourceImpl();

  @override
  Future<List<PlatformFile>> pickFiles({required bool allowMultiple}) async {
    final result = await FilePicker.pickFiles(
      allowMultiple: allowMultiple,
      withData: false,
      withReadStream: false,
    );

    return result?.files ?? const [];
  }
}
