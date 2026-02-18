import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tisini/core/constants/api_constants.dart';
import 'package:tisini/core/network/auth_interceptor.dart';
import 'package:tisini/core/network/connectivity_interceptor.dart';
import 'package:tisini/core/network/dio_client.dart';
import 'package:tisini/core/network/error_interceptor.dart';
import 'package:tisini/core/storage/secure_storage.dart';

class MockSecureStorage extends Mock implements SecureStorage {}

void main() {
  late MockSecureStorage mockStorage;
  late DioClient dioClient;

  setUp(() {
    mockStorage = MockSecureStorage();
    dioClient = DioClient(secureStorage: mockStorage);
  });

  group('DioClient', () {
    test('has correct base URL', () {
      expect(dioClient.dio.options.baseUrl, ApiConstants.baseUrl);
    });

    test('has correct timeouts', () {
      expect(dioClient.dio.options.connectTimeout, ApiConstants.connectTimeout);
      expect(dioClient.dio.options.receiveTimeout, ApiConstants.receiveTimeout);
    });

    test('has JSON content headers', () {
      expect(dioClient.dio.options.headers['Content-Type'], 'application/json');
      expect(dioClient.dio.options.headers['Accept'], 'application/json');
    });

    test('has all three interceptors', () {
      final interceptors = dioClient.dio.interceptors;
      expect(interceptors.whereType<ConnectivityInterceptor>(), hasLength(1));
      expect(interceptors.whereType<AuthInterceptor>(), hasLength(1));
      expect(interceptors.whereType<ErrorInterceptor>(), hasLength(1));
    });
  });
}
