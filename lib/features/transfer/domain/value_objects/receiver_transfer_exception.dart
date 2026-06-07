class ReceiverTransferException implements Exception {
  const ReceiverTransferException(this.message);

  final String message;

  @override
  String toString() => message;
}
