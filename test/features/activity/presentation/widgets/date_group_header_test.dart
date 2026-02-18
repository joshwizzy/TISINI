import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/activity/presentation/widgets/date_group_header.dart';

void main() {
  Widget buildWidget(DateTime date) {
    return MaterialApp(
      home: Scaffold(body: DateGroupHeader(date: date)),
    );
  }

  group('DateGroupHeader', () {
    testWidgets('shows Today for today', (tester) async {
      await tester.pumpWidget(buildWidget(DateTime.now()));
      expect(find.text('Today'), findsOneWidget);
    });

    testWidgets('shows Yesterday for yesterday', (tester) async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      await tester.pumpWidget(buildWidget(yesterday));
      expect(find.text('Yesterday'), findsOneWidget);
    });

    testWidgets('shows formatted date for older dates', (tester) async {
      final oldDate = DateTime(2026, 1, 15);
      await tester.pumpWidget(buildWidget(oldDate));
      expect(find.text('Today'), findsNothing);
      expect(find.text('Yesterday'), findsNothing);
      expect(find.byType(Text), findsOneWidget);
    });
  });
}
