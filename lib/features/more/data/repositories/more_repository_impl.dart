import 'package:tisini/core/enums.dart';
import 'package:tisini/features/more/data/datasources/more_remote_datasource.dart';
import 'package:tisini/features/more/domain/entities/connected_account.dart';
import 'package:tisini/features/more/domain/entities/faq_item.dart';
import 'package:tisini/features/more/domain/entities/notification_preferences.dart';
import 'package:tisini/features/more/domain/entities/pinned_merchant.dart';
import 'package:tisini/features/more/domain/entities/security_settings.dart';
import 'package:tisini/features/more/domain/entities/user_profile.dart';
import 'package:tisini/features/more/domain/repositories/more_repository.dart';

class MoreRepositoryImpl implements MoreRepository {
  MoreRepositoryImpl({required MoreRemoteDatasource datasource})
    : _datasource = datasource;

  final MoreRemoteDatasource _datasource;

  @override
  Future<UserProfile> getProfile() async {
    final model = await _datasource.getProfile();
    return model.toEntity();
  }

  @override
  Future<UserProfile> updateProfile({
    String? fullName,
    String? businessName,
    String? email,
    KycAccountType? accountType,
  }) async {
    final model = await _datasource.updateProfile(
      fullName: fullName,
      businessName: businessName,
      email: email,
      accountType: accountType,
    );
    return model.toEntity();
  }

  @override
  Future<List<ConnectedAccount>> getConnectedAccounts() async {
    final models = await _datasource.getConnectedAccounts();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<ConnectedAccount> connectAccount({
    required AccountProvider provider,
    required String identifier,
  }) async {
    final model = await _datasource.connectAccount(
      provider: provider,
      identifier: identifier,
    );
    return model.toEntity();
  }

  @override
  Future<void> disconnectAccount({required String accountId}) async {
    await _datasource.disconnectAccount(accountId: accountId);
  }

  @override
  Future<SecuritySettings> getSecuritySettings() async {
    final model = await _datasource.getSecuritySettings();
    return model.toEntity();
  }

  @override
  Future<SecuritySettings> updateSecuritySettings({
    bool? biometricEnabled,
    bool? twoStepEnabled,
  }) async {
    final model = await _datasource.updateSecuritySettings(
      biometricEnabled: biometricEnabled,
      twoStepEnabled: twoStepEnabled,
    );
    return model.toEntity();
  }

  @override
  Future<NotificationPreferences> getNotificationSettings() async {
    final model = await _datasource.getNotificationSettings();
    return model.toEntity();
  }

  @override
  Future<NotificationPreferences> updateNotificationSettings({
    bool? paymentReceived,
    bool? piaCards,
    bool? pensionReminders,
    bool? promotions,
  }) async {
    final model = await _datasource.updateNotificationSettings(
      paymentReceived: paymentReceived,
      piaCards: piaCards,
      pensionReminders: pensionReminders,
      promotions: promotions,
    );
    return model.toEntity();
  }

  @override
  Future<List<PinnedMerchant>> getPinnedMerchants() async {
    final models = await _datasource.getPinnedMerchants();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<PinnedMerchant> updateMerchantRole({
    required String merchantId,
    required MerchantRole role,
  }) async {
    final model = await _datasource.updateMerchantRole(
      merchantId: merchantId,
      role: role,
    );
    return model.toEntity();
  }

  @override
  Future<void> unpinMerchant({required String merchantId}) async {
    await _datasource.unpinMerchant(merchantId: merchantId);
  }

  @override
  Future<List<FaqItem>> getFaqs() async {
    final models = await _datasource.getFaqs();
    return models.map((m) => m.toEntity()).toList();
  }
}
