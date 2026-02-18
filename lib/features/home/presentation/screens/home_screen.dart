import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_radii.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/home/providers/pia_guidance_provider.dart';
import 'package:tisini/features/home/providers/recent_transactions_provider.dart';
import 'package:tisini/features/home/providers/tisini_index_provider.dart';
import 'package:tisini/features/home/providers/wallet_balance_provider.dart';
import 'package:tisini/shared/widgets/pia_card_widget.dart';
import 'package:tisini/shared/widgets/tisini_index_ring.dart';
import 'package:tisini/shared/widgets/transaction_row.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          ref
            ..invalidate(walletBalanceProvider)
            ..invalidate(tisiniIndexProvider)
            ..invalidate(piaGuidanceProvider)
            ..invalidate(recentTransactionsProvider);
        },
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: const [
              _WelcomeHeader(),
              SizedBox(height: AppSpacing.md),
              _WalletBalanceCard(),
              SizedBox(height: AppSpacing.lg),
              _QuickActionsRow(),
              SizedBox(height: AppSpacing.lg),
              _TisiniIndexMini(),
              SizedBox(height: AppSpacing.lg),
              _PiaGuidanceSection(),
              SizedBox(height: AppSpacing.lg),
              _RecentTransactions(),
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  @override
  Widget build(BuildContext context) {
    return const Text('Welcome back', style: AppTypography.headlineLarge);
  }
}

class _WalletBalanceCard extends ConsumerWidget {
  const _WalletBalanceCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(walletBalanceProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.darkBlue,
        borderRadius: AppRadii.cardBorder,
      ),
      child: balanceAsync.when(
        data: (balance) {
          final formatted = NumberFormat.currency(
            symbol: '',
            decimalDigits: 0,
          ).format(balance.balance);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Available balance',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.white.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${balance.currency} $formatted',
                style: AppTypography.amountLarge.copyWith(
                  color: AppColors.white,
                ),
              ),
            ],
          );
        },
        loading: () => const SizedBox(
          height: 60,
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.white,
              strokeWidth: 2,
            ),
          ),
        ),
        error: (_, __) => Text(
          'Unable to load balance',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _QuickAction(
          icon: PhosphorIconsBold.paperPlaneTilt,
          label: 'Send',
          onTap: () => context.goNamed(RouteNames.sendRecipient),
        ),
        _QuickAction(
          icon: PhosphorIconsBold.handCoins,
          label: 'Request',
          onTap: () => context.goNamed(RouteNames.payHub),
        ),
        _QuickAction(
          icon: PhosphorIconsBold.qrCode,
          label: 'Scan',
          onTap: () => context.goNamed(RouteNames.payHub),
        ),
        _QuickAction(
          icon: PhosphorIconsBold.plus,
          label: 'Top Up',
          onTap: () => context.goNamed(RouteNames.payHub),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.darkBlue, size: 24),
          ),
          const SizedBox(height: 6),
          Text(label, style: AppTypography.labelSmall),
        ],
      ),
    );
  }
}

class _TisiniIndexMini extends ConsumerWidget {
  const _TisiniIndexMini();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indexAsync = ref.watch(tisiniIndexProvider);

    return indexAsync.when(
      data: (index) => GestureDetector(
        onTap: () => context.goNamed(RouteNames.dashboard),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          decoration: BoxDecoration(
            color: AppColors.cardWhite,
            borderRadius: AppRadii.cardBorder,
            boxShadow: AppShadows.cardShadow,
          ),
          child: Row(
            children: [
              TisiniIndexRing(score: index.score, size: 80),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'tisini index',
                      style: AppTypography.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      index.changeReason,
                      style: AppTypography.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(
                PhosphorIconsBold.caretRight,
                color: AppColors.grey,
                size: 20,
              ),
            ],
          ),
        ),
      ),
      loading: () => const SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _PiaGuidanceSection extends ConsumerWidget {
  const _PiaGuidanceSection();

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
            PiaCardWidget(
              card: card,
              onTap: () => context.goNamed(RouteNames.piaFeed),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _RecentTransactions extends ConsumerWidget {
  const _RecentTransactions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(recentTransactionsProvider);

    return transactionsAsync.when(
      data: (transactions) {
        if (transactions.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent transactions',
                  style: AppTypography.titleMedium,
                ),
                GestureDetector(
                  onTap: () => context.goNamed(RouteNames.activityList),
                  child: Text(
                    'See all',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.cyan,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ...transactions.map((tx) => TransactionRow(transaction: tx)),
          ],
        );
      },
      loading: () => const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const Text(
        'Unable to load transactions',
        style: AppTypography.bodyMedium,
      ),
    );
  }
}
