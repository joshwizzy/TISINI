import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pia/domain/repositories/pia_repository.dart';
import 'package:tisini/features/pia/providers/pia_provider.dart';

void main() {
  group('piaRepositoryProvider', () {
    test('returns PiaRepository instance', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final repo = container.read(piaRepositoryProvider);
      expect(repo, isA<PiaRepository>());
    });
  });

  group('piaFeedProvider', () {
    test('returns list of pia cards', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(piaFeedProvider, (_, __) {});

      final cards = await container.read(piaFeedProvider.future);

      expect(cards, hasLength(7));
      expect(cards.first.id, 'pia-001');
      expect(cards.first.priority, PiaCardPriority.high);
    });
  });

  group('piaCardDetailProvider', () {
    test('returns card by id', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final provider = piaCardDetailProvider('pia-003');
      container.listen(provider, (_, __) {});

      final card = await container.read(provider.future);

      expect(card.id, 'pia-003');
      expect(card.title, 'New supplier detected');
    });
  });

  group('piaPinnedProvider', () {
    test('returns only pinned cards', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(piaPinnedProvider, (_, __) {});

      final pinned = await container.read(piaPinnedProvider.future);

      expect(pinned, hasLength(1));
      expect(pinned.first.id, 'pia-007');
      expect(pinned.first.isPinned, true);
    });
  });
}
