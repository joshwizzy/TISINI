import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/pay/domain/entities/scan_state.dart';
import 'package:tisini/features/pay/presentation/screens/scan/scan_screen.dart';
import 'package:tisini/features/pay/providers/scan_controller_provider.dart';

void main() {
  Widget buildWidget() {
    return ProviderScope(
      overrides: [scanControllerProvider.overrideWith(_MockScanController.new)],
      child: const MaterialApp(home: ScanScreen()),
    );
  }

  group('ScanScreen', () {
    testWidgets('renders Enter manually button', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Enter manually'), findsOneWidget);
    });

    testWidgets('renders QR code instruction text', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Point camera at QR code'), findsOneWidget);
    });
  });
}

class _MockScanController extends ScanController {
  @override
  Future<ScanState> build() async {
    return const ScanState.scanning();
  }
}
