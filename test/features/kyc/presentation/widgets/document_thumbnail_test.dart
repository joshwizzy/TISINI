import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/kyc/presentation/widgets/document_thumbnail.dart';

void main() {
  group('DocumentThumbnail', () {
    testWidgets('renders label text for idFront', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DocumentThumbnail(
              type: KycDocumentType.idFront,
              isCaptured: false,
            ),
          ),
        ),
      );

      expect(find.text('ID Front'), findsOneWidget);
    });

    testWidgets('shows check icon when captured', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DocumentThumbnail(
              type: KycDocumentType.idFront,
              isCaptured: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(PhosphorIconsBold.checkCircle), findsOneWidget);
    });

    testWidgets('shows camera icon when not captured', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DocumentThumbnail(
              type: KycDocumentType.idFront,
              isCaptured: false,
            ),
          ),
        ),
      );

      expect(find.byIcon(PhosphorIconsBold.camera), findsOneWidget);
    });
  });
}
