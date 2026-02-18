import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pensions/data/models/pension_status_model.dart';

void main() {
  group('PensionReminderModel', () {
    const json = {
      'id': 'rem-001',
      'reminder_date': 1711929600000,
      'is_active': true,
      'amount': 5000000.0,
    };

    test('fromJson creates correct model', () {
      final model = PensionReminderModel.fromJson(json);

      expect(model.id, 'rem-001');
      expect(model.reminderDate, 1711929600000);
      expect(model.isActive, true);
      expect(model.amount, 5000000);
    });

    test('toJson produces correct map', () {
      final model = PensionReminderModel.fromJson(json);
      final result = model.toJson();

      expect(result['id'], 'rem-001');
      expect(result['reminder_date'], 1711929600000);
      expect(result['is_active'], true);
    });

    test('toEntity converts correctly', () {
      final model = PensionReminderModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.id, 'rem-001');
      expect(entity.isActive, true);
      expect(entity.amount, 5000000);
      expect(entity.reminderDate, isA<DateTime>());
    });

    test('fromJson without optional amount', () {
      final minJson = {
        'id': 'rem-002',
        'reminder_date': 1711929600000,
        'is_active': false,
      };

      final model = PensionReminderModel.fromJson(minJson);

      expect(model.amount, isNull);
      expect(model.isActive, false);
    });
  });

  group('PensionStatusModel', () {
    final json = {
      'link_status': 'linked',
      'currency': 'UGX',
      'total_contributions': 3,
      'total_amount': 15000000.0,
      'nssf_number': 'NSSF-UG-123456',
      'next_due_date': 1711929600000,
      'next_due_amount': 5000000.0,
      'active_reminders': [
        {
          'id': 'rem-001',
          'reminder_date': 1711929600000,
          'is_active': true,
          'amount': 5000000.0,
        },
      ],
    };

    test('fromJson creates correct model', () {
      final model = PensionStatusModel.fromJson(json);

      expect(model.linkStatus, 'linked');
      expect(model.currency, 'UGX');
      expect(model.totalContributions, 3);
      expect(model.totalAmount, 15000000);
      expect(model.nssfNumber, 'NSSF-UG-123456');
      expect(model.activeReminders, hasLength(1));
    });

    test('toJson produces correct map', () {
      final model = PensionStatusModel.fromJson(json);
      final result = model.toJson();

      expect(result['link_status'], 'linked');
      expect(result['total_contributions'], 3);
    });

    test('toEntity converts enums and dates correctly', () {
      final model = PensionStatusModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.linkStatus, PensionLinkStatus.linked);
      expect(entity.currency, 'UGX');
      expect(entity.totalContributions, 3);
      expect(entity.nssfNumber, 'NSSF-UG-123456');
      expect(entity.nextDueDate, isA<DateTime>());
      expect(entity.nextDueAmount, 5000000);
      expect(entity.activeReminders, hasLength(1));
      expect(entity.activeReminders.first.id, 'rem-001');
    });

    test('toEntity maps not_linked status', () {
      final notLinkedJson = {
        ...json,
        'link_status': 'not_linked',
        'nssf_number': null,
      };

      final entity = PensionStatusModel.fromJson(notLinkedJson).toEntity();

      expect(entity.linkStatus, PensionLinkStatus.notLinked);
    });

    test('toEntity maps verifying status', () {
      final verifyingJson = {...json, 'link_status': 'verifying'};

      final entity = PensionStatusModel.fromJson(verifyingJson).toEntity();

      expect(entity.linkStatus, PensionLinkStatus.verifying);
    });

    test('fromJson without optional fields', () {
      final minJson = <String, dynamic>{
        'link_status': 'not_linked',
        'currency': 'UGX',
        'total_contributions': 0,
        'total_amount': 0.0,
        'active_reminders': <Map<String, dynamic>>[],
      };

      final model = PensionStatusModel.fromJson(minJson);

      expect(model.nssfNumber, isNull);
      expect(model.nextDueDate, isNull);
      expect(model.nextDueAmount, isNull);
      expect(model.activeReminders, isEmpty);
    });
  });
}
