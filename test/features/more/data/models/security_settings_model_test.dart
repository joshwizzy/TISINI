import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/more/data/models/security_settings_model.dart';

void main() {
  group('SecuritySettingsModel', () {
    final json = <String, dynamic>{
      'pin_enabled': true,
      'biometric_enabled': true,
      'two_step_enabled': false,
      'trusted_devices': ['iPhone 14', 'Samsung Galaxy S23'],
    };

    test('fromJson parses correctly', () {
      final model = SecuritySettingsModel.fromJson(json);
      expect(model.pinEnabled, isTrue);
      expect(model.biometricEnabled, isTrue);
      expect(model.twoStepEnabled, isFalse);
      expect(model.trustedDevices, hasLength(2));
    });

    test('toJson produces snake_case keys', () {
      final model = SecuritySettingsModel.fromJson(json);
      final output = model.toJson();
      expect(output['pin_enabled'], isTrue);
      expect(output['biometric_enabled'], isTrue);
      expect(output['two_step_enabled'], isFalse);
      expect(output['trusted_devices'], hasLength(2));
    });

    test('toEntity converts correctly', () {
      final model = SecuritySettingsModel.fromJson(json);
      final entity = model.toEntity();
      expect(entity.pinEnabled, isTrue);
      expect(entity.biometricEnabled, isTrue);
      expect(entity.twoStepEnabled, isFalse);
      expect(entity.trustedDevices, ['iPhone 14', 'Samsung Galaxy S23']);
    });

    test('round-trip serialization preserves data', () {
      final model = SecuritySettingsModel.fromJson(json);
      final roundTrip = SecuritySettingsModel.fromJson(model.toJson());
      expect(roundTrip, equals(model));
    });
  });
}
