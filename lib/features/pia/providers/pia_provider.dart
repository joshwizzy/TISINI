import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/features/pia/data/datasources/mock_pia_remote_datasource.dart';
import 'package:tisini/features/pia/data/repositories/pia_repository_impl.dart';
import 'package:tisini/features/pia/domain/entities/pia_card.dart';
import 'package:tisini/features/pia/domain/repositories/pia_repository.dart';

final piaRepositoryProvider = Provider<PiaRepository>((ref) {
  return PiaRepositoryImpl(datasource: MockPiaRemoteDatasource());
});

final piaFeedProvider = FutureProvider.autoDispose<List<PiaCard>>((ref) async {
  final repository = ref.watch(piaRepositoryProvider);
  final result = await repository.getCards();
  return result.cards;
});

final piaCardDetailProvider = FutureProvider.autoDispose
    .family<PiaCard, String>((ref, id) async {
      final repository = ref.watch(piaRepositoryProvider);
      return repository.getCard(id);
    });

final piaPinnedProvider = FutureProvider.autoDispose<List<PiaCard>>((
  ref,
) async {
  final repository = ref.watch(piaRepositoryProvider);
  final result = await repository.getCards();
  return result.cards.where((c) => c.isPinned).toList();
});
