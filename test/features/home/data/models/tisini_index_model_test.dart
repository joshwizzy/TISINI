import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/home/data/models/tisini_index_model.dart';

void main() {
  group('TisiniIndexModel', () {
    const json = {
      'score': 64,
      'payment_consistency': 72,
      'compliance_readiness': 55,
      'business_momentum': 68,
      'data_completeness': 61,
      'change_reason': 'Improved consistency',
      'change_amount': 3.0,
      'updated_at': 1718400000000,
    };

    test('fromJson creates correct model', () {
      final model = TisiniIndexModel.fromJson(json);

      expect(model.score, 64);
      expect(model.paymentConsistency, 72);
      expect(model.complianceReadiness, 55);
      expect(model.businessMomentum, 68);
      expect(model.dataCompleteness, 61);
      expect(model.changeReason, 'Improved consistency');
      expect(model.changeAmount, 3.0);
      expect(model.updatedAt, 1718400000000);
    });

    test('toJson produces correct map', () {
      final model = TisiniIndexModel.fromJson(json);
      final result = model.toJson();

      expect(result, json);
    });

    test('toEntity converts correctly', () {
      final model = TisiniIndexModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.score, 64);
      expect(entity.paymentConsistency, 72);
      expect(
        entity.updatedAt,
        DateTime.fromMillisecondsSinceEpoch(1718400000000),
      );
    });
  });
}
