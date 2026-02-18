import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/more/presentation/screens/connected_accounts_screen.dart';

void main() {
  group('ConnectedAccountsScreen', () {
    testWidgets('shows loading initially', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: ConnectedAccountsScreen()),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('shows accounts after loading', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: ConnectedAccountsScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Connected Accounts'), findsOneWidget);
      expect(find.text('MTN MoMo'), findsOneWidget);
      expect(find.text('Stanbic Bank'), findsOneWidget);
    });

    testWidgets('shows Add Account button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: ConnectedAccountsScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Add Account'), findsOneWidget);
    });

    testWidgets('shows disconnect icons', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: ConnectedAccountsScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.link_off), findsNWidgets(2));
    });
  });
}
