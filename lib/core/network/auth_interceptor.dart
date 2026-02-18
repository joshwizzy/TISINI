import 'package:dio/dio.dart';
import 'package:tisini/core/storage/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({required SecureStorage storage, required Dio dio})
    : _storage = storage,
      _dio = dio;

  final SecureStorage _storage;
  final Dio _dio;
  bool _isRefreshing = false;
  final _pendingRequests =
      <({RequestOptions options, ErrorInterceptorHandler handler})>[];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    if (_isRefreshing) {
      _pendingRequests.add((options: err.requestOptions, handler: handler));
      return;
    }

    _isRefreshing = true;

    try {
      final refreshToken = await _storage.getRefreshToken();
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/token/refresh',
        data: {'refresh_token': refreshToken},
      );

      final data = response.data?['data'] as Map<String, dynamic>?;
      final newAccessToken = data?['access_token'] as String? ?? '';
      final newRefreshToken = data?['refresh_token'] as String? ?? '';

      await _storage.saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );

      // Retry original request
      err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
      final retryResponse = await _dio.fetch<dynamic>(err.requestOptions);
      handler.resolve(retryResponse);

      // Retry queued requests
      for (final pending in _pendingRequests) {
        pending.options.headers['Authorization'] = 'Bearer $newAccessToken';
        final retryResp = await _dio.fetch<dynamic>(pending.options);
        pending.handler.resolve(retryResp);
      }
    } catch (e) {
      await _storage.clearTokens();
      handler.reject(err);
      for (final pending in _pendingRequests) {
        pending.handler.reject(err);
      }
    } finally {
      _pendingRequests.clear();
      _isRefreshing = false;
    }
  }
}
