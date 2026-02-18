import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/pay/domain/entities/topup_state.dart';
import 'package:tisini/features/pay/providers/topup_controller_provider.dart';
import 'package:tisini/shared/widgets/cost_line.dart';
import 'package:tisini/shared/widgets/funding_source_card.dart';

class TopupConfirmScreen extends ConsumerWidget {
  const TopupConfirmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topupState = ref.watch(topupControllerProvider);

    ref.listen<AsyncValue<TopupState>>(topupControllerProvider, (_, next) {
      final state = next.valueOrNull;
      if (state is TopupStateReceipt) {
        context.goNamed(
          RouteNames.topupReceipt,
          pathParameters: {'txId': state.receipt.transactionId},
        );
      } else if (state is TopupStateFailed) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.message)));
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Confirm Top Up'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: topupState.when(
        data: (state) {
          if (state is TopupStateProcessing) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is! TopupStateConfirming) {
            return const Center(child: Text('Invalid state'));
          }

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('From', style: AppTypography.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                FundingSourceCard(source: state.source, isSelected: true),
                const SizedBox(height: AppSpacing.lg),
                CostLine(
                  amount: state.amount,
                  fee: state.fee,
                  total: state.total,
                  currency: state.currency,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      ref
                          .read(topupControllerProvider.notifier)
                          .confirmAndTopup();
                    },
                    child: const Text('Top up'),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Something went wrong')),
      ),
    );
  }
}
