import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/pia/presentation/screens/pia_feed_screen.dart';

void main() {
  group('PiaFeedScreen', () {
    testWidgets('shows loading indicator initially', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: PiaFeedScreen())),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('shows tabs after loading', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: PiaFeedScreen())),
      );

      await tester.pumpAndSettle();

      expect(find.text('Pia'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Pinned'), findsOneWidget);
    });

    testWidgets('shows feed cards in All tab', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: PiaFeedScreen())),
      );

      await tester.pumpAndSettle();

      expect(find.text('Pension due soon'), findsOneWidget);
      expect(find.text('Tax filing deadline'), findsOneWidget);
    });

    testWidgets('shows pinned cards in Pinned tab', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: PiaFeedScreen())),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Pinned'));
      await tester.pumpAndSettle();

      expect(find.text('NSSF contribution schedule'), findsOneWidget);
    });

    testWidgets('shows action buttons on cards', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: PiaFeedScreen())),
      );

      await tester.pumpAndSettle();

      expect(find.text('Schedule payment'), findsOneWidget);
      expect(find.text('Set reminder'), findsOneWidget);
    });
  });
}
