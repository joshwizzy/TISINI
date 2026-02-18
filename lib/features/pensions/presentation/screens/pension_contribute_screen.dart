import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';
import 'package:tisini/features/pay/presentation/widgets/amount_input.dart';
import 'package:tisini/features/pay/presentation/widgets/route_selector.dart';
import 'package:tisini/features/pensions/domain/entities/pension_contribute_state.dart';
import 'package:tisini/features/pensions/providers/pension_contribute_controller.dart';

class PensionContributeScreen extends ConsumerStatefulWidget {
  const PensionContributeScreen({super.key});

  @override
  ConsumerState<PensionContributeScreen> createState() =>
      _PensionContributeScreenState();
}

class _PensionContributeScreenState
    extends ConsumerState<PensionContributeScreen> {
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  PaymentRoute? _selectedRoute;

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  void _prefill(PensionContributeEnteringAmount state) {
    if (_amountController.text.isEmpty && state.nextDueAmount != null) {
      _amountController.text = state.nextDueAmount!.toInt().toString();
    }
    if (_referenceController.text.isEmpty) {
      final now = DateTime.now();
      _referenceController.text = 'NSSF ${DateFormat('MMM yyyy').format(now)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controllerState = ref.watch(pensionContributeControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Contribute'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: controllerState.when(
        data: (state) {
          if (state is! PensionContributeEnteringAmount) {
            return const Center(child: Text('Invalid state'));
          }

          _prefill(state);

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('NSSF Pension', style: AppTypography.titleMedium),
                Text(
                  'National Social Security Fund',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Center(
                  child: AmountInput(
                    controller: _amountController,
                    currency: state.currency,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                TextField(
                  controller: _referenceController,
                  decoration: const InputDecoration(
                    labelText: 'Reference',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                const Text('Pay via', style: AppTypography.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                RouteSelector(
                  selectedRoute: _selectedRoute,
                  onRouteSelected: (route) {
                    setState(() => _selectedRoute = route);
                  },
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed:
                        _selectedRoute != null &&
                            _amountController.text.isNotEmpty
                        ? () {
                            final amount =
                                double.tryParse(_amountController.text) ?? 0;
                            final fee = _selectedRoute!.fee ?? 0;
                            ref
                                .read(
                                  pensionContributeControllerProvider.notifier,
                                )
                                .setConfirming(
                                  amount: amount,
                                  currency: state.currency,
                                  route: _selectedRoute!,
                                  fee: fee,
                                  total: amount + fee,
                                  reference: _referenceController.text,
                                );
                            context.goNamed(RouteNames.pensionConfirm);
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
        error: (_, __) => const Center(child: Text('Failed to load')),
      ),
    );
  }
}
