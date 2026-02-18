import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/auth/domain/entities/kyc_status.dart';
import 'package:tisini/features/kyc/presentation/widgets/kyc_status_banner.dart';

void main() {
  group('KycStatusBanner', () {
    testWidgets('renders "Verified" for approved status', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: KycStatusBanner(status: KycStatus.approved)),
        ),
      );

      expect(find.text('Verified'), findsOneWidget);
    });

    testWidgets('renders "Pending review" for pending status', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: KycStatusBanner(status: KycStatus.pending)),
        ),
      );

      expect(find.text('Pending review'), findsOneWidget);
    });

    testWidgets('renders "Verification failed" for failed status', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: KycStatusBanner(status: KycStatus.failed)),
        ),
      );

      expect(find.text('Verification failed'), findsOneWidget);
    });

    testWidgets('renders rejection reason when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: KycStatusBanner(
              status: KycStatus.failed,
              rejectionReason: 'Photo was blurry',
            ),
          ),
        ),
      );

      expect(find.text('Photo was blurry'), findsOneWidget);
    });
  });
}
