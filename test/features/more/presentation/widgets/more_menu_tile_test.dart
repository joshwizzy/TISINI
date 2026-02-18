import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/features/more/presentation/widgets/more_menu_tile.dart';

void main() {
  group('MoreMenuTile', () {
    testWidgets('displays title and icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MoreMenuTile(
              icon: PhosphorIconsBold.user,
              title: 'Profile',
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('displays subtitle when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MoreMenuTile(
              icon: PhosphorIconsBold.user,
              title: 'Profile',
              subtitle: 'Edit your profile',
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Edit your profile'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MoreMenuTile(
              icon: PhosphorIconsBold.user,
              title: 'Profile',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Profile'));
      expect(tapped, isTrue);
    });
  });
}
