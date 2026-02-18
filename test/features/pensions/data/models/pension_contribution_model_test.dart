import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pensions/data/models/pension_contribution_model.dart';

void main() {
  group('PensionContributionModel', () {
    const json = {
      'id': 'pc-001',
      'amount': 5000000.0,
      'currency': 'UGX',
      'status': 'completed',
      'rail': 'mobile_money',
      'reference': 'NSSF Jan 2026',
      'created_at': 1704067200000,
      'completed_at': 1704067200000,
    };

    test('fromJson creates correct model', () {
      final model = PensionContributionModel.fromJson(json);

      expect(model.id, 'pc-001');
      expect(model.amount, 5000000);
      expect(model.currency, 'UGX');
      expect(model.status, 'completed');
      expect(model.rail, 'mobile_money');
      expect(model.reference, 'NSSF Jan 2026');
    });

    test('toJson produces correct map', () {
      final model = PensionContributionModel.fromJson(json);
      final result = model.toJson();

      expect(result['id'], 'pc-001');
      expect(result['status'], 'completed');
      expect(result['created_at'], 1704067200000);
    });

    test('toEntity converts enums correctly', () {
      final model = PensionContributionModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.id, 'pc-001');
      expect(entity.amount, 5000000);
      expect(entity.status, ContributionStatus.completed);
      expect(entity.rail, PaymentRail.mobileMoney);
      expect(entity.reference, 'NSSF Jan 2026');
      expect(entity.createdAt, isA<DateTime>());
      expect(entity.completedAt, isA<DateTime>());
    });

    test('toEntity maps pending status', () {
      final pendingJson = {...json, 'status': 'pending'};

      final entity = PensionContributionModel.fromJson(pendingJson).toEntity();

      expect(entity.status, ContributionStatus.pending);
    });

    test('toEntity maps failed status', () {
      final failedJson = {...json, 'status': 'failed'};

      final entity = PensionContributionModel.fromJson(failedJson).toEntity();

      expect(entity.status, ContributionStatus.failed);
    });

    test('toEntity maps bank rail', () {
      final bankJson = {...json, 'rail': 'bank'};

      final entity = PensionContributionModel.fromJson(bankJson).toEntity();

      expect(entity.rail, PaymentRail.bank);
    });

    test('fromJson without optional fields', () {
      const minJson = {
        'id': 'pc-002',
        'amount': 3000000.0,
        'currency': 'UGX',
        'status': 'pending',
        'rail': 'mobile_money',
        'created_at': 1704067200000,
      };

      final model = PensionContributionModel.fromJson(minJson);

      expect(model.reference, isNull);
      expect(model.completedAt, isNull);

      final entity = model.toEntity();
      expect(entity.reference, isNull);
      expect(entity.completedAt, isNull);
    });
  });
}
