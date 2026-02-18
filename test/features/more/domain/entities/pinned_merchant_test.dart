import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/more/domain/entities/pinned_merchant.dart';

void main() {
  group('PinnedMerchant', () {
    final pinnedAt = DateTime(2025, 8);

    test('creates with required fields', () {
      final merchant = PinnedMerchant(
        id: 'm1',
        name: 'Kampala Supplies',
        identifier: '+256700111222',
        role: MerchantRole.supplier,
        pinnedAt: pinnedAt,
      );

      expect(merchant.id, 'm1');
      expect(merchant.name, 'Kampala Supplies');
      expect(merchant.identifier, '+256700111222');
      expect(merchant.role, MerchantRole.supplier);
      expect(merchant.pinnedAt, pinnedAt);
    });

    test('supports value equality', () {
      final a = PinnedMerchant(
        id: 'm1',
        name: 'Kampala Supplies',
        identifier: '+256700111222',
        role: MerchantRole.supplier,
        pinnedAt: pinnedAt,
      );
      final b = PinnedMerchant(
        id: 'm1',
        name: 'Kampala Supplies',
        identifier: '+256700111222',
        role: MerchantRole.supplier,
        pinnedAt: pinnedAt,
      );

      expect(a, equals(b));
    });

    test('supports copyWith for role change', () {
      final merchant = PinnedMerchant(
        id: 'm1',
        name: 'Kampala Supplies',
        identifier: '+256700111222',
        role: MerchantRole.supplier,
        pinnedAt: pinnedAt,
      );

      final updated = merchant.copyWith(role: MerchantRole.rent);

      expect(updated.role, MerchantRole.rent);
      expect(updated.name, 'Kampala Supplies');
    });
  });
}
