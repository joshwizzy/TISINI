import 'package:dio/dio.dart';
import 'package:tisini/core/errors/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = _mapException(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: exception,
      ),
    );
  }

  AppException _mapException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();
      case DioExceptionType.connectionError:
        return const NoConnectionException();
      case DioExceptionType.badResponse:
        return _mapStatusCode(err);
      case DioExceptionType.cancel:
        return const NetworkException('Request cancelled', code: 'CANCELLED');
      case DioExceptionType.badCertificate:
        return const NetworkException(
          'Certificate error',
          code: 'BAD_CERTIFICATE',
        );
      case DioExceptionType.unknown:
        return NetworkException(
          err.message ?? 'Unknown network error',
          code: 'UNKNOWN',
        );
    }
  }

  AppException _mapStatusCode(DioException err) {
    final statusCode = err.response?.statusCode ?? 0;
    final data = err.response?.data;
    final message = data is Map<String, dynamic>
        ? (data['message'] as String?) ?? 'Server error'
        : 'Server error';
    final code = data is Map<String, dynamic> ? data['code'] as String? : null;

    return ServerException(message, statusCode: statusCode, code: code);
  }
}
