import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tisini/core/storage/secure_storage.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage mockStorage;
  late SecureStorage secureStorage;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    secureStorage = SecureStorage(storage: mockStorage);
  });

  group('SecureStorage', () {
    group('tokens', () {
      test('getAccessToken returns stored value', () async {
        when(
          () => mockStorage.read(key: 'access_token'),
        ).thenAnswer((_) async => 'test_token');

        final result = await secureStorage.getAccessToken();
        expect(result, 'test_token');
      });

      test('getRefreshToken returns stored value', () async {
        when(
          () => mockStorage.read(key: 'refresh_token'),
        ).thenAnswer((_) async => 'refresh_value');

        final result = await secureStorage.getRefreshToken();
        expect(result, 'refresh_value');
      });

      test('saveTokens writes both tokens', () async {
        when(
          () => mockStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async {});

        await secureStorage.saveTokens(
          accessToken: 'access',
          refreshToken: 'refresh',
        );

        verify(
          () => mockStorage.write(key: 'access_token', value: 'access'),
        ).called(1);
        verify(
          () => mockStorage.write(key: 'refresh_token', value: 'refresh'),
        ).called(1);
      });

      test('clearTokens deletes both tokens', () async {
        when(
          () => mockStorage.delete(key: any(named: 'key')),
        ).thenAnswer((_) async {});

        await secureStorage.clearTokens();

        verify(() => mockStorage.delete(key: 'access_token')).called(1);
        verify(() => mockStorage.delete(key: 'refresh_token')).called(1);
      });
    });

    group('biometric', () {
      test('getBiometricEnabled returns true when stored', () async {
        when(
          () => mockStorage.read(key: 'biometric_enabled'),
        ).thenAnswer((_) async => 'true');

        final result = await secureStorage.getBiometricEnabled();
        expect(result, isTrue);
      });

      test('getBiometricEnabled returns false when not stored', () async {
        when(
          () => mockStorage.read(key: 'biometric_enabled'),
        ).thenAnswer((_) async => null);

        final result = await secureStorage.getBiometricEnabled();
        expect(result, isFalse);
      });
    });
  });
}
