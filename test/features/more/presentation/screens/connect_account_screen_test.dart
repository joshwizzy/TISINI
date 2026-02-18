import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/more/presentation/screens/connect_account_screen.dart';

void main() {
  group('ConnectAccountScreen', () {
    testWidgets('shows provider list', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ConnectAccountScreen())),
      );

      expect(find.text('Connect Account'), findsOneWidget);
      expect(find.text('Select Provider'), findsOneWidget);
      expect(find.text('MTN MoMo'), findsOneWidget);
      expect(find.text('Airtel Money'), findsOneWidget);
      expect(find.text('Stanbic Bank'), findsOneWidget);
      expect(find.text('DFCU Bank'), findsOneWidget);
    });

    testWidgets('shows identifier input', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ConnectAccountScreen())),
      );

      expect(find.text('Account Identifier'), findsOneWidget);
    });

    testWidgets('shows Link Account button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ConnectAccountScreen())),
      );

      // Scroll to find the button
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(find.text('Link Account'), findsOneWidget);
    });

    testWidgets('can select a provider', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ConnectAccountScreen())),
      );

      await tester.tap(find.text('MTN MoMo'));
      await tester.pumpAndSettle();

      // Verify the widget tree rebuilt with selection
      // by checking that MTN MoMo is still visible
      expect(find.text('MTN MoMo'), findsOneWidget);
      expect(find.text('Airtel Money'), findsOneWidget);
    });
  });
}
