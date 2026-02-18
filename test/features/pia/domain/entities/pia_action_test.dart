import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pia/domain/entities/pia_action.dart';

void main() {
  group('PiaAction', () {
    test('creates with required fields', () {
      const action = PiaAction(
        id: 'action-001',
        type: PiaActionType.schedulePayment,
        label: 'Schedule payment',
      );

      expect(action.id, 'action-001');
      expect(action.type, PiaActionType.schedulePayment);
      expect(action.label, 'Schedule payment');
      expect(action.params, isEmpty);
    });

    test('creates with params', () {
      const action = PiaAction(
        id: 'action-001',
        type: PiaActionType.setReminder,
        label: 'Set reminder',
        params: {'days': 3},
      );

      expect(action.params, {'days': 3});
    });

    test('supports value equality', () {
      const a = PiaAction(
        id: 'action-001',
        type: PiaActionType.markAsPinned,
        label: 'Pin',
      );
      const b = PiaAction(
        id: 'action-001',
        type: PiaActionType.markAsPinned,
        label: 'Pin',
      );

      expect(a, equals(b));
    });
  });
}
