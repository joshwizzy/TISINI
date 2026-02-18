import 'package:freezed_annotation/freezed_annotation.dart';

part 'security_settings.freezed.dart';

@freezed
class SecuritySettings with _$SecuritySettings {
  const factory SecuritySettings({
    required bool pinEnabled,
    required bool biometricEnabled,
    required bool twoStepEnabled,
    required List<String> trustedDevices,
  }) = _SecuritySettings;
}
