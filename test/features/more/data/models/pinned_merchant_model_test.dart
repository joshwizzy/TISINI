import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/more/data/models/pinned_merchant_model.dart';

void main() {
  group('PinnedMerchantModel', () {
    final json = <String, dynamic>{
      'id': 'm1',
      'name': 'Kampala Supplies',
      'identifier': '+256700111222',
      'role': 'supplier',
      'pinned_at': 1722470400000,
    };

    test('fromJson parses correctly', () {
      final model = PinnedMerchantModel.fromJson(json);
      expect(model.id, 'm1');
      expect(model.name, 'Kampala Supplies');
      expect(model.identifier, '+256700111222');
      expect(model.role, 'supplier');
      expect(model.pinnedAt, 1722470400000);
    });

    test('toJson produces snake_case keys', () {
      final model = PinnedMerchantModel.fromJson(json);
      final output = model.toJson();
      expect(output['pinned_at'], 1722470400000);
    });

    test('toEntity converts correctly', () {
      final model = PinnedMerchantModel.fromJson(json);
      final entity = model.toEntity();
      expect(entity.id, 'm1');
      expect(entity.name, 'Kampala Supplies');
      expect(entity.role, MerchantRole.supplier);
      expect(entity.pinnedAt, isA<DateTime>());
    });

    test('toEntity parses unknown role as supplier', () {
      final unknown = Map<String, dynamic>.from(json)..['role'] = 'unknown';
      final entity = PinnedMerchantModel.fromJson(unknown).toEntity();
      expect(entity.role, MerchantRole.supplier);
    });

    test('round-trip serialization preserves data', () {
      final model = PinnedMerchantModel.fromJson(json);
      final roundTrip = PinnedMerchantModel.fromJson(model.toJson());
      expect(roundTrip, equals(model));
    });
  });
}
