import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/shared/widgets/pin_numpad.dart';

void main() {
  Widget buildApp({
    required ValueChanged<String> onDigit,
    required VoidCallback onBackspace,
    bool isEnabled = true,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: PinNumpad(
          onDigit: onDigit,
          onBackspace: onBackspace,
          isEnabled: isEnabled,
        ),
      ),
    );
  }

  group('PinNumpad', () {
    testWidgets('renders digits 0-9', (tester) async {
      await tester.pumpWidget(buildApp(onDigit: (_) {}, onBackspace: () {}));
      for (var i = 0; i <= 9; i++) {
        expect(find.text('$i'), findsOneWidget);
      }
    });

    testWidgets('calls onDigit with correct digit', (tester) async {
      String? tappedDigit;
      await tester.pumpWidget(
        buildApp(onDigit: (d) => tappedDigit = d, onBackspace: () {}),
      );
      await tester.tap(find.text('5'));
      expect(tappedDigit, '5');
    });

    testWidgets('calls onBackspace when backspace tapped', (tester) async {
      var backspaceTapped = false;
      await tester.pumpWidget(
        buildApp(onDigit: (_) {}, onBackspace: () => backspaceTapped = true),
      );
      // Tap the last InkWell (backspace is the last key)
      final inkWells = find.byType(InkWell).evaluate().toList();
      await tester.tap(find.byWidget(inkWells.last.widget));
      expect(backspaceTapped, isTrue);
    });

    testWidgets('does not call onDigit when disabled', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        buildApp(
          onDigit: (_) => tapped = true,
          onBackspace: () {},
          isEnabled: false,
        ),
      );
      await tester.tap(find.text('5'));
      expect(tapped, isFalse);
    });
  });
}
