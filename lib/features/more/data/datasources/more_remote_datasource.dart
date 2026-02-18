import 'package:tisini/core/enums.dart';
import 'package:tisini/features/more/data/models/connected_account_model.dart';
import 'package:tisini/features/more/data/models/faq_item_model.dart';
import 'package:tisini/features/more/data/models/notification_preferences_model.dart';
import 'package:tisini/features/more/data/models/pinned_merchant_model.dart';
import 'package:tisini/features/more/data/models/security_settings_model.dart';
import 'package:tisini/features/more/data/models/user_profile_model.dart';

abstract class MoreRemoteDatasource {
  Future<UserProfileModel> getProfile();

  Future<UserProfileModel> updateProfile({
    String? fullName,
    String? businessName,
    String? email,
    KycAccountType? accountType,
  });

  Future<List<ConnectedAccountModel>> getConnectedAccounts();

  Future<ConnectedAccountModel> connectAccount({
    required AccountProvider provider,
    required String identifier,
  });

  Future<void> disconnectAccount({required String accountId});

  Future<SecuritySettingsModel> getSecuritySettings();

  Future<SecuritySettingsModel> updateSecuritySettings({
    bool? biometricEnabled,
    bool? twoStepEnabled,
  });

  Future<NotificationPreferencesModel> getNotificationSettings();

  Future<NotificationPreferencesModel> updateNotificationSettings({
    bool? paymentReceived,
    bool? piaCards,
    bool? pensionReminders,
    bool? promotions,
  });

  Future<List<PinnedMerchantModel>> getPinnedMerchants();

  Future<PinnedMerchantModel> updateMerchantRole({
    required String merchantId,
    required MerchantRole role,
  });

  Future<void> unpinMerchant({required String merchantId});

  Future<List<FaqItemModel>> getFaqs();
}
