import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/auth/data/models/user_model.dart';
import 'package:tisini/features/auth/domain/entities/kyc_status.dart';

void main() {
  group('UserModel', () {
    final json = {
      'id': 'user-001',
      'phone_number': '+256700000000',
      'full_name': 'John Doe',
      'business_name': 'Doe Enterprises',
      'kyc_status': 'approved',
      'created_at': 1740000000000,
    };

    test('fromJson creates model from snake_case JSON', () {
      final model = UserModel.fromJson(json);
      expect(model.id, 'user-001');
      expect(model.phoneNumber, '+256700000000');
      expect(model.fullName, 'John Doe');
      expect(model.businessName, 'Doe Enterprises');
      expect(model.kycStatus, 'approved');
      expect(model.createdAt, 1740000000000);
    });

    test('toJson produces snake_case JSON', () {
      const model = UserModel(
        id: 'user-001',
        phoneNumber: '+256700000000',
        fullName: 'John Doe',
        businessName: 'Doe Enterprises',
        kycStatus: 'approved',
        createdAt: 1740000000000,
      );
      final result = model.toJson();
      expect(result['id'], 'user-001');
      expect(result['phone_number'], '+256700000000');
      expect(result['full_name'], 'John Doe');
      expect(result['business_name'], 'Doe Enterprises');
      expect(result['kyc_status'], 'approved');
      expect(result['created_at'], 1740000000000);
    });

    test('JSON round-trip preserves data', () {
      const original = UserModel(
        id: 'user-001',
        phoneNumber: '+256700000000',
        kycStatus: 'not_started',
        createdAt: 1740000000000,
      );
      final roundTripped = UserModel.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });

    test('fromJson handles null optional fields', () {
      final minimalJson = {
        'id': 'user-001',
        'phone_number': '+256700000000',
        'kyc_status': 'not_started',
        'created_at': 1740000000000,
      };
      final model = UserModel.fromJson(minimalJson);
      expect(model.fullName, isNull);
      expect(model.businessName, isNull);
    });

    test('toEntity converts kyc_status string correctly', () {
      const model = UserModel(
        id: 'user-001',
        phoneNumber: '+256700000000',
        kycStatus: 'in_progress',
        createdAt: 1740000000000,
      );
      final entity = model.toEntity();
      expect(entity.kycStatus, KycStatus.inProgress);
    });

    test('toEntity maps all kyc statuses', () {
      const statuses = {
        'not_started': KycStatus.notStarted,
        'in_progress': KycStatus.inProgress,
        'pending': KycStatus.pending,
        'approved': KycStatus.approved,
        'failed': KycStatus.failed,
      };

      for (final entry in statuses.entries) {
        final model = UserModel(
          id: 'u',
          phoneNumber: '+256700000000',
          kycStatus: entry.key,
          createdAt: 0,
        );
        expect(model.toEntity().kycStatus, entry.value);
      }
    });

    test('toEntity defaults unknown kyc_status to notStarted', () {
      const model = UserModel(
        id: 'u',
        phoneNumber: '+256700000000',
        kycStatus: 'unknown_status',
        createdAt: 0,
      );
      expect(model.toEntity().kycStatus, KycStatus.notStarted);
    });
  });
}
