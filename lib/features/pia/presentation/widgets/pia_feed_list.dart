import 'package:flutter/material.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/features/pia/domain/entities/pia_action.dart';
import 'package:tisini/features/pia/domain/entities/pia_card.dart';
import 'package:tisini/shared/widgets/pia_card_widget.dart';

class PiaFeedList extends StatelessWidget {
  const PiaFeedList({
    required this.cards,
    super.key,
    this.onTapCard,
    this.onAction,
    this.onDismiss,
    this.onPin,
    this.emptyMessage = 'No insights yet',
  });

  final List<PiaCard> cards;
  final void Function(PiaCard card)? onTapCard;
  final void Function(PiaCard card, PiaAction action)? onAction;
  final void Function(PiaCard card)? onDismiss;
  final void Function(PiaCard card)? onPin;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Text(
            emptyMessage,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.darkBlue50,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      itemCount: cards.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final card = cards[index];
        return Dismissible(
          key: ValueKey(card.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: AppSpacing.screenPadding),
            color: AppColors.error,
            child: const Icon(Icons.close, color: Colors.white),
          ),
          onDismissed: (_) => onDismiss?.call(card),
          child: GestureDetector(
            onLongPress: () => onPin?.call(card),
            child: PiaCardWidget(
              card: card,
              onTap: () => onTapCard?.call(card),
              onAction: (action) => onAction?.call(card, action),
            ),
          ),
        );
      },
    );
  }
}
