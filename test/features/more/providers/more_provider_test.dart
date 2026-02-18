import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/auth/domain/entities/kyc_status.dart';
import 'package:tisini/features/more/providers/more_provider.dart';

void main() {
  group('moreRepositoryProvider', () {
    test('provides MoreRepository instance', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final repo = container.read(moreRepositoryProvider);

      expect(repo, isNotNull);
    });
  });

  group('profileProvider', () {
    test('returns user profile', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final profile = await container.read(profileProvider.future);

      expect(profile.id, 'u-001');
      expect(profile.fullName, 'Moses Kato');
      expect(profile.kycStatus, KycStatus.approved);
      expect(profile.accountType, KycAccountType.business);
    });
  });

  group('connectedAccountsProvider', () {
    test('returns account list', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final accounts = await container.read(connectedAccountsProvider.future);

      expect(accounts, hasLength(2));
      expect(accounts[0].provider, AccountProvider.mtn);
    });
  });

  group('securitySettingsProvider', () {
    test('returns security settings', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final settings = await container.read(securitySettingsProvider.future);

      expect(settings.pinEnabled, isTrue);
      expect(settings.biometricEnabled, isTrue);
    });
  });

  group('notificationSettingsProvider', () {
    test('returns notification preferences', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final settings = await container.read(
        notificationSettingsProvider.future,
      );

      expect(settings.paymentReceived, isTrue);
      expect(settings.promotions, isFalse);
    });
  });

  group('pinnedMerchantsProvider', () {
    test('returns merchant list', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final merchants = await container.read(pinnedMerchantsProvider.future);

      expect(merchants, hasLength(3));
      expect(merchants[0].name, 'Kampala Supplies');
    });
  });

  group('faqsProvider', () {
    test('returns FAQ list', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final faqs = await container.read(faqsProvider.future);

      expect(faqs, hasLength(5));
      expect(faqs[0].question, 'How do I send money?');
    });
  });

  group('updateMerchantRoleProvider', () {
    test('updates merchant role', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final merchant = await container.read(
        updateMerchantRoleProvider((
          id: 'pm-001',
          role: MerchantRole.rent,
        )).future,
      );

      expect(merchant.role, MerchantRole.rent);
    });
  });
}
