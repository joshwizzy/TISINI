import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tisini/core/storage/preferences.dart';

void main() {
  group('Preferences', () {
    late Preferences preferences;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      preferences = Preferences(prefs: prefs);
    });

    test('hasSeenOnboarding defaults to false', () {
      expect(preferences.hasSeenOnboarding, isFalse);
    });

    test('setHasSeenOnboarding persists value', () async {
      await preferences.setHasSeenOnboarding(value: true);
      expect(preferences.hasSeenOnboarding, isTrue);
    });

    test('lastVerifiedAt defaults to null', () {
      expect(preferences.lastVerifiedAt, isNull);
    });

    test('setLastVerifiedAt persists value', () async {
      final now = DateTime(2026, 2, 18);
      await preferences.setLastVerifiedAt(now);
      expect(
        preferences.lastVerifiedAt?.millisecondsSinceEpoch,
        now.millisecondsSinceEpoch,
      );
    });

    test('getFeatureFlag returns default when not set', () {
      expect(preferences.getFeatureFlag('stablecoin'), isFalse);
      expect(
        preferences.getFeatureFlag('stablecoin', defaultValue: true),
        isTrue,
      );
    });

    test('setFeatureFlag persists value', () async {
      await preferences.setFeatureFlag('stablecoin', value: true);
      expect(preferences.getFeatureFlag('stablecoin'), isTrue);
    });

    test('clear removes all values', () async {
      await preferences.setHasSeenOnboarding(value: true);
      await preferences.clear();
      expect(preferences.hasSeenOnboarding, isFalse);
    });
  });
}
