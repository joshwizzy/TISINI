import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/shared/widgets/badge_chip.dart';

void main() {
  Widget buildWidget({
    String label = 'First Payment',
    String iconName = 'rocket',
    bool isEarned = true,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: BadgeChip(label: label, iconName: iconName, isEarned: isEarned),
      ),
    );
  }

  group('BadgeChip', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('First Payment'), findsOneWidget);
    });

    testWidgets('renders icon', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('renders earned state', (tester) async {
      await tester.pumpWidget(buildWidget());

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, isNotNull);
    });

    testWidgets('renders unearned state', (tester) async {
      await tester.pumpWidget(buildWidget(isEarned: false));

      expect(find.text('First Payment'), findsOneWidget);
    });
  });
}
