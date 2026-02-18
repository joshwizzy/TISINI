import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/pay/domain/entities/business_pay_state.dart';
import 'package:tisini/features/pay/providers/business_pay_controller_provider.dart';
import 'package:tisini/shared/widgets/cost_line.dart';
import 'package:tisini/shared/widgets/payee_card.dart';
import 'package:tisini/shared/widgets/route_chip.dart';

class BusinessConfirmScreen extends ConsumerWidget {
  const BusinessConfirmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bizState = ref.watch(businessPayControllerProvider);

    ref.listen<AsyncValue<BusinessPayState>>(businessPayControllerProvider, (
      _,
      next,
    ) {
      final state = next.valueOrNull;
      if (state is BusinessPayStateReceipt) {
        context.goNamed(
          RouteNames.businessReceipt,
          pathParameters: {'txId': state.receipt.transactionId},
        );
      } else if (state is BusinessPayStateFailed) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.message)));
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Confirm'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: bizState.when(
        data: (state) {
          if (state is BusinessPayStateProcessing) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is! BusinessPayStateConfirming) {
            return const Center(child: Text('Invalid state'));
          }

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Paying', style: AppTypography.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                PayeeCard(payee: state.payee),
                const SizedBox(height: AppSpacing.lg),
                const Text('Via', style: AppTypography.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                RouteChip(
                  rail: state.route.rail,
                  label: state.route.label,
                  isSelected: true,
                ),
                if (state.reference != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Ref: ${state.reference}',
                    style: AppTypography.bodyMedium,
                  ),
                ],
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
                          .read(businessPayControllerProvider.notifier)
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
