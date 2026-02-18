import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/auth/domain/entities/kyc_status.dart';
import 'package:tisini/features/more/data/datasources/mock_more_remote_datasource.dart';
import 'package:tisini/features/more/data/repositories/more_repository_impl.dart';

void main() {
  late MoreRepositoryImpl repository;

  setUp(() {
    repository = MoreRepositoryImpl(datasource: MockMoreRemoteDatasource());
  });

  group('MoreRepositoryImpl', () {
    test('getProfile returns entity', () async {
      final profile = await repository.getProfile();

      expect(profile.id, 'u-001');
      expect(profile.fullName, 'Moses Kato');
      expect(profile.kycStatus, KycStatus.approved);
      expect(profile.accountType, KycAccountType.business);
    });

    test('updateProfile returns updated entity', () async {
      final profile = await repository.updateProfile(fullName: 'Moses K. Kato');

      expect(profile.fullName, 'Moses K. Kato');
    });

    test('getConnectedAccounts returns entity list', () async {
      final accounts = await repository.getConnectedAccounts();

      expect(accounts, hasLength(2));
      expect(accounts[0].provider, AccountProvider.mtn);
      expect(accounts[1].provider, AccountProvider.stanbic);
      expect(accounts[0].connectedAt, isA<DateTime>());
    });

    test('connectAccount returns new entity', () async {
      final account = await repository.connectAccount(
        provider: AccountProvider.airtel,
        identifier: '+256750111222',
      );

      expect(account.provider, AccountProvider.airtel);
      expect(account.identifier, '+256750111222');
    });

    test('disconnectAccount completes', () async {
      await expectLater(
        repository.disconnectAccount(accountId: 'acc-001'),
        completes,
      );
    });

    test('getSecuritySettings returns entity', () async {
      final settings = await repository.getSecuritySettings();

      expect(settings.pinEnabled, isTrue);
      expect(settings.biometricEnabled, isTrue);
      expect(settings.trustedDevices, hasLength(2));
    });

    test('updateSecuritySettings returns updated entity', () async {
      final settings = await repository.updateSecuritySettings(
        twoStepEnabled: true,
      );

      expect(settings.twoStepEnabled, isTrue);
    });

    test('getNotificationSettings returns entity', () async {
      final settings = await repository.getNotificationSettings();

      expect(settings.paymentReceived, isTrue);
      expect(settings.promotions, isFalse);
    });

    test('updateNotificationSettings returns updated entity', () async {
      final settings = await repository.updateNotificationSettings(
        promotions: true,
      );

      expect(settings.promotions, isTrue);
    });

    test('getPinnedMerchants returns entity list', () async {
      final merchants = await repository.getPinnedMerchants();

      expect(merchants, hasLength(3));
      expect(merchants[0].role, MerchantRole.supplier);
      expect(merchants[2].role, MerchantRole.tax);
      expect(merchants[0].pinnedAt, isA<DateTime>());
    });

    test('updateMerchantRole returns updated entity', () async {
      final merchant = await repository.updateMerchantRole(
        merchantId: 'pm-001',
        role: MerchantRole.rent,
      );

      expect(merchant.role, MerchantRole.rent);
    });

    test('unpinMerchant completes', () async {
      await expectLater(
        repository.unpinMerchant(merchantId: 'pm-001'),
        completes,
      );
    });

    test('getFaqs returns entity list', () async {
      final faqs = await repository.getFaqs();

      expect(faqs, hasLength(5));
      expect(faqs[0].question, 'How do I send money?');
    });
  });
}
