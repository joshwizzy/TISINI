import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pia/domain/entities/pia_action.dart';
import 'package:tisini/features/pia/domain/entities/pia_card.dart';
import 'package:tisini/features/pia/presentation/widgets/pia_action_reminder_modal.dart';
import 'package:tisini/features/pia/presentation/widgets/pia_action_schedule_modal.dart';
import 'package:tisini/features/pia/providers/pia_action_controller.dart';
import 'package:tisini/features/pia/providers/pia_provider.dart';
import 'package:tisini/shared/widgets/pia_card_widget.dart';

class PiaCardDetailScreen extends ConsumerWidget {
  const PiaCardDetailScreen({required this.id, super.key});

  final String id;

  void _onAction(
    BuildContext context,
    WidgetRef ref,
    PiaCard card,
    PiaAction action,
  ) {
    switch (action.type) {
      case PiaActionType.setReminder:
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
      case PiaActionType.schedulePayment:
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
      case PiaActionType.askUserConfirmation:
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardAsync = ref.watch(piaCardDetailProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insight'),
        actions: [
          cardAsync.whenOrNull(
                data: (card) => PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'dismiss':
                        ref
                            .read(piaActionControllerProvider.notifier)
                            .dismiss(card.id);
                        Navigator.of(context).pop();
                      case 'pin':
                        ref
                            .read(piaActionControllerProvider.notifier)
                            .pin(card.id);
                      case 'unpin':
                        ref
                            .read(piaActionControllerProvider.notifier)
                            .unpin(card.id);
                    }
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'dismiss',
                      child: Text('Dismiss'),
                    ),
                    PopupMenuItem(
                      value: card.isPinned ? 'unpin' : 'pin',
                      child: Text(card.isPinned ? 'Unpin' : 'Pin'),
                    ),
                  ],
                ),
              ) ??
              const SizedBox.shrink(),
        ],
      ),
      body: cardAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Text(
              'Failed to load insight',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.error),
            ),
          ),
        ),
        data: (card) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: PiaCardWidget(
            card: card,
            isExpanded: true,
            onAction: (action) => _onAction(context, ref, card, action),
          ),
        ),
      ),
    );
  }
}
