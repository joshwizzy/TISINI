import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/activity/domain/entities/transaction.dart';
import 'package:tisini/shared/widgets/transaction_row.dart';

void main() {
  Transaction makeTransaction({
    TransactionDirection direction = TransactionDirection.outbound,
    double amount = 150000,
    String counterpartyName = 'Jane Nakamya',
  }) {
    return Transaction(
      id: 'tx-001',
      type: PaymentType.send,
      direction: direction,
      status: PaymentStatus.completed,
      amount: amount,
      currency: 'UGX',
      counterpartyName: counterpartyName,
      counterpartyIdentifier: '+256700100200',
      category: TransactionCategory.people,
      rail: PaymentRail.mobileMoney,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    );
  }

  Widget buildWidget({Transaction? transaction, VoidCallback? onTap}) {
    return MaterialApp(
      home: Scaffold(
        body: TransactionRow(
          transaction: transaction ?? makeTransaction(),
          onTap: onTap,
        ),
      ),
    );
  }

  group('TransactionRow', () {
    testWidgets('renders counterparty name', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Jane Nakamya'), findsOneWidget);
    });

    testWidgets('renders amount with minus for outbound', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('-150,000'), findsOneWidget);
    });

    testWidgets('renders amount with plus for inbound', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          transaction: makeTransaction(direction: TransactionDirection.inbound),
        ),
      );

      expect(find.text('+150,000'), findsOneWidget);
    });

    testWidgets('renders currency', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('UGX'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(buildWidget(onTap: () => tapped = true));

      await tester.tap(find.byType(ListTile));
      expect(tapped, true);
    });

    testWidgets('renders direction icon', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.byType(Icon), findsOneWidget);
    });
  });
}
