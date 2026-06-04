class FileSizeFormatter {
  const FileSizeFormatter._();

  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    final kilobytes = bytes / 1024;
    if (kilobytes < 1024) return '${kilobytes.toStringAsFixed(1)} KB';
    final megabytes = kilobytes / 1024;
    if (megabytes < 1024) return '${megabytes.toStringAsFixed(1)} MB';
    final gigabytes = megabytes / 1024;
    return '${gigabytes.toStringAsFixed(1)} GB';
  }
}
