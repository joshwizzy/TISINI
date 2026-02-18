import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/more/presentation/screens/security_settings_screen.dart';

void main() {
  group('SecuritySettingsScreen', () {
    testWidgets('shows loading initially', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SecuritySettingsScreen())),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('shows toggle tiles after loading', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SecuritySettingsScreen())),
      );

      await tester.pumpAndSettle();

      expect(find.text('Security'), findsOneWidget);
      expect(find.text('PIN'), findsOneWidget);
      expect(find.text('Biometric Login'), findsOneWidget);
      expect(find.text('Two-Step Verification'), findsOneWidget);
    });

    testWidgets('shows trusted devices', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SecuritySettingsScreen())),
      );

      await tester.pumpAndSettle();

      expect(find.text('Trusted Devices'), findsOneWidget);
      expect(find.text('iPhone 14 Pro'), findsOneWidget);
      expect(find.text('Samsung Galaxy S23'), findsOneWidget);
    });

    testWidgets('PIN toggle is disabled', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SecuritySettingsScreen())),
      );

      await tester.pumpAndSettle();

      // Find all Switches - first one (PIN) should be disabled
      final switches = tester.widgetList<Switch>(find.byType(Switch));
      final pinSwitch = switches.first;
      expect(pinSwitch.onChanged, isNull);
    });
  });
}
