enum LoadingState {
  init,
  success,
  error,
  loading;

  bool get isError => this == error;
  bool get isSuccess => this == success;
  bool get isLoading => this == loading;
  bool get isInit => this == init;

}
