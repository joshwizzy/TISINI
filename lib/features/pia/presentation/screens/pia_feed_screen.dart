import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/pia/domain/entities/pia_action.dart';
import 'package:tisini/features/pia/domain/entities/pia_card.dart';
import 'package:tisini/features/pia/presentation/widgets/pia_action_reminder_modal.dart';
import 'package:tisini/features/pia/presentation/widgets/pia_action_schedule_modal.dart';
import 'package:tisini/features/pia/presentation/widgets/pia_feed_list.dart';
import 'package:tisini/features/pia/providers/pia_action_controller.dart';
import 'package:tisini/features/pia/providers/pia_provider.dart';

class PiaFeedScreen extends ConsumerStatefulWidget {
  const PiaFeedScreen({super.key});

  @override
  ConsumerState<PiaFeedScreen> createState() => _PiaFeedScreenState();
}

class _PiaFeedScreenState extends ConsumerState<PiaFeedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onAction(PiaCard card, PiaAction action) {
    switch (action.type) {
      case PiaActionType.setReminder:
        _showReminderModal(card, action);
      case PiaActionType.schedulePayment:
        _showScheduleModal(card, action);
      case PiaActionType.askUserConfirmation:
        _showConfirmModal(card, action);
      case PiaActionType.prepareExport:
        ref
            .read(piaActionControllerProvider.notifier)
            .executeAction(
              cardId: card.id,
              actionId: action.id,
              params: action.params,
            );
      case PiaActionType.markAsPinned:
        ref.read(piaActionControllerProvider.notifier).pin(card.id);
    }
  }

  void _showReminderModal(PiaCard card, PiaAction action) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => PiaActionReminderModal(
        onConfirm: ({required date, amount}) {
          ref
              .read(piaActionControllerProvider.notifier)
              .executeAction(
                cardId: card.id,
                actionId: action.id,
                params: {
                  'date': date.toIso8601String(),
                  if (amount != null) 'amount': amount,
                },
              );
        },
      ),
    );
  }

  void _showScheduleModal(PiaCard card, PiaAction action) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => PiaActionScheduleModal(
        mode: PiaScheduleMode.schedule,
        params: action.params,
        onConfirm: (result) {
          ref
              .read(piaActionControllerProvider.notifier)
              .executeAction(
                cardId: card.id,
                actionId: action.id,
                params: result,
              );
        },
      ),
    );
  }

  void _showConfirmModal(PiaCard card, PiaAction action) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => PiaActionScheduleModal(
        mode: PiaScheduleMode.confirm,
        params: action.params,
        onConfirm: (result) {
          ref
              .read(piaActionControllerProvider.notifier)
              .executeAction(
                cardId: card.id,
                actionId: action.id,
                params: result,
              );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pia'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.darkBlue,
          unselectedLabelColor: AppColors.darkBlue50,
          indicatorColor: AppColors.cyan,
          labelStyle: AppTypography.labelLarge,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pinned'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _AllTab(onAction: _onAction),
          _PinnedTab(onAction: _onAction),
        ],
      ),
    );
  }
}

class _AllTab extends ConsumerWidget {
  const _AllTab({required this.onAction});

  final void Function(PiaCard card, PiaAction action) onAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(piaFeedProvider);

    return feedAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Text(
            'Something went wrong',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.error),
          ),
        ),
      ),
      data: (cards) => RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(piaFeedProvider);
          await ref.read(piaFeedProvider.future);
        },
        child: PiaFeedList(
          cards: cards,
          onTapCard: (card) => context.goNamed(
            RouteNames.piaCardDetail,
            pathParameters: {'id': card.id},
          ),
          onAction: onAction,
          onDismiss: (card) =>
              ref.read(piaActionControllerProvider.notifier).dismiss(card.id),
          onPin: (card) =>
              ref.read(piaActionControllerProvider.notifier).pin(card.id),
        ),
      ),
    );
  }
}

class _PinnedTab extends ConsumerWidget {
  const _PinnedTab({required this.onAction});

  final void Function(PiaCard card, PiaAction action) onAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinnedAsync = ref.watch(piaPinnedProvider);

    return pinnedAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Text(
            'Something went wrong',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.error),
          ),
        ),
      ),
      data: (cards) => RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(piaPinnedProvider);
          await ref.read(piaPinnedProvider.future);
        },
        child: PiaFeedList(
          cards: cards,
          emptyMessage: 'No pinned items yet',
          onTapCard: (card) => context.goNamed(
            RouteNames.piaCardDetail,
            pathParameters: {'id': card.id},
          ),
          onAction: onAction,
          onDismiss: (card) =>
              ref.read(piaActionControllerProvider.notifier).dismiss(card.id),
          onPin: (card) =>
              ref.read(piaActionControllerProvider.notifier).pin(card.id),
        ),
      ),
    );
  }
}
