import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';
import 'package:tisini/features/pay/domain/entities/scan_state.dart';
import 'package:tisini/features/pay/presentation/widgets/amount_input.dart';
import 'package:tisini/features/pay/presentation/widgets/route_selector.dart';
import 'package:tisini/features/pay/providers/scan_controller_provider.dart';
import 'package:tisini/shared/widgets/cost_line.dart';
import 'package:tisini/shared/widgets/payee_card.dart';

class ScanConfirmScreen extends ConsumerStatefulWidget {
  const ScanConfirmScreen({super.key});

  @override
  ConsumerState<ScanConfirmScreen> createState() => _ScanConfirmScreenState();
}

class _ScanConfirmScreenState extends ConsumerState<ScanConfirmScreen> {
  final _amountController = TextEditingController();
  PaymentRoute? _selectedRoute;
  double _amount = 0;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double get _fee => _selectedRoute?.fee ?? 0;
  double get _total => _amount + _fee;
  bool get _canConfirm => _amount > 0 && _selectedRoute != null;

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(scanControllerProvider);

    ref.listen<AsyncValue<ScanState>>(scanControllerProvider, (_, next) {
      final state = next.valueOrNull;
      if (state is ScanStateReceipt) {
        context.goNamed(
          RouteNames.scanReceipt,
          pathParameters: {'txId': state.receipt.transactionId},
        );
      } else if (state is ScanStateFailed) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.message)));
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Confirm Payment'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: scanState.when(
        data: (state) {
          if (state is ScanStateProcessing) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ScanStateConfirming) {
            return _buildConfirmView(context, state);
          }

          if (state is! ScanStateResolved) {
            return const Center(child: Text('Invalid state'));
          }

          // Resolved state — need amount and route selection
          if (state.amount != null) {
            _amount = state.amount!;
            _amountController.text = _amount.toInt().toString();
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
                RouteSelector(
                  selectedRoute: _selectedRoute,
                  onRouteSelected: (route) {
                    setState(() => _selectedRoute = route);
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                if (_amount > 0 && _selectedRoute != null)
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
                    onPressed: _canConfirm
                        ? () {
                            ref
                                .read(scanControllerProvider.notifier)
                                .setAmount(
                                  payee: state.payee,
                                  amount: _amount,
                                  currency: 'UGX',
                                  route: _selectedRoute!,
                                  fee: _fee,
                                  total: _total,
                                  qrData: state.qrData,
                                );
                            ref
                                .read(scanControllerProvider.notifier)
                                .confirmAndPay();
                          }
                        : null,
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

  Widget _buildConfirmView(BuildContext context, ScanStateConfirming state) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Paying', style: AppTypography.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          PayeeCard(payee: state.payee),
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
                ref.read(scanControllerProvider.notifier).confirmAndPay();
              },
              child: const Text('Pay'),
            ),
          ),
        ],
      ),
    );
  }
}
