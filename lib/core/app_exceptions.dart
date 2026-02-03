abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class NotFoundException extends AppException {
  const NotFoundException(super.message);
}

class UnexpectedException extends AppException {
  const UnexpectedException(super.message);
}
