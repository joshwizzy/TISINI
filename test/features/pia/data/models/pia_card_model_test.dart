import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pia/data/models/pia_card_model.dart';

void main() {
  group('PiaCardModel', () {
    final json = {
      'id': 'pia-001',
      'title': 'Tax deadline',
      'what': 'Filing deadline in 5 days',
      'why': 'Avoid penalties',
      'details': 'Quarterly VAT return due',
      'actions': [
        {
          'id': 'action-001',
          'type': 'set_reminder',
          'label': 'Set reminder',
          'params': <String, dynamic>{},
        },
      ],
      'priority': 'high',
      'status': 'active',
      'is_pinned': false,
      'created_at': 1718400000000,
    };

    test('fromJson creates correct model', () {
      final model = PiaCardModel.fromJson(json);

      expect(model.id, 'pia-001');
      expect(model.title, 'Tax deadline');
      expect(model.actions, hasLength(1));
      expect(model.priority, 'high');
      expect(model.status, 'active');
      expect(model.isPinned, false);
    });

    test('toJson produces correct map', () {
      final model = PiaCardModel.fromJson(json);
      final result = model.toJson();

      expect(result['id'], 'pia-001');
      expect(result['is_pinned'], false);
      expect(result['actions'], hasLength(1));
    });

    test('toEntity converts correctly', () {
      final entity = PiaCardModel.fromJson(json).toEntity();

      expect(entity.id, 'pia-001');
      expect(entity.priority, PiaCardPriority.high);
      expect(entity.status, PiaCardStatus.active);
      expect(entity.actions, hasLength(1));
      expect(entity.actions.first.type, PiaActionType.setReminder);
    });
  });
}
