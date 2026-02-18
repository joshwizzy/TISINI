import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/more/presentation/screens/profile_screen.dart';

void main() {
  group('ProfileScreen', () {
    testWidgets('shows loading initially', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ProfileScreen())),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('shows form fields after loading', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ProfileScreen())),
      );

      await tester.pumpAndSettle();

      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Business Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('populates fields from profile', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ProfileScreen())),
      );

      await tester.pumpAndSettle();

      expect(find.text('Moses Kato'), findsOneWidget);
      expect(find.text('Kato Enterprises Ltd'), findsOneWidget);
      expect(find.text('moses@kato.co.ug'), findsOneWidget);
    });

    testWidgets('shows Save button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ProfileScreen())),
      );

      await tester.pumpAndSettle();

      // Scroll to find Save button
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('shows account type selector', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ProfileScreen())),
      );

      await tester.pumpAndSettle();

      expect(find.text('Account Type'), findsOneWidget);
      expect(find.text('Business'), findsOneWidget);
      expect(find.text('Gig Worker'), findsOneWidget);
    });
  });
}
