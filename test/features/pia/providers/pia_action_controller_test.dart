import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/pia/domain/entities/pia_action_state.dart';
import 'package:tisini/features/pia/providers/pia_action_controller.dart';

void main() {
  group('PiaActionController', () {
    test('build returns idle state', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(piaActionControllerProvider, (_, __) {});

      final state = await container.read(piaActionControllerProvider.future);

      expect(state, isA<PiaActionIdle>());
    });

    test('executeAction transitions to success', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(piaActionControllerProvider, (_, __) {});

      await container.read(piaActionControllerProvider.future);

      await container
          .read(piaActionControllerProvider.notifier)
          .executeAction(cardId: 'pia-001', actionId: 'a-001');

      final state = container.read(piaActionControllerProvider).valueOrNull;

      expect(state, isA<PiaActionSuccess>());
      final success = state! as PiaActionSuccess;
      expect(success.message, contains('Schedule payment'));
    });

    test('dismiss transitions to success', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(piaActionControllerProvider, (_, __) {});

      await container.read(piaActionControllerProvider.future);

      await container
          .read(piaActionControllerProvider.notifier)
          .dismiss('pia-001');

      final state = container.read(piaActionControllerProvider).valueOrNull;

      expect(state, isA<PiaActionSuccess>());
      final success = state! as PiaActionSuccess;
      expect(success.message, 'Card dismissed');
    });

    test('pin transitions to success', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(piaActionControllerProvider, (_, __) {});

      await container.read(piaActionControllerProvider.future);

      await container.read(piaActionControllerProvider.notifier).pin('pia-002');

      final state = container.read(piaActionControllerProvider).valueOrNull;

      expect(state, isA<PiaActionSuccess>());
      final success = state! as PiaActionSuccess;
      expect(success.message, 'Card pinned');
    });

    test('unpin transitions to success', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(piaActionControllerProvider, (_, __) {});

      await container.read(piaActionControllerProvider.future);

      await container
          .read(piaActionControllerProvider.notifier)
          .unpin('pia-007');

      final state = container.read(piaActionControllerProvider).valueOrNull;

      expect(state, isA<PiaActionSuccess>());
      final success = state! as PiaActionSuccess;
      expect(success.message, 'Card unpinned');
    });

    test('reset returns to idle', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(piaActionControllerProvider, (_, __) {});

      await container.read(piaActionControllerProvider.future);

      await container
          .read(piaActionControllerProvider.notifier)
          .dismiss('pia-001');

      container.read(piaActionControllerProvider.notifier).reset();

      final state = container.read(piaActionControllerProvider).valueOrNull;

      expect(state, isA<PiaActionIdle>());
    });
  });
}
