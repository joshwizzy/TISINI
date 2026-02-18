import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/auth/presentation/screens/create_pin_screen.dart';
import 'package:tisini/shared/widgets/pin_dots.dart';
import 'package:tisini/shared/widgets/pin_numpad.dart';

void main() {
  Widget buildApp() {
    return const ProviderScope(child: MaterialApp(home: CreatePinScreen()));
  }

  group('CreatePinScreen', () {
    testWidgets('displays Create your PIN headline', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Create your PIN'), findsOneWidget);
    });

    testWidgets('displays PinDots widget', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(PinDots), findsOneWidget);
    });

    testWidgets('displays PinNumpad widget', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(PinNumpad), findsOneWidget);
    });

    testWidgets('displays back button', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('numpad digits 0-9 are present', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      for (var i = 0; i <= 9; i++) {
        expect(find.text('$i'), findsOneWidget);
      }
    });
  });
}
