import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_radii.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/home/domain/entities/attention_item.dart';
import 'package:tisini/features/home/providers/attention_items_provider.dart';

class AttentionListScreen extends ConsumerWidget {
  const AttentionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(attentionItemsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Attention'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: itemsAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: AppColors.green,
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text('All caught up', style: AppTypography.headlineMedium),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (_, index) => _AttentionCard(item: items[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(
          child: Text('Unable to load items', style: AppTypography.bodyMedium),
        ),
      ),
    );
  }
}

class _AttentionCard extends StatelessWidget {
  const _AttentionCard({required this.item});

  final AttentionItem item;

  Color get _priorityColor => switch (item.priority) {
    PiaCardPriority.high => AppColors.zoneRed,
    PiaCardPriority.medium => AppColors.cyan,
    PiaCardPriority.low => AppColors.grey,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: AppRadii.cardBorder,
        border: Border(left: BorderSide(color: _priorityColor, width: 4)),
        boxShadow: AppShadows.cardShadow,
      ),
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.title, style: AppTypography.titleMedium),
          const SizedBox(height: 4),
          Text(item.description, style: AppTypography.bodySmall),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.go(item.actionRoute),
              child: Text(
                item.actionLabel,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.cyan,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
