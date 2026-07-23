abstract class StreamUseCase<T> {
  Stream<T> get listen;
}