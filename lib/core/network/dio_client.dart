import 'package:dio/dio.dart';
import 'package:tisini/core/constants/api_constants.dart';
import 'package:tisini/core/network/auth_interceptor.dart';
import 'package:tisini/core/network/connectivity_interceptor.dart';
import 'package:tisini/core/network/error_interceptor.dart';
import 'package:tisini/core/storage/secure_storage.dart';

class DioClient {
  DioClient({required SecureStorage secureStorage}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      ConnectivityInterceptor(),
      AuthInterceptor(storage: secureStorage, dio: _dio),
      ErrorInterceptor(),
    ]);
  }

  late final Dio _dio;

  Dio get dio => _dio;
}
