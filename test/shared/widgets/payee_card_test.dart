import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';
import 'package:tisini/shared/widgets/payee_card.dart';

void main() {
  const payee = Payee(
    id: 'p-001',
    name: 'Jane Nakamya',
    identifier: '+256700100200',
    rail: PaymentRail.mobileMoney,
    isPinned: false,
  );

  Widget buildWidget({Payee p = payee, VoidCallback? onTap}) {
    return MaterialApp(
      home: Scaffold(
        body: PayeeCard(payee: p, onTap: onTap),
      ),
    );
  }

  group('PayeeCard', () {
    testWidgets('renders payee name', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Jane Nakamya'), findsOneWidget);
    });

    testWidgets('renders payee identifier', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('+256700100200'), findsOneWidget);
    });

    testWidgets('renders initials when no avatar', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('JN'), findsOneWidget);
    });

    testWidgets('shows pin icon when pinned', (tester) async {
      const pinnedPayee = Payee(
        id: 'p-002',
        name: 'ABC Supplies',
        identifier: 'BIZ-ABC',
        rail: PaymentRail.bank,
        isPinned: true,
      );

      await tester.pumpWidget(buildWidget(p: pinnedPayee));

      expect(find.byType(Icon), findsWidgets);
    });

    testWidgets('handles tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(buildWidget(onTap: () => tapped = true));

      await tester.tap(find.byType(ListTile));

      expect(tapped, isTrue);
    });
  });
}
