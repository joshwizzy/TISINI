import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/pia/presentation/screens/pia_pinned_items_screen.dart';

void main() {
  group('PiaPinnedItemsScreen', () {
    testWidgets('shows loading initially', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: PiaPinnedItemsScreen())),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('shows pinned items after loading', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: PiaPinnedItemsScreen())),
      );

      await tester.pumpAndSettle();

      expect(find.text('Pinned items'), findsOneWidget);
      expect(find.text('NSSF contribution schedule'), findsOneWidget);
    });

    testWidgets('shows only pinned cards', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: PiaPinnedItemsScreen())),
      );

      await tester.pumpAndSettle();

      // Only the pinned card (pia-007) should be visible
      expect(find.text('NSSF contribution schedule'), findsOneWidget);
      // Non-pinned cards should not appear
      expect(find.text('Tax filing deadline'), findsNothing);
    });
  });
}
