import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/pay/providers/funding_sources_provider.dart';
import 'package:tisini/features/pay/providers/topup_controller_provider.dart';
import 'package:tisini/shared/widgets/funding_source_card.dart';

class TopupSourceScreen extends ConsumerWidget {
  const TopupSourceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sourcesAsync = ref.watch(fundingSourcesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Top Up'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select funding source',
              style: AppTypography.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: sourcesAsync.when(
                data: (sources) => ListView.separated(
                  itemCount: sources.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final source = sources[index];
                    return FundingSourceCard(
                      source: source,
                      onTap: () {
                        ref
                            .read(topupControllerProvider.notifier)
                            .selectSource(source);
                        context.goNamed(RouteNames.topupAmount);
                      },
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) =>
                    const Center(child: Text('Failed to load sources')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
