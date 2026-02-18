import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/more/domain/entities/pinned_merchant.dart';
import 'package:tisini/features/more/presentation/widgets/merchant_tile.dart';

void main() {
  final merchant = PinnedMerchant(
    id: 'm1',
    name: 'Kampala Supplies',
    identifier: '+256700111222',
    role: MerchantRole.supplier,
    pinnedAt: DateTime(2025, 5, 10),
  );

  group('MerchantTile', () {
    testWidgets('displays name and identifier', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: MerchantTile(merchant: merchant)),
        ),
      );

      expect(find.text('Kampala Supplies'), findsOneWidget);
      expect(find.text('+256700111222'), findsOneWidget);
    });

    testWidgets('displays role chip', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: MerchantTile(merchant: merchant)),
        ),
      );

      expect(find.text('Supplier'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MerchantTile(merchant: merchant, onTap: () => tapped = true),
          ),
        ),
      );

      await tester.tap(find.text('Kampala Supplies'));
      expect(tapped, isTrue);
    });
  });
}
