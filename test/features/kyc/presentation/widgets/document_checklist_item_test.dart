import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/kyc/presentation/widgets/document_checklist_item.dart';

void main() {
  group('DocumentChecklistItem', () {
    testWidgets('renders document label text for idFront', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DocumentChecklistItem(
              type: KycDocumentType.idFront,
              isCaptured: false,
            ),
          ),
        ),
      );

      expect(find.text('ID Card (Front)'), findsOneWidget);
    });

    testWidgets('shows check circle when captured', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DocumentChecklistItem(
              type: KycDocumentType.idFront,
              isCaptured: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(PhosphorIconsBold.checkCircle), findsOneWidget);
    });

    testWidgets('shows empty circle when not captured', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DocumentChecklistItem(
              type: KycDocumentType.idFront,
              isCaptured: false,
            ),
          ),
        ),
      );

      expect(find.byIcon(PhosphorIconsBold.circle), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DocumentChecklistItem(
              type: KycDocumentType.idFront,
              isCaptured: false,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('ID Card (Front)'));
      expect(tapped, isTrue);
    });
  });
}
