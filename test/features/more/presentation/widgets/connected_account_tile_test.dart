import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/more/domain/entities/connected_account.dart';
import 'package:tisini/features/more/presentation/widgets/connected_account_tile.dart';

void main() {
  final account = ConnectedAccount(
    id: 'acc1',
    provider: AccountProvider.mtn,
    identifier: '+256770555123',
    connectedAt: DateTime(2025, 3, 15),
  );

  group('ConnectedAccountTile', () {
    testWidgets('displays provider and identifier', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ConnectedAccountTile(account: account)),
        ),
      );

      expect(find.text('MTN MoMo'), findsOneWidget);
      expect(find.textContaining('+256770555123'), findsOneWidget);
    });

    testWidgets('shows disconnect button when callback set', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ConnectedAccountTile(account: account, onDisconnect: () {}),
          ),
        ),
      );

      expect(find.byIcon(Icons.link_off), findsOneWidget);
    });

    testWidgets('calls onDisconnect when tapped', (tester) async {
      var disconnected = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ConnectedAccountTile(
              account: account,
              onDisconnect: () => disconnected = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.link_off));
      expect(disconnected, isTrue);
    });
  });
}
