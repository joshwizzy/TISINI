import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/more/domain/entities/faq_item.dart';
import 'package:tisini/features/more/presentation/widgets/faq_expansion_tile.dart';

void main() {
  const faq = FaqItem(
    question: 'How do I send money?',
    answer: 'Tap Send on the Pay screen.',
  );

  group('FaqExpansionTile', () {
    testWidgets('displays question', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: FaqExpansionTile(faq: faq)),
        ),
      );

      expect(find.text('How do I send money?'), findsOneWidget);
    });

    testWidgets('shows answer when expanded', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: FaqExpansionTile(faq: faq)),
        ),
      );

      await tester.tap(find.text('How do I send money?'));
      await tester.pumpAndSettle();

      expect(find.text('Tap Send on the Pay screen.'), findsOneWidget);
    });
  });
}
