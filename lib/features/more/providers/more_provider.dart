import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/more/data/datasources/mock_more_remote_datasource.dart';
import 'package:tisini/features/more/data/repositories/more_repository_impl.dart';
import 'package:tisini/features/more/domain/entities/connected_account.dart';
import 'package:tisini/features/more/domain/entities/faq_item.dart';
import 'package:tisini/features/more/domain/entities/notification_preferences.dart';
import 'package:tisini/features/more/domain/entities/pinned_merchant.dart';
import 'package:tisini/features/more/domain/entities/security_settings.dart';
import 'package:tisini/features/more/domain/entities/user_profile.dart';
import 'package:tisini/features/more/domain/repositories/more_repository.dart';

final moreRepositoryProvider = Provider<MoreRepository>((ref) {
  return MoreRepositoryImpl(datasource: MockMoreRemoteDatasource());
});

final profileProvider = FutureProvider.autoDispose<UserProfile>((ref) async {
  final repository = ref.watch(moreRepositoryProvider);
  return repository.getProfile();
});

final connectedAccountsProvider =
    FutureProvider.autoDispose<List<ConnectedAccount>>((ref) async {
      final repository = ref.watch(moreRepositoryProvider);
      return repository.getConnectedAccounts();
    });

final securitySettingsProvider = FutureProvider.autoDispose<SecuritySettings>((
  ref,
) async {
  final repository = ref.watch(moreRepositoryProvider);
  return repository.getSecuritySettings();
});

final notificationSettingsProvider =
    FutureProvider.autoDispose<NotificationPreferences>((ref) async {
      final repository = ref.watch(moreRepositoryProvider);
      return repository.getNotificationSettings();
    });

final pinnedMerchantsProvider =
    FutureProvider.autoDispose<List<PinnedMerchant>>((ref) async {
      final repository = ref.watch(moreRepositoryProvider);
      return repository.getPinnedMerchants();
    });

final faqsProvider = FutureProvider.autoDispose<List<FaqItem>>((ref) async {
  final repository = ref.watch(moreRepositoryProvider);
  return repository.getFaqs();
});

final updateMerchantRoleProvider = FutureProvider.autoDispose
    .family<PinnedMerchant, ({String id, MerchantRole role})>((
      ref,
      params,
    ) async {
      final repository = ref.watch(moreRepositoryProvider);
      return repository.updateMerchantRole(
        merchantId: params.id,
        role: params.role,
      );
    });
