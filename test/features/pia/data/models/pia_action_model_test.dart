import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pia/data/models/pia_action_model.dart';

void main() {
  group('PiaActionModel', () {
    const json = {
      'id': 'action-001',
      'type': 'schedule_payment',
      'label': 'Schedule payment',
      'params': <String, dynamic>{},
    };

    test('fromJson creates correct model', () {
      final model = PiaActionModel.fromJson(json);

      expect(model.id, 'action-001');
      expect(model.type, 'schedule_payment');
      expect(model.label, 'Schedule payment');
      expect(model.params, isEmpty);
    });

    test('toJson produces correct map', () {
      final model = PiaActionModel.fromJson(json);
      expect(model.toJson(), json);
    });

    test('toEntity converts action type correctly', () {
      final entity = PiaActionModel.fromJson(json).toEntity();

      expect(entity.type, PiaActionType.schedulePayment);
      expect(entity.label, 'Schedule payment');
    });

    test('handles params', () {
      final jsonWithParams = {
        'id': 'action-002',
        'type': 'set_reminder',
        'label': 'Remind me',
        'params': {'days': 3},
      };

      final model = PiaActionModel.fromJson(jsonWithParams);
      expect(model.params, {'days': 3});

      final entity = model.toEntity();
      expect(entity.params, {'days': 3});
    });
  });
}
