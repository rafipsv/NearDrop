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

  FileItemEntity copyWith({
    String? id,
    String? name,
    String? path,
    int? size,
    String? mimeType,
    String? downloadUrl,
  }) {
    return FileItemEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      size: size ?? this.size,
      mimeType: mimeType ?? this.mimeType,
      downloadUrl: downloadUrl ?? this.downloadUrl,
    );
  }

  @override
  List<Object?> get props => [id, name, path, size, mimeType, downloadUrl];
}
