import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/activity/domain/entities/export_state.dart';
import 'package:tisini/features/activity/providers/export_controller.dart';

void main() {
  group('ExportController', () {
    test('initial state is choosingPeriod', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(exportControllerProvider, (_, __) {});
      final state = await container.read(exportControllerProvider.future);
      expect(state, isA<ExportChoosingPeriod>());
    });

    test('setPeriod transitions to confirming', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(exportControllerProvider, (_, __) {});
      await container.read(exportControllerProvider.future);

      await container
          .read(exportControllerProvider.notifier)
          .setPeriod(startDate: DateTime(2020), endDate: DateTime(2030));

      final state = container.read(exportControllerProvider).valueOrNull;
      expect(state, isA<ExportConfirming>());
      final confirming = state! as ExportConfirming;
      expect(confirming.estimatedRows, 18);
    });

    test('confirmExport transitions to success', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(exportControllerProvider, (_, __) {});
      await container.read(exportControllerProvider.future);

      await container
          .read(exportControllerProvider.notifier)
          .confirmExport(startDate: DateTime(2026), endDate: DateTime(2026, 2));

      final state = container.read(exportControllerProvider).valueOrNull;
      expect(state, isA<ExportSuccess>());
      final success = state! as ExportSuccess;
      expect(success.job.downloadUrl, isNotNull);
    });

    test('reset transitions to choosingPeriod', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(exportControllerProvider, (_, __) {});
      await container.read(exportControllerProvider.future);

      await container
          .read(exportControllerProvider.notifier)
          .confirmExport(startDate: DateTime(2026), endDate: DateTime(2026, 2));

      container.read(exportControllerProvider.notifier).reset();

      final state = container.read(exportControllerProvider).valueOrNull;
      expect(state, isA<ExportChoosingPeriod>());
    });
  });
}
