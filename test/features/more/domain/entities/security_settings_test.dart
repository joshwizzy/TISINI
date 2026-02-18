import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/more/domain/entities/security_settings.dart';

void main() {
  group('SecuritySettings', () {
    test('creates with required fields', () {
      const settings = SecuritySettings(
        pinEnabled: true,
        biometricEnabled: true,
        twoStepEnabled: false,
        trustedDevices: ['iPhone 14', 'Samsung Galaxy S23'],
      );

      expect(settings.pinEnabled, isTrue);
      expect(settings.biometricEnabled, isTrue);
      expect(settings.twoStepEnabled, isFalse);
      expect(settings.trustedDevices, hasLength(2));
    });

    test('supports value equality', () {
      const a = SecuritySettings(
        pinEnabled: true,
        biometricEnabled: false,
        twoStepEnabled: false,
        trustedDevices: ['Device A'],
      );
      const b = SecuritySettings(
        pinEnabled: true,
        biometricEnabled: false,
        twoStepEnabled: false,
        trustedDevices: ['Device A'],
      );

      expect(a, equals(b));
    });

    test('supports empty trusted devices', () {
      const settings = SecuritySettings(
        pinEnabled: true,
        biometricEnabled: false,
        twoStepEnabled: false,
        trustedDevices: [],
      );

      expect(settings.trustedDevices, isEmpty);
    });
  });
}
