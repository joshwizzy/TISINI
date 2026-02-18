import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/activity/presentation/screens/activity_list_screen.dart';

void main() {
  group('ActivityListScreen', () {
    testWidgets('shows loading indicator initially', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ActivityListScreen())),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('shows transactions after loading', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ActivityListScreen())),
      );
      await tester.pumpAndSettle();

      expect(find.text('Activity'), findsOneWidget);
      expect(find.text('Nakawa Hardware'), findsOneWidget);
    });

    testWidgets('shows date group headers', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ActivityListScreen())),
      );
      await tester.pumpAndSettle();

      expect(find.text('Today'), findsOneWidget);
    });

    testWidgets('shows appbar with filter and export icons', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ActivityListScreen())),
      );
      await tester.pumpAndSettle();

      expect(find.byType(IconButton), findsNWidgets(2));
    });
  });
}
