import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/more/data/models/connected_account_model.dart';

void main() {
  group('ConnectedAccountModel', () {
    final json = <String, dynamic>{
      'id': 'acc1',
      'provider': 'mtn',
      'identifier': '+256770555123',
      'connected_at': 1718409600000,
    };

    test('fromJson parses correctly', () {
      final model = ConnectedAccountModel.fromJson(json);
      expect(model.id, 'acc1');
      expect(model.provider, 'mtn');
      expect(model.identifier, '+256770555123');
      expect(model.connectedAt, 1718409600000);
    });

    test('toJson produces snake_case keys', () {
      final model = ConnectedAccountModel.fromJson(json);
      final output = model.toJson();
      expect(output['connected_at'], 1718409600000);
    });

    test('toEntity converts correctly', () {
      final model = ConnectedAccountModel.fromJson(json);
      final entity = model.toEntity();
      expect(entity.id, 'acc1');
      expect(entity.provider, AccountProvider.mtn);
      expect(entity.identifier, '+256770555123');
      expect(entity.connectedAt, isA<DateTime>());
    });

    test('toEntity parses unknown provider as mtn', () {
      final unknown = Map<String, dynamic>.from(json)..['provider'] = 'unknown';
      final entity = ConnectedAccountModel.fromJson(unknown).toEntity();
      expect(entity.provider, AccountProvider.mtn);
    });

    test('round-trip serialization preserves data', () {
      final model = ConnectedAccountModel.fromJson(json);
      final roundTrip = ConnectedAccountModel.fromJson(model.toJson());
      expect(roundTrip, equals(model));
    });
  });
}
