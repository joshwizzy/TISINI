import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tisini/core/network/auth_interceptor.dart';
import 'package:tisini/core/storage/secure_storage.dart';

class MockSecureStorage extends Mock implements SecureStorage {}

void main() {
  late MockSecureStorage mockStorage;
  late Dio dio;
  late AuthInterceptor interceptor;

  setUp(() {
    mockStorage = MockSecureStorage();
    dio = Dio(BaseOptions(baseUrl: 'https://api.test.com'));
    interceptor = AuthInterceptor(storage: mockStorage, dio: dio);
  });

  group('AuthInterceptor', () {
    test('attaches token to request headers', () async {
      when(
        () => mockStorage.getAccessToken(),
      ).thenAnswer((_) async => 'test_token');

      final options = RequestOptions(path: '/test');
      final handler = RequestInterceptorHandler();

      await interceptor.onRequest(options, handler);

      expect(options.headers['Authorization'], 'Bearer test_token');
    });

    test('does not attach token when null', () async {
      when(() => mockStorage.getAccessToken()).thenAnswer((_) async => null);

      final options = RequestOptions(path: '/test');
      final handler = RequestInterceptorHandler();

      await interceptor.onRequest(options, handler);

      expect(options.headers['Authorization'], isNull);
    });
  });
}
