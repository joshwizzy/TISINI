import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/pay/domain/entities/topup_state.dart';
import 'package:tisini/features/pay/presentation/widgets/amount_input.dart';
import 'package:tisini/features/pay/providers/topup_controller_provider.dart';
import 'package:tisini/shared/widgets/cost_line.dart';
import 'package:tisini/shared/widgets/funding_source_card.dart';

class TopupAmountScreen extends ConsumerStatefulWidget {
  const TopupAmountScreen({super.key});

  @override
  ConsumerState<TopupAmountScreen> createState() => _TopupAmountScreenState();
}

class _TopupAmountScreenState extends ConsumerState<TopupAmountScreen> {
  final _amountController = TextEditingController();
  double _amount = 0;

  // TODO(tisini): Dynamic fee from backend
  static const _fee = 500.0;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double get _total => _amount + _fee;
  bool get _canContinue => _amount > 0;

  @override
  Widget build(BuildContext context) {
    final topupState = ref.watch(topupControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Enter Amount'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: topupState.when(
        data: (state) {
          if (state is! TopupStateEnteringAmount) {
            return const Center(child: Text('Invalid state'));
          }

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              children: [
                const Text('From', style: AppTypography.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                FundingSourceCard(source: state.source, isSelected: true),
                const SizedBox(height: AppSpacing.lg),
                const Spacer(),
                AmountInput(
                  controller: _amountController,
                  currency: 'UGX',
                  onChanged: (value) {
                    setState(() {
                      _amount = double.tryParse(value) ?? 0;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                if (_amount > 0)
                  CostLine(
                    amount: _amount,
                    fee: _fee,
                    total: _total,
                    currency: 'UGX',
                  ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _canContinue
                        ? () {
                            ref
                                .read(topupControllerProvider.notifier)
                                .setConfirming(
                                  source: state.source,
                                  amount: _amount,
                                  currency: 'UGX',
                                  fee: _fee,
                                  total: _total,
                                );
                            context.goNamed(RouteNames.topupConfirm);
                          }
                        : null,
                    child: const Text('Continue'),
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
