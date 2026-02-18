import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/onboarding/presentation/screens/permissions_screen.dart';
import 'package:tisini/shared/widgets/permission_card.dart';
import 'package:tisini/shared/widgets/primary_button.dart';

void main() {
  Widget buildApp() {
    return const ProviderScope(child: MaterialApp(home: PermissionsScreen()));
  }

  group('PermissionsScreen', () {
    testWidgets('displays headline', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text('A couple of things'), findsOneWidget);
    });

    testWidgets('displays 2 PermissionCards', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(PermissionCard), findsNWidgets(2));
    });

    testWidgets('displays Notifications card', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Notifications'), findsOneWidget);
    });

    testWidgets('displays Camera card', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Camera'), findsOneWidget);
    });

    testWidgets('displays Get started button', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(PrimaryButton), findsOneWidget);
      expect(find.text('Get started'), findsOneWidget);
    });

    testWidgets('Enable button taps grant permission', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // Initially shows Enable buttons
      expect(find.text('Enable'), findsNWidgets(2));

      // Tap first Enable button (notifications)
      await tester.tap(find.text('Enable').first);
      await tester.pumpAndSettle();

      // One Enable button replaced with check
      expect(find.text('Enable'), findsOneWidget);
    });
  });
}
