import 'package:equatable/equatable.dart';

class FileItemEntity extends Equatable {
  const FileItemEntity({
    required this.id,
    required this.name,
    required this.path,
    required this.size,
    required this.mimeType,
    required this.downloadUrl,
  });

  final String id;
  final String name;
  final String path;
  final int size;
  final String mimeType;
  final String downloadUrl;

  @override
  List<Object?> get props => [id, name, path, size, mimeType, downloadUrl];
}
