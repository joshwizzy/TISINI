import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pia/domain/entities/pia_action_state.dart';
import 'package:tisini/features/pia/providers/pia_provider.dart';

class PiaActionController extends AutoDisposeAsyncNotifier<PiaActionState> {
  @override
  Future<PiaActionState> build() async {
    return const PiaActionState.idle();
  }

  Future<void> executeAction({
    required String cardId,
    required String actionId,
    Map<String, dynamic> params = const {},
  }) async {
    state = AsyncData(
      PiaActionState.executing(cardId: cardId, actionId: actionId),
    );

    try {
      final repo = ref.read(piaRepositoryProvider);
      final message = await repo.executeAction(
        cardId: cardId,
        actionId: actionId,
        params: params,
      );

      ref
        ..invalidate(piaFeedProvider)
        ..invalidate(piaPinnedProvider);

      state = AsyncData(PiaActionState.success(message: message));
    } on Exception catch (e) {
      state = AsyncData(PiaActionState.failed(message: e.toString()));
    }
  }

  Future<void> dismiss(String cardId) async {
    try {
      final repo = ref.read(piaRepositoryProvider);
      await repo.updateCard(cardId, status: PiaCardStatus.dismissed);

      ref
        ..invalidate(piaFeedProvider)
        ..invalidate(piaPinnedProvider);

      state = const AsyncData(
        PiaActionState.success(message: 'Card dismissed'),
      );
    } on Exception catch (e) {
      state = AsyncData(PiaActionState.failed(message: e.toString()));
    }
  }

  Future<void> pin(String cardId) async {
    try {
      final repo = ref.read(piaRepositoryProvider);
      await repo.updateCard(cardId, isPinned: true);

      ref
        ..invalidate(piaFeedProvider)
        ..invalidate(piaPinnedProvider);

      state = const AsyncData(PiaActionState.success(message: 'Card pinned'));
    } on Exception catch (e) {
      state = AsyncData(PiaActionState.failed(message: e.toString()));
    }
  }

  Future<void> unpin(String cardId) async {
    try {
      final repo = ref.read(piaRepositoryProvider);
      await repo.updateCard(cardId, isPinned: false);

      ref
        ..invalidate(piaFeedProvider)
        ..invalidate(piaPinnedProvider);

      state = const AsyncData(PiaActionState.success(message: 'Card unpinned'));
    } on Exception catch (e) {
      state = AsyncData(PiaActionState.failed(message: e.toString()));
    }
  }

  void reset() {
    state = const AsyncData(PiaActionState.idle());
  }
}

final piaActionControllerProvider =
    AutoDisposeAsyncNotifierProvider<PiaActionController, PiaActionState>(
      PiaActionController.new,
    );
