import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/pay/domain/entities/scan_state.dart';
import 'package:tisini/features/pay/presentation/screens/scan/scan_manual_entry_screen.dart';
import 'package:tisini/features/pay/providers/scan_controller_provider.dart';

void main() {
  Widget buildWidget() {
    return ProviderScope(
      overrides: [scanControllerProvider.overrideWith(_MockScanController.new)],
      child: const MaterialApp(home: ScanManualEntryScreen()),
    );
  }

  group('ScanManualEntryScreen', () {
    testWidgets('renders Enter Details app bar', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Enter Details'), findsOneWidget);
    });

    testWidgets('renders Continue button', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('renders hint text', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('e.g. +256700100200'), findsOneWidget);
    });
  });
}

class _MockScanController extends ScanController {
  @override
  Future<ScanState> build() async {
    return const ScanState.manualEntry();
  }
}
