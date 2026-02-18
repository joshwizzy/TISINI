import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/features/more/domain/entities/security_settings.dart';

part 'security_settings_model.freezed.dart';
part 'security_settings_model.g.dart';

@freezed
class SecuritySettingsModel with _$SecuritySettingsModel {
  const factory SecuritySettingsModel({
    @JsonKey(name: 'pin_enabled') required bool pinEnabled,
    @JsonKey(name: 'biometric_enabled') required bool biometricEnabled,
    @JsonKey(name: 'two_step_enabled') required bool twoStepEnabled,
    @JsonKey(name: 'trusted_devices') required List<String> trustedDevices,
  }) = _SecuritySettingsModel;

  const SecuritySettingsModel._();

  factory SecuritySettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SecuritySettingsModelFromJson(json);

  SecuritySettings toEntity() => SecuritySettings(
    pinEnabled: pinEnabled,
    biometricEnabled: biometricEnabled,
    twoStepEnabled: twoStepEnabled,
    trustedDevices: trustedDevices,
  );
}
