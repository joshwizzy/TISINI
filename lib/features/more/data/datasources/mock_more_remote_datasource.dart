import 'package:tisini/core/enums.dart';
import 'package:tisini/features/more/data/datasources/more_remote_datasource.dart';
import 'package:tisini/features/more/data/models/connected_account_model.dart';
import 'package:tisini/features/more/data/models/faq_item_model.dart';
import 'package:tisini/features/more/data/models/notification_preferences_model.dart';
import 'package:tisini/features/more/data/models/pinned_merchant_model.dart';
import 'package:tisini/features/more/data/models/security_settings_model.dart';
import 'package:tisini/features/more/data/models/user_profile_model.dart';

class MockMoreRemoteDatasource implements MoreRemoteDatasource {
  static const _readDelay = Duration(milliseconds: 300);
  static const _writeDelay = Duration(milliseconds: 800);

  var _profile = const UserProfileModel(
    id: 'u-001',
    phoneNumber: '+256700123456',
    fullName: 'Moses Kato',
    businessName: 'Kato Enterprises Ltd',
    email: 'moses@kato.co.ug',
    kycStatus: 'approved',
    accountType: 'business',
  );

  final _accounts = <ConnectedAccountModel>[
    ConnectedAccountModel(
      id: 'acc-001',
      provider: 'mtn',
      identifier: '+256770555123',
      connectedAt: DateTime(2025, 3, 15).millisecondsSinceEpoch,
    ),
    ConnectedAccountModel(
      id: 'acc-002',
      provider: 'stanbic',
      identifier: '1234567890',
      connectedAt: DateTime(2025, 6).millisecondsSinceEpoch,
    ),
  ];

  var _security = const SecuritySettingsModel(
    pinEnabled: true,
    biometricEnabled: true,
    twoStepEnabled: false,
    trustedDevices: ['iPhone 14 Pro', 'Samsung Galaxy S23'],
  );

  var _notifications = const NotificationPreferencesModel(
    paymentReceived: true,
    piaCards: true,
    pensionReminders: true,
    promotions: false,
  );

  final _merchants = <PinnedMerchantModel>[
    PinnedMerchantModel(
      id: 'pm-001',
      name: 'Kampala Supplies',
      identifier: '+256700111222',
      role: 'supplier',
      pinnedAt: DateTime(2025, 5, 10).millisecondsSinceEpoch,
    ),
    PinnedMerchantModel(
      id: 'pm-002',
      name: 'Mukwano Industries',
      identifier: '+256700333444',
      role: 'supplier',
      pinnedAt: DateTime(2025, 7, 20).millisecondsSinceEpoch,
    ),
    PinnedMerchantModel(
      id: 'pm-003',
      name: 'URA',
      identifier: 'TIN-1001234567',
      role: 'tax',
      pinnedAt: DateTime(2025, 8).millisecondsSinceEpoch,
    ),
  ];

  static const _faqs = [
    FaqItemModel(
      question: 'How do I send money?',
      answer:
          'Go to the Pay tab, tap Send, select a recipient, '
          'enter the amount, and confirm.',
    ),
    FaqItemModel(
      question: 'How do I link my NSSF account?',
      answer:
          'Go to Pay > Statutory > Pensions. Enter your NSSF '
          'number and follow the verification steps.',
    ),
    FaqItemModel(
      question: 'How do I export my transactions?',
      answer:
          'Go to Activity, tap the export icon, select a date '
          'range, and confirm. You will receive a CSV file.',
    ),
    FaqItemModel(
      question: 'What payment methods are supported?',
      answer:
          'We support mobile money (MTN, Airtel), bank '
          'transfers (Stanbic, DFCU, Equity, Centenary), '
          'and wallet-to-wallet transfers.',
    ),
    FaqItemModel(
      question: 'How do I change my PIN?',
      answer:
          'Go to More > Security. Your PIN is always enabled '
          'for security. Contact support to reset it.',
    ),
  ];

  @override
  Future<UserProfileModel> getProfile() async {
    await Future<void>.delayed(_readDelay);
    return _profile;
  }

  @override
  Future<UserProfileModel> updateProfile({
    String? fullName,
    String? businessName,
    String? email,
    KycAccountType? accountType,
  }) async {
    await Future<void>.delayed(_writeDelay);
    return _profile = _profile.copyWith(
      fullName: fullName ?? _profile.fullName,
      businessName: businessName ?? _profile.businessName,
      email: email ?? _profile.email,
      accountType: accountType?.name ?? _profile.accountType,
    );
  }

  @override
  Future<List<ConnectedAccountModel>> getConnectedAccounts() async {
    await Future<void>.delayed(_readDelay);
    return List.unmodifiable(_accounts);
  }

  @override
  Future<ConnectedAccountModel> connectAccount({
    required AccountProvider provider,
    required String identifier,
  }) async {
    await Future<void>.delayed(_writeDelay);
    final now = DateTime.now().millisecondsSinceEpoch;
    final account = ConnectedAccountModel(
      id: 'acc-$now',
      provider: provider.name,
      identifier: identifier,
      connectedAt: now,
    );
    _accounts.add(account);
    return account;
  }

  @override
  Future<void> disconnectAccount({required String accountId}) async {
    await Future<void>.delayed(_writeDelay);
    _accounts.removeWhere((a) => a.id == accountId);
  }

  @override
  Future<SecuritySettingsModel> getSecuritySettings() async {
    await Future<void>.delayed(_readDelay);
    return _security;
  }

  @override
  Future<SecuritySettingsModel> updateSecuritySettings({
    bool? biometricEnabled,
    bool? twoStepEnabled,
  }) async {
    await Future<void>.delayed(_writeDelay);
    return _security = _security.copyWith(
      biometricEnabled: biometricEnabled ?? _security.biometricEnabled,
      twoStepEnabled: twoStepEnabled ?? _security.twoStepEnabled,
    );
  }

  @override
  Future<NotificationPreferencesModel> getNotificationSettings() async {
    await Future<void>.delayed(_readDelay);
    return _notifications;
  }

  @override
  Future<NotificationPreferencesModel> updateNotificationSettings({
    bool? paymentReceived,
    bool? piaCards,
    bool? pensionReminders,
    bool? promotions,
  }) async {
    await Future<void>.delayed(_writeDelay);
    return _notifications = _notifications.copyWith(
      paymentReceived: paymentReceived ?? _notifications.paymentReceived,
      piaCards: piaCards ?? _notifications.piaCards,
      pensionReminders: pensionReminders ?? _notifications.pensionReminders,
      promotions: promotions ?? _notifications.promotions,
    );
  }

  @override
  Future<List<PinnedMerchantModel>> getPinnedMerchants() async {
    await Future<void>.delayed(_readDelay);
    return List.unmodifiable(_merchants);
  }

  @override
  Future<PinnedMerchantModel> updateMerchantRole({
    required String merchantId,
    required MerchantRole role,
  }) async {
    await Future<void>.delayed(_writeDelay);
    final index = _merchants.indexWhere((m) => m.id == merchantId);
    if (index == -1) {
      throw Exception('Merchant not found: $merchantId');
    }
    final updated = _merchants[index].copyWith(role: role.name);
    _merchants[index] = updated;
    return updated;
  }

  @override
  Future<void> unpinMerchant({required String merchantId}) async {
    await Future<void>.delayed(_writeDelay);
    _merchants.removeWhere((m) => m.id == merchantId);
  }

  @override
  Future<List<FaqItemModel>> getFaqs() async {
    await Future<void>.delayed(_readDelay);
    return _faqs;
  }
}
