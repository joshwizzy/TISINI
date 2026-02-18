import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/pensions/domain/entities/pension_contribute_state.dart';
import 'package:tisini/features/pensions/providers/pension_contribute_controller.dart';
import 'package:tisini/shared/widgets/cost_line.dart';
import 'package:tisini/shared/widgets/route_chip.dart';

class PensionConfirmScreen extends ConsumerWidget {
  const PensionConfirmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerState = ref.watch(pensionContributeControllerProvider);

    ref.listen<AsyncValue<PensionContributeState>>(
      pensionContributeControllerProvider,
      (_, next) {
        final state = next.valueOrNull;
        if (state is PensionContributeReceipt) {
          context.goNamed(
            RouteNames.pensionReceipt,
            pathParameters: {'txId': state.receipt.transactionId},
          );
        } else if (state is PensionContributeFailed) {
          context.goNamed(RouteNames.pensionHub);
        }
      },
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Confirm'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: controllerState.when(
        data: (state) {
          if (state is PensionContributeProcessing) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is! PensionContributeConfirming) {
            return const Center(child: Text('Invalid state'));
          }

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Contributing to', style: AppTypography.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                const Text('NSSF Pension', style: AppTypography.headlineSmall),
                Text(
                  state.reference,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                const Text('Via', style: AppTypography.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                RouteChip(
                  rail: state.route.rail,
                  label: state.route.label,
                  isSelected: true,
                ),
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
                          .read(pensionContributeControllerProvider.notifier)
                          .confirmAndPay();
                    },
                    child: const Text('Pay'),
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
