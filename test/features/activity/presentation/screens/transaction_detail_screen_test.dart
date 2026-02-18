import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/activity/presentation/screens/transaction_detail_screen.dart';

void main() {
  group('TransactionDetailScreen', () {
    testWidgets('shows loading initially', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: TransactionDetailScreen(id: 'txn-001')),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('shows transaction details after loading', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: TransactionDetailScreen(id: 'txn-001')),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Transaction'), findsOneWidget);
      expect(find.text('Nakawa Hardware'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
    });

    testWidgets('shows category edit button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: TransactionDetailScreen(id: 'txn-001')),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Edit'), findsOneWidget);
    });

    testWidgets('shows pin merchant button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: TransactionDetailScreen(id: 'txn-001')),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Pin'), findsOneWidget);
    });

    testWidgets('shows note field', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: TransactionDetailScreen(id: 'txn-001')),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Add a note...'), findsOneWidget);
    });

    testWidgets('shows details card', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: TransactionDetailScreen(id: 'txn-001')),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('To/From'), findsOneWidget);
      expect(find.text('Route'), findsOneWidget);
      expect(find.text('Fee'), findsOneWidget);
      expect(find.text('Total'), findsOneWidget);
      expect(find.text('Reference'), findsOneWidget);
      expect(find.text('Time'), findsOneWidget);
    });
  });
}
