import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/auth/data/models/auth_token_model.dart';

void main() {
  group('AuthTokenModel', () {
    final json = {
      'access_token': 'access-123',
      'refresh_token': 'refresh-456',
      'expires_at': 1740000000000,
    };

    test('fromJson creates model from snake_case JSON', () {
      final model = AuthTokenModel.fromJson(json);
      expect(model.accessToken, 'access-123');
      expect(model.refreshToken, 'refresh-456');
      expect(model.expiresAt, 1740000000000);
    });

    test('toJson produces snake_case JSON', () {
      const model = AuthTokenModel(
        accessToken: 'access-123',
        refreshToken: 'refresh-456',
        expiresAt: 1740000000000,
      );
      final result = model.toJson();
      expect(result['access_token'], 'access-123');
      expect(result['refresh_token'], 'refresh-456');
      expect(result['expires_at'], 1740000000000);
    });

    test('JSON round-trip preserves data', () {
      const original = AuthTokenModel(
        accessToken: 'access-123',
        refreshToken: 'refresh-456',
        expiresAt: 1740000000000,
      );
      final roundTripped = AuthTokenModel.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });

    test('toEntity converts correctly', () {
      const model = AuthTokenModel(
        accessToken: 'access-123',
        refreshToken: 'refresh-456',
        expiresAt: 1740000000000,
      );
      final entity = model.toEntity();
      expect(entity.accessToken, 'access-123');
      expect(entity.refreshToken, 'refresh-456');
      expect(
        entity.expiresAt,
        DateTime.fromMillisecondsSinceEpoch(1740000000000),
      );
    });
  });
}
