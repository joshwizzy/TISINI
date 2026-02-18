import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/auth/presentation/screens/login_screen.dart';
import 'package:tisini/shared/widgets/primary_button.dart';
import 'package:tisini/shared/widgets/tisini_logo.dart';

void main() {
  Widget buildApp() {
    return const ProviderScope(child: MaterialApp(home: LoginScreen()));
  }

  group('LoginScreen', () {
    testWidgets('displays logo in app bar', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(TisiniLogo), findsOneWidget);
    });

    testWidgets('displays phone number headline', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Enter your phone number'), findsOneWidget);
    });

    testWidgets('displays country prefix', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text('+256'), findsOneWidget);
    });

    testWidgets('displays Continue button', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(PrimaryButton), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('displays phone text field', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    });
  });
}
