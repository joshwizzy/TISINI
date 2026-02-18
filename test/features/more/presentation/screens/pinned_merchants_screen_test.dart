import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/more/presentation/screens/pinned_merchants_screen.dart';

void main() {
  group('PinnedMerchantsScreen', () {
    testWidgets('shows loading initially', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: PinnedMerchantsScreen())),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('shows merchants after loading', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: PinnedMerchantsScreen())),
      );

      await tester.pumpAndSettle();

      expect(find.text('Pinned Merchants'), findsOneWidget);
      expect(find.text('Kampala Supplies'), findsOneWidget);
      expect(find.text('Mukwano Industries'), findsOneWidget);
      expect(find.text('URA'), findsOneWidget);
    });

    testWidgets('shows role chips', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: PinnedMerchantsScreen())),
      );

      await tester.pumpAndSettle();

      expect(find.text('Supplier'), findsNWidgets(2));
      expect(find.text('Tax'), findsOneWidget);
    });

    testWidgets('shows role sheet on tap', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: PinnedMerchantsScreen())),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Kampala Supplies'));
      await tester.pumpAndSettle();

      // Role sheet should be visible
      expect(find.text('Rent'), findsOneWidget);
      expect(find.text('Wages'), findsOneWidget);
      expect(find.text('Utilities'), findsOneWidget);
    });
  });
}
