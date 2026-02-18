import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/home/providers/badges_provider.dart';
import 'package:tisini/features/home/providers/dashboard_indicators_provider.dart';
import 'package:tisini/features/home/providers/pia_guidance_provider.dart';
import 'package:tisini/features/home/providers/tisini_index_provider.dart';
import 'package:tisini/shared/widgets/badge_chip.dart';
import 'package:tisini/shared/widgets/dashboard_bar_indicator.dart';
import 'package:tisini/shared/widgets/pia_card_widget.dart';
import 'package:tisini/shared/widgets/tisini_index_ring.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: const [
          SizedBox(height: AppSpacing.md),
          _IndexSection(),
          SizedBox(height: AppSpacing.lg),
          _IndicatorsSection(),
          SizedBox(height: AppSpacing.lg),
          _BadgesSection(),
          SizedBox(height: AppSpacing.lg),
          _GuidanceSection(),
        ],
      ),
    );
  }
}

class _IndexSection extends ConsumerWidget {
  const _IndexSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indexAsync = ref.watch(tisiniIndexProvider);

    return indexAsync.when(
      data: (index) => Column(
        children: [
          Center(child: TisiniIndexRing(score: index.score, showLabel: true)),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                index.changeAmount >= 0
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
                color: index.changeAmount >= 0
                    ? AppColors.success
                    : AppColors.error,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '${index.changeAmount >= 0 ? '+' : ''}'
                '${index.changeAmount.toStringAsFixed(1)} — '
                '${index.changeReason}',
                style: AppTypography.bodySmall,
              ),
            ],
          ),
        ],
      ),
      loading: () => const SizedBox(
        height: 250,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) =>
          const Text('Unable to load index', style: AppTypography.bodyMedium),
    );
  }
}

class _IndicatorsSection extends ConsumerWidget {
  const _IndicatorsSection();

  static Color _indicatorColor(IndicatorType type) {
    return switch (type) {
      IndicatorType.paymentConsistency => AppColors.cyan,
      IndicatorType.complianceReadiness => AppColors.green,
      IndicatorType.businessMomentum => AppColors.warning,
      IndicatorType.dataCompleteness => AppColors.darkBlue,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indicatorsAsync = ref.watch(dashboardIndicatorsProvider);

    return indicatorsAsync.when(
      data: (indicators) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Indicators', style: AppTypography.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          ...indicators.map(
            (i) => DashboardBarIndicator(
              label: i.label,
              value: i.value,
              maxValue: i.maxValue,
              color: _indicatorColor(i.type),
            ),
          ),
        ],
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _BadgesSection extends ConsumerWidget {
  const _BadgesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badgesAsync = ref.watch(badgesProvider);

    return badgesAsync.when(
      data: (badges) {
        if (badges.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Badges', style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: badges.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, index) {
                  final badge = badges[index];
                  return BadgeChip(
                    label: badge.label,
                    iconName: badge.iconName,
                    isEarned: badge.isEarned,
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _GuidanceSection extends ConsumerWidget {
  const _GuidanceSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guidanceAsync = ref.watch(piaGuidanceProvider);

    return guidanceAsync.when(
      data: (card) {
        if (card == null) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Guidance', style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            PiaCardWidget(card: card, isExpanded: true),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
