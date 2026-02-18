import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/pia/presentation/screens/pia_card_detail_screen.dart';

void main() {
  group('PiaCardDetailScreen', () {
    testWidgets('shows loading initially', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: PiaCardDetailScreen(id: 'pia-001')),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('shows card details after loading', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: PiaCardDetailScreen(id: 'pia-001')),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Insight'), findsOneWidget);
      expect(find.text('Pension due soon'), findsOneWidget);
      expect(find.textContaining('NSSF contribution'), findsOneWidget);
    });

    testWidgets('shows expanded card with why and details', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: PiaCardDetailScreen(id: 'pia-001')),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('late penalties'), findsOneWidget);
    });

    testWidgets('shows overflow menu', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: PiaCardDetailScreen(id: 'pia-001')),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(PopupMenuButton<String>), findsOneWidget);
    });

    testWidgets('overflow menu shows Dismiss and Pin', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: PiaCardDetailScreen(id: 'pia-001')),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      expect(find.text('Dismiss'), findsOneWidget);
      expect(find.text('Pin'), findsOneWidget);
    });

    testWidgets('shows Unpin for pinned card', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: PiaCardDetailScreen(id: 'pia-007')),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      expect(find.text('Unpin'), findsOneWidget);
    });

    testWidgets('shows action buttons', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: PiaCardDetailScreen(id: 'pia-001')),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Schedule payment'), findsOneWidget);
    });
  });
}
