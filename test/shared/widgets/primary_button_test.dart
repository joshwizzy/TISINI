import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/shared/widgets/primary_button.dart';

void main() {
  Widget buildApp({
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isEnabled = true,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: PrimaryButton(
          label: label,
          onPressed: onPressed,
          isLoading: isLoading,
          isEnabled: isEnabled,
        ),
      ),
    );
  }

  group('PrimaryButton', () {
    testWidgets('displays label text', (tester) async {
      await tester.pumpWidget(buildApp(label: 'Continue'));
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        buildApp(label: 'Continue', onPressed: () => tapped = true),
      );
      await tester.tap(find.byType(ElevatedButton));
      expect(tapped, isTrue);
    });

    testWidgets('shows CircularProgressIndicator when loading', (tester) async {
      await tester.pumpWidget(buildApp(label: 'Continue', isLoading: true));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Continue'), findsNothing);
    });

    testWidgets('does not call onPressed when loading', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        buildApp(
          label: 'Continue',
          onPressed: () => tapped = true,
          isLoading: true,
        ),
      );
      await tester.tap(find.byType(ElevatedButton));
      expect(tapped, isFalse);
    });

    testWidgets('does not call onPressed when disabled', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        buildApp(
          label: 'Continue',
          onPressed: () => tapped = true,
          isEnabled: false,
        ),
      );
      await tester.tap(find.byType(ElevatedButton));
      expect(tapped, isFalse);
    });

    testWidgets('is full width', (tester) async {
      await tester.pumpWidget(buildApp(label: 'Continue'));
      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(ElevatedButton),
          matching: find.byType(SizedBox),
        ),
      );
      expect(sizedBox.width, double.infinity);
    });
  });
}
