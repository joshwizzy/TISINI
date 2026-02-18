import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/pia/presentation/screens/pia_empty_screen.dart';

void main() {
  group('PiaEmptyScreen', () {
    testWidgets('shows empty state content', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: PiaEmptyScreen()));

      expect(find.text('Pia'), findsOneWidget);
      expect(find.text('No insights yet'), findsOneWidget);
      expect(find.textContaining('Pia will start showing'), findsOneWidget);
      expect(find.text('Import transactions'), findsOneWidget);
    });

    testWidgets('has elevated button', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: PiaEmptyScreen()));

      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}
