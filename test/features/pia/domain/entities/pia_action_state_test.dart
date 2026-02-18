import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/pia/domain/entities/pia_action_state.dart';

void main() {
  group('PiaActionState', () {
    test('idle creates idle state', () {
      const state = PiaActionState.idle();

      expect(state, isA<PiaActionIdle>());
    });

    test('executing creates executing state with ids', () {
      const state = PiaActionState.executing(
        cardId: 'card-1',
        actionId: 'action-1',
      );

      expect(state, isA<PiaActionExecuting>());
      const executing = PiaActionExecuting(
        cardId: 'card-1',
        actionId: 'action-1',
      );
      expect(state, equals(executing));
      expect(executing.cardId, 'card-1');
      expect(executing.actionId, 'action-1');
    });

    test('success creates success state with message', () {
      const state = PiaActionState.success(message: 'Done');

      expect(state, isA<PiaActionSuccess>());
      expect((state as PiaActionSuccess).message, 'Done');
    });

    test('failed creates failed state with message', () {
      const state = PiaActionState.failed(message: 'Error');

      expect(state, isA<PiaActionFailed>());
      expect((state as PiaActionFailed).message, 'Error');
    });

    test('equality works for identical states', () {
      const a = PiaActionState.idle();
      const b = PiaActionState.idle();

      expect(a, equals(b));
    });

    test('inequality works for different states', () {
      const idle = PiaActionState.idle();
      const success = PiaActionState.success(message: 'Done');

      expect(idle, isNot(equals(success)));
    });
  });
}
