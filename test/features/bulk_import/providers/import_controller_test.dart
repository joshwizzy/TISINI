import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_state.dart';
import 'package:tisini/features/bulk_import/providers/import_controller.dart';

void main() {
  group('ImportController', () {
    test('initial state is choosingSource', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(importControllerProvider, (_, __) {});

      final state = await container.read(importControllerProvider.future);

      expect(state, isA<ImportChoosingSource>());
    });

    test('selectSource transitions to mapping', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(importControllerProvider, (_, __) {});

      await container.read(importControllerProvider.future);

      await container
          .read(importControllerProvider.notifier)
          .selectSource(ImportSource.bank);

      final state = container.read(importControllerProvider).valueOrNull;

      expect(state, isA<ImportMapping_>());
      final mapping = state! as ImportMapping_;
      expect(mapping.columns, isNotEmpty);
      expect(mapping.sampleRows, isNotEmpty);
    });

    test('selectSource with mobileMoney transitions to mapping', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(importControllerProvider, (_, __) {});

      await container.read(importControllerProvider.future);

      await container
          .read(importControllerProvider.notifier)
          .selectSource(ImportSource.mobileMoney);

      final state = container.read(importControllerProvider).valueOrNull;

      expect(state, isA<ImportMapping_>());
      final mapping = state! as ImportMapping_;
      expect(mapping.columns, contains('Phone Number'));
    });

    test('reset returns to choosingSource', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(importControllerProvider, (_, __) {});

      await container.read(importControllerProvider.future);

      await container
          .read(importControllerProvider.notifier)
          .selectSource(ImportSource.bank);

      container.read(importControllerProvider.notifier).reset();

      final state = container.read(importControllerProvider).valueOrNull;

      expect(state, isA<ImportChoosingSource>());
    });
  });
}
