import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payment_request.dart';
import 'package:tisini/features/pay/domain/entities/request_state.dart';
import 'package:tisini/features/pay/presentation/screens/request/request_share_screen.dart';
import 'package:tisini/features/pay/providers/request_controller_provider.dart';

void main() {
  Widget buildWidget() {
    return ProviderScope(
      overrides: [
        requestControllerProvider.overrideWith(_MockRequestController.new),
      ],
      child: const MaterialApp(home: RequestShareScreen(requestId: 'req-001')),
    );
  }

  group('RequestShareScreen', () {
    testWidgets('renders Share Request app bar', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Share Request'), findsOneWidget);
    });

    testWidgets('renders amount', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('UGX 50,000'), findsOneWidget);
    });

    testWidgets('renders Copy link button', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Copy link'), findsOneWidget);
    });

    testWidgets('renders Done button', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Done'), findsOneWidget);
    });
  });
}

class _MockRequestController extends RequestController {
  @override
  Future<RequestState> build() async {
    return RequestState.sharing(
      request: PaymentRequest(
        id: 'req-001',
        amount: 50000,
        currency: 'UGX',
        shareLink: 'https://pay.tisini.co/r/req-001',
        status: PaymentStatus.pending,
        createdAt: DateTime(2024),
      ),
    );
  }
}
