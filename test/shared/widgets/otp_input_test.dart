import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/shared/widgets/otp_input.dart';

void main() {
  Widget buildApp({
    ValueChanged<String>? onCompleted,
    ValueChanged<String>? onChanged,
    String? errorText,
    bool isEnabled = true,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: OtpInput(
          onCompleted: onCompleted,
          onChanged: onChanged,
          errorText: errorText,
          isEnabled: isEnabled,
        ),
      ),
    );
  }

  group('OtpInput', () {
    testWidgets('renders 6 text fields', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();
      expect(find.byType(TextField), findsNWidgets(6));
    });

    testWidgets('displays error text when provided', (tester) async {
      await tester.pumpWidget(buildApp(errorText: 'Incorrect code'));
      await tester.pump();
      expect(find.text('Incorrect code'), findsOneWidget);
    });

    testWidgets('does not display error text when null', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();
      expect(find.text('Incorrect code'), findsNothing);
    });

    testWidgets('text fields are disabled when isEnabled is false', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp(isEnabled: false));
      await tester.pump();
      final textFields = tester.widgetList<TextField>(find.byType(TextField));
      for (final field in textFields) {
        expect(field.enabled, isFalse);
      }
    });
  });
}
