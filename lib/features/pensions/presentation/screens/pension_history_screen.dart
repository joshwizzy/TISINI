import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pensions/domain/entities/pension_contribution.dart';
import 'package:tisini/features/pensions/presentation/widgets/contribution_row.dart';
import 'package:tisini/features/pensions/providers/pension_provider.dart';

class PensionHistoryScreen extends ConsumerStatefulWidget {
  const PensionHistoryScreen({super.key});

  @override
  ConsumerState<PensionHistoryScreen> createState() =>
      _PensionHistoryScreenState();
}

class _PensionHistoryScreenState extends ConsumerState<PensionHistoryScreen> {
  ContributionStatus? _filter;

  List<PensionContribution> _applyFilter(
    List<PensionContribution> contributions,
  ) {
    if (_filter == null) return contributions;
    return contributions.where((c) => c.status == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(pensionHistoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Contribution History'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
                vertical: AppSpacing.sm,
              ),
              children: [
                _FilterChip(
                  label: 'All',
                  isSelected: _filter == null,
                  onTap: () => setState(() => _filter = null),
                ),
                const SizedBox(width: AppSpacing.sm),
                _FilterChip(
                  label: 'Completed',
                  isSelected: _filter == ContributionStatus.completed,
                  onTap: () =>
                      setState(() => _filter = ContributionStatus.completed),
                ),
                const SizedBox(width: AppSpacing.sm),
                _FilterChip(
                  label: 'Pending',
                  isSelected: _filter == ContributionStatus.pending,
                  onTap: () =>
                      setState(() => _filter = ContributionStatus.pending),
                ),
                const SizedBox(width: AppSpacing.sm),
                _FilterChip(
                  label: 'Failed',
                  isSelected: _filter == ContributionStatus.failed,
                  onTap: () =>
                      setState(() => _filter = ContributionStatus.failed),
                ),
              ],
            ),
          ),
          Expanded(
            child: historyAsync.when(
              data: (contributions) {
                final filtered = _applyFilter(contributions);
                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      'No contributions found',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) =>
                      ContributionRow(contribution: filtered[index]),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) =>
                  const Center(child: Text('Failed to load history')),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.darkBlue : AppColors.cardWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.darkBlue : AppColors.cardBorder,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: isSelected ? Colors.white : AppColors.darkBlue,
          ),
        ),
      ),
    );
  }
}
