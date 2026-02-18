import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/more/data/datasources/mock_more_remote_datasource.dart';

void main() {
  late MockMoreRemoteDatasource datasource;

  setUp(() {
    datasource = MockMoreRemoteDatasource();
  });

  group('MockMoreRemoteDatasource', () {
    group('profile', () {
      test('getProfile returns Moses Kato', () async {
        final profile = await datasource.getProfile();

        expect(profile.id, 'u-001');
        expect(profile.phoneNumber, '+256700123456');
        expect(profile.fullName, 'Moses Kato');
        expect(profile.businessName, 'Kato Enterprises Ltd');
        expect(profile.email, 'moses@kato.co.ug');
        expect(profile.kycStatus, 'approved');
        expect(profile.accountType, 'business');
      });

      test('updateProfile changes fields', () async {
        await datasource.updateProfile(
          fullName: 'Moses K. Kato',
          email: 'mk@kato.co.ug',
        );

        final profile = await datasource.getProfile();
        expect(profile.fullName, 'Moses K. Kato');
        expect(profile.email, 'mk@kato.co.ug');
        expect(profile.businessName, 'Kato Enterprises Ltd');
      });
    });

    group('connected accounts', () {
      test('getConnectedAccounts returns 2 accounts', () async {
        final accounts = await datasource.getConnectedAccounts();

        expect(accounts, hasLength(2));
        expect(accounts[0].provider, 'mtn');
        expect(accounts[1].provider, 'stanbic');
      });

      test('connectAccount adds new account', () async {
        final account = await datasource.connectAccount(
          provider: AccountProvider.airtel,
          identifier: '+256750111222',
        );

        expect(account.provider, 'airtel');
        expect(account.identifier, '+256750111222');

        final accounts = await datasource.getConnectedAccounts();
        expect(accounts, hasLength(3));
      });

      test('disconnectAccount removes account', () async {
        await datasource.disconnectAccount(accountId: 'acc-001');

        final accounts = await datasource.getConnectedAccounts();
        expect(accounts, hasLength(1));
        expect(accounts[0].provider, 'stanbic');
      });
    });

    group('security settings', () {
      test('getSecuritySettings returns defaults', () async {
        final settings = await datasource.getSecuritySettings();

        expect(settings.pinEnabled, isTrue);
        expect(settings.biometricEnabled, isTrue);
        expect(settings.twoStepEnabled, isFalse);
        expect(settings.trustedDevices, hasLength(2));
      });

      test('updateSecuritySettings toggles', () async {
        await datasource.updateSecuritySettings(twoStepEnabled: true);

        final settings = await datasource.getSecuritySettings();
        expect(settings.twoStepEnabled, isTrue);
        expect(settings.biometricEnabled, isTrue);
      });
    });

    group('notification settings', () {
      test('getNotificationSettings returns defaults', () async {
        final settings = await datasource.getNotificationSettings();

        expect(settings.paymentReceived, isTrue);
        expect(settings.piaCards, isTrue);
        expect(settings.pensionReminders, isTrue);
        expect(settings.promotions, isFalse);
      });

      test('updateNotificationSettings toggles promotions', () async {
        await datasource.updateNotificationSettings(promotions: true);

        final settings = await datasource.getNotificationSettings();
        expect(settings.promotions, isTrue);
        expect(settings.paymentReceived, isTrue);
      });
    });

    group('pinned merchants', () {
      test('getPinnedMerchants returns 3 merchants', () async {
        final merchants = await datasource.getPinnedMerchants();

        expect(merchants, hasLength(3));
        expect(merchants[0].name, 'Kampala Supplies');
        expect(merchants[1].name, 'Mukwano Industries');
        expect(merchants[2].name, 'URA');
      });

      test('updateMerchantRole changes role', () async {
        final updated = await datasource.updateMerchantRole(
          merchantId: 'pm-001',
          role: MerchantRole.rent,
        );

        expect(updated.role, 'rent');
      });

      test('updateMerchantRole throws for unknown merchant', () async {
        expect(
          () => datasource.updateMerchantRole(
            merchantId: 'unknown',
            role: MerchantRole.rent,
          ),
          throwsException,
        );
      });

      test('unpinMerchant removes merchant', () async {
        await datasource.unpinMerchant(merchantId: 'pm-001');

        final merchants = await datasource.getPinnedMerchants();
        expect(merchants, hasLength(2));
      });
    });

    group('faqs', () {
      test('getFaqs returns 5 items', () async {
        final faqs = await datasource.getFaqs();

        expect(faqs, hasLength(5));
        expect(faqs[0].question, 'How do I send money?');
      });
    });
  });
}
