sealed class DomainError {
  const DomainError();

}

final class NetworkError extends DomainError {
  final int? httpCode;
  const NetworkError(this.httpCode);

  @override
  String toString() => 'NetworkError(httpCode: $httpCode)';
}

final class DatabaseError extends DomainError {
  final String? message;
  const DatabaseError({this.message});

  @override
  String toString() => 'DatabaseError (message: $message)';
}

final class UnknownError extends DomainError {
  final String message;
  const UnknownError(this.message);

  @override
  String toString() => 'UnknownError(message: $message)';
}
