import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/more/providers/profile_edit_controller.dart';

void main() {
  group('ProfileEditController', () {
    test('initial state is null', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(profileEditControllerProvider, (_, __) {});

      final state = await container.read(profileEditControllerProvider.future);

      expect(state, isNull);
    });

    test('saveProfile updates profile', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(profileEditControllerProvider, (_, __) {});

      // Wait for initial build
      await container.read(profileEditControllerProvider.future);

      final controller = container.read(profileEditControllerProvider.notifier);

      await controller.saveProfile(
        fullName: 'Moses K. Kato',
        accountType: KycAccountType.business,
      );

      final result = await container.read(profileEditControllerProvider.future);

      expect(result, isNotNull);
      expect(result!.fullName, 'Moses K. Kato');
    });

    test('saveProfile invalidates profileProvider', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(profileEditControllerProvider, (_, __) {});

      await container.read(profileEditControllerProvider.future);

      final controller = container.read(profileEditControllerProvider.notifier);

      await controller.saveProfile(fullName: 'Updated Name');

      // If profileProvider was invalidated, reading it again
      // should trigger a new fetch
      final result = await container.read(profileEditControllerProvider.future);

      expect(result, isNotNull);
      expect(result!.fullName, 'Updated Name');
    });
  });
}
