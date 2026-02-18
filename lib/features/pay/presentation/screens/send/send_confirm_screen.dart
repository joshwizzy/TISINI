import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/pay/domain/entities/send_state.dart';
import 'package:tisini/features/pay/providers/send_controller_provider.dart';
import 'package:tisini/shared/widgets/cost_line.dart';
import 'package:tisini/shared/widgets/payee_card.dart';
import 'package:tisini/shared/widgets/route_chip.dart';

class SendConfirmScreen extends ConsumerWidget {
  const SendConfirmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sendState = ref.watch(sendControllerProvider);

    ref.listen<AsyncValue<SendState>>(sendControllerProvider, (_, next) {
      final state = next.valueOrNull;
      if (state is SendStateReceipt) {
        context.goNamed(
          RouteNames.sendReceipt,
          pathParameters: {'txId': state.receipt.transactionId},
        );
      } else if (state is SendStateFailed) {
        context.goNamed(RouteNames.sendFailed);
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
      body: sendState.when(
        data: (state) {
          if (state is SendStateProcessing) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is! SendStateConfirming) {
            return const Center(child: Text('Invalid state'));
          }

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Sending to', style: AppTypography.titleMedium),
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
                          .read(sendControllerProvider.notifier)
                          .confirmAndSend();
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
