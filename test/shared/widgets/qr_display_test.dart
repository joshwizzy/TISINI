import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/shared/widgets/qr_display.dart';

void main() {
  group('QrDisplay', () {
    testWidgets('renders QR code', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QrDisplay(data: 'https://pay.tisini.co/r/req-001'),
          ),
        ),
      );

      expect(find.byType(QrDisplay), findsOneWidget);
    });

    testWidgets('displays data text below QR code', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QrDisplay(data: 'https://pay.tisini.co/r/req-001'),
          ),
        ),
      );

      expect(find.text('https://pay.tisini.co/r/req-001'), findsOneWidget);
    });
  });
}
