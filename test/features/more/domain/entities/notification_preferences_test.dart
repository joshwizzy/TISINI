import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/more/domain/entities/notification_preferences.dart';

void main() {
  group('NotificationPreferences', () {
    test('creates with required fields', () {
      const prefs = NotificationPreferences(
        paymentReceived: true,
        piaCards: true,
        pensionReminders: true,
        promotions: false,
      );

      expect(prefs.paymentReceived, isTrue);
      expect(prefs.piaCards, isTrue);
      expect(prefs.pensionReminders, isTrue);
      expect(prefs.promotions, isFalse);
    });

    test('supports value equality', () {
      const a = NotificationPreferences(
        paymentReceived: true,
        piaCards: true,
        pensionReminders: true,
        promotions: false,
      );
      const b = NotificationPreferences(
        paymentReceived: true,
        piaCards: true,
        pensionReminders: true,
        promotions: false,
      );

      expect(a, equals(b));
    });

    test('supports copyWith', () {
      const prefs = NotificationPreferences(
        paymentReceived: true,
        piaCards: true,
        pensionReminders: true,
        promotions: false,
      );

      final updated = prefs.copyWith(promotions: true);

      expect(updated.promotions, isTrue);
      expect(updated.paymentReceived, isTrue);
    });
  });
}
