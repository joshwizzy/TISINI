import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/auth/domain/entities/kyc_status.dart';
import 'package:tisini/features/more/data/models/user_profile_model.dart';

void main() {
  group('UserProfileModel', () {
    final json = <String, dynamic>{
      'id': 'u1',
      'phone_number': '+256700123456',
      'full_name': 'Moses Kato',
      'business_name': 'Kato Enterprises Ltd',
      'email': 'moses@kato.co.ug',
      'kyc_status': 'approved',
      'account_type': 'business',
    };

    test('fromJson parses correctly', () {
      final model = UserProfileModel.fromJson(json);
      expect(model.id, 'u1');
      expect(model.phoneNumber, '+256700123456');
      expect(model.fullName, 'Moses Kato');
      expect(model.businessName, 'Kato Enterprises Ltd');
      expect(model.email, 'moses@kato.co.ug');
      expect(model.kycStatus, 'approved');
      expect(model.accountType, 'business');
    });

    test('toJson produces snake_case keys', () {
      final model = UserProfileModel.fromJson(json);
      final output = model.toJson();
      expect(output['phone_number'], '+256700123456');
      expect(output['full_name'], 'Moses Kato');
      expect(output['business_name'], 'Kato Enterprises Ltd');
      expect(output['kyc_status'], 'approved');
      expect(output['account_type'], 'business');
    });

    test('toEntity converts correctly', () {
      final model = UserProfileModel.fromJson(json);
      final entity = model.toEntity();
      expect(entity.id, 'u1');
      expect(entity.phoneNumber, '+256700123456');
      expect(entity.fullName, 'Moses Kato');
      expect(entity.kycStatus, KycStatus.approved);
      expect(entity.accountType, KycAccountType.business);
    });

    test('toEntity with null optional fields', () {
      final minimal = <String, dynamic>{
        'id': 'u2',
        'phone_number': '+256700999888',
        'kyc_status': 'not_started',
      };
      final entity = UserProfileModel.fromJson(minimal).toEntity();
      expect(entity.fullName, isNull);
      expect(entity.businessName, isNull);
      expect(entity.email, isNull);
      expect(entity.accountType, isNull);
      expect(entity.kycStatus, KycStatus.notStarted);
    });

    test('toEntity parses unknown kyc status as notStarted', () {
      final unknown = Map<String, dynamic>.from(json)
        ..['kyc_status'] = 'unknown';
      final entity = UserProfileModel.fromJson(unknown).toEntity();
      expect(entity.kycStatus, KycStatus.notStarted);
    });

    test('round-trip serialization preserves data', () {
      final model = UserProfileModel.fromJson(json);
      final roundTrip = UserProfileModel.fromJson(model.toJson());
      expect(roundTrip, equals(model));
    });
  });
}
