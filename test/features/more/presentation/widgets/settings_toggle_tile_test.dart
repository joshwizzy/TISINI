import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/more/presentation/widgets/settings_toggle_tile.dart';

void main() {
  group('SettingsToggleTile', () {
    testWidgets('displays title and switch', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsToggleTile(
              title: 'Biometric Login',
              value: true,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Biometric Login'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('calls onChanged when toggled', (tester) async {
      bool? newValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsToggleTile(
              title: 'Biometric Login',
              value: true,
              onChanged: (v) => newValue = v,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Switch));
      expect(newValue, isFalse);
    });

    testWidgets('switch is disabled when enabled is false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsToggleTile(
              title: 'PIN',
              value: true,
              onChanged: (_) {},
              enabled: false,
            ),
          ),
        ),
      );

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.onChanged, isNull);
    });
  });
}
