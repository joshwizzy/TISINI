import 'package:tisini/core/enums.dart';
import 'package:tisini/features/more/domain/entities/connected_account.dart';
import 'package:tisini/features/more/domain/entities/faq_item.dart';
import 'package:tisini/features/more/domain/entities/notification_preferences.dart';
import 'package:tisini/features/more/domain/entities/pinned_merchant.dart';
import 'package:tisini/features/more/domain/entities/security_settings.dart';
import 'package:tisini/features/more/domain/entities/user_profile.dart';

abstract class MoreRepository {
  Future<UserProfile> getProfile();

  Future<UserProfile> updateProfile({
    String? fullName,
    String? businessName,
    String? email,
    KycAccountType? accountType,
  });

  Future<List<ConnectedAccount>> getConnectedAccounts();

  Future<ConnectedAccount> connectAccount({
    required AccountProvider provider,
    required String identifier,
  });

  Future<void> disconnectAccount({required String accountId});

  Future<SecuritySettings> getSecuritySettings();

  Future<SecuritySettings> updateSecuritySettings({
    bool? biometricEnabled,
    bool? twoStepEnabled,
  });

  Future<NotificationPreferences> getNotificationSettings();

  Future<NotificationPreferences> updateNotificationSettings({
    bool? paymentReceived,
    bool? piaCards,
    bool? pensionReminders,
    bool? promotions,
  });

  Future<List<PinnedMerchant>> getPinnedMerchants();

  Future<PinnedMerchant> updateMerchantRole({
    required String merchantId,
    required MerchantRole role,
  });

  Future<void> unpinMerchant({required String merchantId});

  Future<List<FaqItem>> getFaqs();
}
