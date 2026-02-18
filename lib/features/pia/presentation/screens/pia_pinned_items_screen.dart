import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/pia/presentation/widgets/pia_feed_list.dart';
import 'package:tisini/features/pia/providers/pia_action_controller.dart';
import 'package:tisini/features/pia/providers/pia_provider.dart';

class PiaPinnedItemsScreen extends ConsumerWidget {
  const PiaPinnedItemsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinnedAsync = ref.watch(piaPinnedProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pinned items')),
      body: pinnedAsync.when(
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
        data: (cards) => PiaFeedList(
          cards: cards,
          emptyMessage: 'No pinned items yet',
          onTapCard: (card) => context.goNamed(
            RouteNames.piaCardDetail,
            pathParameters: {'id': card.id},
          ),
          onDismiss: (card) =>
              ref.read(piaActionControllerProvider.notifier).unpin(card.id),
          onPin: (card) =>
              ref.read(piaActionControllerProvider.notifier).unpin(card.id),
        ),
      ),
    );
  }
}
