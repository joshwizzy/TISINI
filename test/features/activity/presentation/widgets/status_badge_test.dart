import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/activity/presentation/widgets/status_badge.dart';

void main() {
  Widget buildWidget(PaymentStatus status) {
    return MaterialApp(
      home: Scaffold(body: StatusBadge(status: status)),
    );
  }

  group('StatusBadge', () {
    testWidgets('shows Completed for completed status', (tester) async {
      await tester.pumpWidget(buildWidget(PaymentStatus.completed));
      expect(find.text('Completed'), findsOneWidget);
    });

    testWidgets('shows Pending for pending status', (tester) async {
      await tester.pumpWidget(buildWidget(PaymentStatus.pending));
      expect(find.text('Pending'), findsOneWidget);
    });

    testWidgets('shows Processing for processing status', (tester) async {
      await tester.pumpWidget(buildWidget(PaymentStatus.processing));
      expect(find.text('Processing'), findsOneWidget);
    });

    testWidgets('shows Failed for failed status', (tester) async {
      await tester.pumpWidget(buildWidget(PaymentStatus.failed));
      expect(find.text('Failed'), findsOneWidget);
    });

    testWidgets('shows Reversed for reversed status', (tester) async {
      await tester.pumpWidget(buildWidget(PaymentStatus.reversed));
      expect(find.text('Reversed'), findsOneWidget);
    });
  });
}
