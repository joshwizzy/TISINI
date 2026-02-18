import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/pay/domain/entities/send_state.dart';
import 'package:tisini/features/pay/presentation/screens/send/send_failed_screen.dart';
import 'package:tisini/features/pay/providers/send_controller_provider.dart';

void main() {
  Widget buildWidget() {
    return ProviderScope(
      overrides: [sendControllerProvider.overrideWith(_MockSendController.new)],
      child: const MaterialApp(home: SendFailedScreen()),
    );
  }

  group('SendFailedScreen', () {
    testWidgets('renders Payment Failed', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Payment Failed'), findsOneWidget);
    });

    testWidgets('renders error message', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Insufficient balance'), findsOneWidget);
    });

    testWidgets('renders Try again button', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Try again'), findsOneWidget);
    });

    testWidgets('renders Cancel button', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Cancel'), findsOneWidget);
    });
  });
}

class _MockSendController extends SendController {
  @override
  Future<SendState> build() async {
    return const SendState.failed(
      message: 'Insufficient balance',
      code: 'INSUFFICIENT_BALANCE',
    );
  }
}
