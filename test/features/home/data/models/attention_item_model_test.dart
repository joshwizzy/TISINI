import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/home/data/models/attention_item_model.dart';

void main() {
  group('AttentionItemModel', () {
    const json = {
      'id': 'att-001',
      'title': 'Complete KYC',
      'description': 'Verify your identity',
      'action_label': 'Start',
      'action_route': '/kyc',
      'priority': 'high',
      'created_at': 1718400000000,
    };

    test('fromJson creates correct model', () {
      final model = AttentionItemModel.fromJson(json);

      expect(model.id, 'att-001');
      expect(model.title, 'Complete KYC');
      expect(model.actionLabel, 'Start');
      expect(model.priority, 'high');
    });

    test('toJson produces correct map', () {
      final model = AttentionItemModel.fromJson(json);
      expect(model.toJson(), json);
    });

    test('toEntity converts priority correctly', () {
      final model = AttentionItemModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.priority, PiaCardPriority.high);
      expect(entity.id, 'att-001');
    });
  });
}
