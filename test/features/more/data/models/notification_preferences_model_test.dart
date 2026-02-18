import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/more/data/models/notification_preferences_model.dart';

void main() {
  group('NotificationPreferencesModel', () {
    final json = <String, dynamic>{
      'payment_received': true,
      'pia_cards': true,
      'pension_reminders': true,
      'promotions': false,
    };

    test('fromJson parses correctly', () {
      final model = NotificationPreferencesModel.fromJson(json);
      expect(model.paymentReceived, isTrue);
      expect(model.piaCards, isTrue);
      expect(model.pensionReminders, isTrue);
      expect(model.promotions, isFalse);
    });

    test('toJson produces snake_case keys', () {
      final model = NotificationPreferencesModel.fromJson(json);
      final output = model.toJson();
      expect(output['payment_received'], isTrue);
      expect(output['pia_cards'], isTrue);
      expect(output['pension_reminders'], isTrue);
      expect(output['promotions'], isFalse);
    });

    test('toEntity converts correctly', () {
      final model = NotificationPreferencesModel.fromJson(json);
      final entity = model.toEntity();
      expect(entity.paymentReceived, isTrue);
      expect(entity.piaCards, isTrue);
      expect(entity.pensionReminders, isTrue);
      expect(entity.promotions, isFalse);
    });

    test('round-trip serialization preserves data', () {
      final model = NotificationPreferencesModel.fromJson(json);
      final roundTrip = NotificationPreferencesModel.fromJson(model.toJson());
      expect(roundTrip, equals(model));
    });
  });
}
