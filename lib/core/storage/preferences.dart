import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  Preferences({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  static const _hasSeenOnboardingKey = 'has_seen_onboarding';
  static const _lastVerifiedAtKey = 'last_verified_at';

  // Onboarding
  bool get hasSeenOnboarding => _prefs.getBool(_hasSeenOnboardingKey) ?? false;

  Future<bool> setHasSeenOnboarding({required bool value}) =>
      _prefs.setBool(_hasSeenOnboardingKey, value);

  // Step-up verification
  DateTime? get lastVerifiedAt {
    final millis = _prefs.getInt(_lastVerifiedAtKey);
    if (millis == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  Future<bool> setLastVerifiedAt(DateTime value) =>
      _prefs.setInt(_lastVerifiedAtKey, value.millisecondsSinceEpoch);

  // Feature flags
  bool getFeatureFlag(String key, {bool defaultValue = false}) =>
      _prefs.getBool('ff_$key') ?? defaultValue;

  Future<bool> setFeatureFlag(String key, {required bool value}) =>
      _prefs.setBool('ff_$key', value);

  // Clear all
  Future<bool> clear() => _prefs.clear();
}
