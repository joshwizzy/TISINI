import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/home/data/models/badge_model.dart';

void main() {
  group('BadgeModel', () {
    test('fromJson creates correct model with earnedAt', () {
      const json = {
        'id': 'badge-001',
        'label': 'First Payment',
        'icon_name': 'rocket',
        'is_earned': true,
        'earned_at': 1718400000000,
      };

      final model = BadgeModel.fromJson(json);

      expect(model.id, 'badge-001');
      expect(model.label, 'First Payment');
      expect(model.iconName, 'rocket');
      expect(model.isEarned, true);
      expect(model.earnedAt, 1718400000000);
    });

    test('fromJson handles null earnedAt', () {
      const json = {
        'id': 'badge-002',
        'label': 'KYC Verified',
        'icon_name': 'shieldCheck',
        'is_earned': false,
      };

      final model = BadgeModel.fromJson(json);

      expect(model.isEarned, false);
      expect(model.earnedAt, isNull);
    });

    test('toJson produces correct map', () {
      const json = {
        'id': 'badge-001',
        'label': 'First Payment',
        'icon_name': 'rocket',
        'is_earned': true,
        'earned_at': 1718400000000,
      };

      final model = BadgeModel.fromJson(json);
      expect(model.toJson(), json);
    });

    test('toEntity converts correctly', () {
      const json = {
        'id': 'badge-001',
        'label': 'First Payment',
        'icon_name': 'rocket',
        'is_earned': true,
        'earned_at': 1718400000000,
      };

      final entity = BadgeModel.fromJson(json).toEntity();

      expect(entity.id, 'badge-001');
      expect(entity.isEarned, true);
      expect(
        entity.earnedAt,
        DateTime.fromMillisecondsSinceEpoch(1718400000000),
      );
    });
  });
}
