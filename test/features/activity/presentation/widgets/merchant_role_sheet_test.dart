import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/activity/presentation/widgets/merchant_role_sheet.dart';

void main() {
  group('MerchantRoleSheet', () {
    testWidgets('shows all roles', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: MerchantRoleSheet(onSelected: (_) {})),
        ),
      );

      expect(find.text('Pin Merchant As'), findsOneWidget);
      expect(find.text('Supplier'), findsOneWidget);
      expect(find.text('Rent'), findsOneWidget);
      expect(find.text('Wages'), findsOneWidget);
      expect(find.text('Tax'), findsOneWidget);
      expect(find.text('Pension'), findsOneWidget);
      expect(find.text('Utilities'), findsOneWidget);
    });

    testWidgets('shows check for selected role', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MerchantRoleSheet(
              selected: MerchantRole.supplier,
              onSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('fires onSelected when role tapped', (tester) async {
      MerchantRole? selected;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MerchantRoleSheet(onSelected: (role) => selected = role),
          ),
        ),
      );

      await tester.tap(find.text('Wages'));
      expect(selected, MerchantRole.wages);
    });
  });
}
