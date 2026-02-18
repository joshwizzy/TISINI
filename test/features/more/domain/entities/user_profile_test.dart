import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/auth/domain/entities/kyc_status.dart';
import 'package:tisini/features/more/domain/entities/user_profile.dart';

void main() {
  group('UserProfile', () {
    test('creates with required fields', () {
      const profile = UserProfile(
        id: 'u1',
        phoneNumber: '+256700123456',
        kycStatus: KycStatus.approved,
      );

      expect(profile.id, 'u1');
      expect(profile.phoneNumber, '+256700123456');
      expect(profile.kycStatus, KycStatus.approved);
      expect(profile.fullName, isNull);
      expect(profile.businessName, isNull);
      expect(profile.email, isNull);
      expect(profile.accountType, isNull);
    });

    test('creates with all fields', () {
      const profile = UserProfile(
        id: 'u1',
        phoneNumber: '+256700123456',
        fullName: 'Moses Kato',
        businessName: 'Kato Enterprises Ltd',
        email: 'moses@kato.co.ug',
        kycStatus: KycStatus.approved,
        accountType: KycAccountType.business,
      );

      expect(profile.fullName, 'Moses Kato');
      expect(profile.businessName, 'Kato Enterprises Ltd');
      expect(profile.email, 'moses@kato.co.ug');
      expect(profile.accountType, KycAccountType.business);
    });

    test('supports value equality', () {
      const a = UserProfile(
        id: 'u1',
        phoneNumber: '+256700123456',
        kycStatus: KycStatus.approved,
      );
      const b = UserProfile(
        id: 'u1',
        phoneNumber: '+256700123456',
        kycStatus: KycStatus.approved,
      );

      expect(a, equals(b));
    });

    test('supports copyWith', () {
      const profile = UserProfile(
        id: 'u1',
        phoneNumber: '+256700123456',
        kycStatus: KycStatus.notStarted,
      );

      final updated = profile.copyWith(
        fullName: 'Moses Kato',
        kycStatus: KycStatus.approved,
      );

      expect(updated.fullName, 'Moses Kato');
      expect(updated.kycStatus, KycStatus.approved);
      expect(updated.phoneNumber, '+256700123456');
    });
  });
}
