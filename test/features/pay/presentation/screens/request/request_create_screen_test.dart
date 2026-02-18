import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/pay/domain/entities/request_state.dart';
import 'package:tisini/features/pay/presentation/screens/request/request_create_screen.dart';
import 'package:tisini/features/pay/providers/request_controller_provider.dart';

void main() {
  Widget buildWidget() {
    return ProviderScope(
      overrides: [
        requestControllerProvider.overrideWith(_MockRequestController.new),
      ],
      child: const MaterialApp(home: RequestCreateScreen()),
    );
  }

  group('RequestCreateScreen', () {
    testWidgets('renders Request Payment app bar', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Request Payment'), findsOneWidget);
    });

    testWidgets('renders Create request button', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Create request'), findsOneWidget);
    });

    testWidgets('renders Add a note hint', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Add a note (optional)'), findsOneWidget);
    });
  });
}

class _MockRequestController extends RequestController {
  @override
  Future<RequestState> build() async {
    return const RequestState.creating();
  }
}
