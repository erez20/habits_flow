import 'domain_error.dart' show DomainError;

sealed class DomainResponse<T> {
  const DomainResponse();

  T? get data;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
  // bool get isLoading => this is Loading<T>;
}

final class Success<T> extends DomainResponse<T> {
  @override
  final T data;

  const Success(this.data);
}

// final class Loading<T> extends DomainResponse<T> {
//   /// The last known data
//   @override
//   final T? data;
//
//   const Loading({this.data});
// }

final class Failure<T> extends DomainResponse<T> {
  final DomainError error;

  /// The last known data
  @override
  final T? data;

  const Failure({required this.error, this.data});
}
