import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/more/presentation/screens/more_hub_screen.dart';

void main() {
  group('MoreHubScreen', () {
    testWidgets('shows loading initially', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: MoreHubScreen())),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('shows user header after loading', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: MoreHubScreen())),
      );

      await tester.pumpAndSettle();

      expect(find.text('Moses Kato'), findsOneWidget);
      expect(find.text('+256700123456'), findsOneWidget);
    });

    testWidgets('shows all menu tiles', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: MoreHubScreen())),
      );

      await tester.pumpAndSettle();

      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Connected Accounts'), findsOneWidget);
      expect(find.text('Security'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Pinned Merchants'), findsOneWidget);
      expect(find.text('KYC Verification'), findsOneWidget);
      expect(find.text('Help & Support'), findsOneWidget);
    });

    testWidgets('shows Legal & About tile', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: MoreHubScreen())),
      );

      await tester.pumpAndSettle();

      // Scroll to the bottom to find Legal & About
      await tester.drag(find.byType(ListView), const Offset(0, -200));
      await tester.pumpAndSettle();

      expect(find.text('Legal & About'), findsOneWidget);
    });

    testWidgets('shows KYC status badge', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: MoreHubScreen())),
      );

      await tester.pumpAndSettle();

      expect(find.text('Approved'), findsOneWidget);
    });

    testWidgets('shows app version footer', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: MoreHubScreen())),
      );

      await tester.pumpAndSettle();

      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(find.text('Tisini v1.0.0'), findsOneWidget);
    });
  });
}
