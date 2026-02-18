import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/pensions/domain/entities/pension_reminder.dart';
import 'package:tisini/features/pensions/presentation/widgets/contribution_row.dart';
import 'package:tisini/features/pensions/presentation/widgets/next_due_banner.dart';
import 'package:tisini/features/pensions/presentation/widgets/pension_status_card.dart';
import 'package:tisini/features/pensions/providers/pension_provider.dart';

String _formatAmount(double amount) {
  final fmt = NumberFormat.currency(symbol: '', decimalDigits: 0);
  return 'UGX ${fmt.format(amount)}';
}

class PensionHubScreen extends ConsumerWidget {
  const PensionHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(pensionStatusProvider);
    final historyAsync = ref.watch(pensionHistoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pensions'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: statusAsync.when(
        data: (status) => ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            PensionStatusCard(status: status),
            const SizedBox(height: AppSpacing.md),
            NextDueBanner(
              nextDueDate: status.nextDueDate,
              nextDueAmount: status.nextDueAmount,
              currency: status.currency,
              onContribute: () => context.goNamed(RouteNames.pensionContribute),
            ),
            if (status.activeReminders.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              const Text('Reminders', style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              ...status.activeReminders.map((r) => _ReminderTile(reminder: r)),
            ],
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Contributions',
                  style: AppTypography.titleMedium,
                ),
                GestureDetector(
                  onTap: () => context.goNamed(RouteNames.pensionHistory),
                  child: Text(
                    'See all',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.darkBlue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            historyAsync.when(
              data: (contributions) {
                final preview = contributions.take(3).toList();
                if (preview.isEmpty) {
                  return Text(
                    'No contributions yet',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.grey,
                    ),
                  );
                }
                return Column(
                  children: preview
                      .map((c) => ContributionRow(contribution: c))
                      .toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Text(
                'Failed to load history',
                style: AppTypography.bodyMedium,
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(
          child: Text(
            'Failed to load pension status',
            style: AppTypography.bodyMedium,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goNamed(RouteNames.pensionContribute),
        label: const Text('Contribute'),
      ),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({required this.reminder});

  final PensionReminder reminder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          const Icon(Icons.alarm, size: 20, color: AppColors.grey),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              DateFormat('dd MMM yyyy').format(reminder.reminderDate),
              style: AppTypography.bodyMedium,
            ),
          ),
          if (reminder.amount != null)
            Text(
              _formatAmount(reminder.amount!),
              style: AppTypography.bodySmall.copyWith(color: AppColors.grey),
            ),
        ],
      ),
    );
  }
}
