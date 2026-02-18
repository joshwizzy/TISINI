import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/more/presentation/screens/notification_settings_screen.dart';

void main() {
  group('NotificationSettingsScreen', () {
    testWidgets('shows loading initially', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: NotificationSettingsScreen()),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('shows all notification toggles', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: NotificationSettingsScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Payment Received'), findsOneWidget);
      expect(find.text('PIA Cards'), findsOneWidget);
      expect(find.text('Pension Reminders'), findsOneWidget);
      expect(find.text('Promotions'), findsOneWidget);
    });

    testWidgets('has correct initial toggle states', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: NotificationSettingsScreen()),
        ),
      );

      await tester.pumpAndSettle();

      final switches = tester.widgetList<Switch>(find.byType(Switch)).toList();
      // Payment, PIA, Pension: true; Promotions: false
      expect(switches[0].value, isTrue);
      expect(switches[1].value, isTrue);
      expect(switches[2].value, isTrue);
      expect(switches[3].value, isFalse);
    });
  });
}
