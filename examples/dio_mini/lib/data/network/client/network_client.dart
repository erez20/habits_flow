import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@LazySingleton()
class NetworkClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://693a8b449b80ba7262ca5bf6.mockapi.io',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ),
  );

  NetworkClient() {
    // 1. Add the Interceptor to the Dio instance
    _dio.interceptors.addAll([
      _mockDelayInterceptor(),
      _prettyDioLoggerInterceptor(),
    ]);
  }

  Interceptor _mockDelayInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        await Future.delayed(const Duration(seconds: 1));
        return handler.next(options); // continue the request
      },
    );
  }

  PrettyDioLogger _prettyDioLoggerInterceptor() {
    return PrettyDioLogger(
      requestHeader: true,
      // Show headers in the log
      requestBody: true,
      // Show the request data (if present)
      responseBody: true,
      // Show the response body (important for seeing API data)
      responseHeader: false,
      // Don't show response headers (usually unnecessary)
      error: true,
      // Log errors
      compact: false,
      // Print log in a nicely formatted, non-compact way
      maxWidth: 80, // Set the maximum width of the log line
    );
  }

  Dio get dio => _dio;
}
