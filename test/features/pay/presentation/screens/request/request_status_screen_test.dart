import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payment_request.dart';
import 'package:tisini/features/pay/domain/entities/request_state.dart';
import 'package:tisini/features/pay/presentation/screens/request/request_status_screen.dart';
import 'package:tisini/features/pay/providers/request_controller_provider.dart';

void main() {
  Widget buildWidget() {
    return ProviderScope(
      overrides: [
        requestControllerProvider.overrideWith(_MockRequestController.new),
      ],
      child: const MaterialApp(home: RequestStatusScreen(requestId: 'req-001')),
    );
  }

  group('RequestStatusScreen', () {
    testWidgets('renders Request Status app bar', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Request Status'), findsOneWidget);
    });

    testWidgets('renders amount', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('UGX 50,000'), findsOneWidget);
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
    return RequestState.tracking(
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

  @override
  Future<void> viewStatus(String requestId) async {
    // No-op: state is already set by build()
  }
}
