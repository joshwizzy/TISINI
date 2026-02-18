import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/more/domain/entities/user_profile.dart';
import 'package:tisini/features/more/providers/more_provider.dart';

class ProfileEditController extends AutoDisposeAsyncNotifier<UserProfile?> {
  @override
  Future<UserProfile?> build() async => null;

  Future<void> saveProfile({
    String? fullName,
    String? businessName,
    String? email,
    KycAccountType? accountType,
  }) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(moreRepositoryProvider);
      final updated = await repository.updateProfile(
        fullName: fullName,
        businessName: businessName,
        email: email,
        accountType: accountType,
      );
      state = AsyncData(updated);
      ref.invalidate(profileProvider);
    } on Exception catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

final profileEditControllerProvider =
    AutoDisposeAsyncNotifierProvider<ProfileEditController, UserProfile?>(
      ProfileEditController.new,
    );
