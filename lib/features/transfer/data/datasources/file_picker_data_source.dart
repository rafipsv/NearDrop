import 'package:file_picker/file_picker.dart';

abstract interface class FilePickerDataSource {
  Future<List<PlatformFile>> pickFiles({required bool allowMultiple});
}
