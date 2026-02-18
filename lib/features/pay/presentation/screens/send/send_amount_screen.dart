import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';
import 'package:tisini/features/pay/domain/entities/send_state.dart';
import 'package:tisini/features/pay/presentation/widgets/amount_input.dart';
import 'package:tisini/features/pay/presentation/widgets/route_selector.dart';
import 'package:tisini/features/pay/providers/send_controller_provider.dart';
import 'package:tisini/shared/widgets/cost_line.dart';

class SendAmountScreen extends ConsumerStatefulWidget {
  const SendAmountScreen({super.key});

  @override
  ConsumerState<SendAmountScreen> createState() => _SendAmountScreenState();
}

class _SendAmountScreenState extends ConsumerState<SendAmountScreen> {
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
  bool get _canContinue => _amount > 0 && _selectedRoute != null;

  @override
  Widget build(BuildContext context) {
    final sendState = ref.watch(sendControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Amount'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: sendState.when(
        data: (state) {
          if (state is! SendStateEnteringAmount) {
            return const Center(child: Text('Invalid state'));
          }

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              children: [
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
                    onPressed: _canContinue
                        ? () {
                            ref
                                .read(sendControllerProvider.notifier)
                                .setAmount(
                                  payee: state.payee,
                                  reference: state.reference,
                                  category: state.category,
                                  note: state.note,
                                  amount: _amount,
                                  currency: 'UGX',
                                  route: _selectedRoute!,
                                  fee: _fee,
                                  total: _total,
                                );
                            context.goNamed(RouteNames.sendConfirm);
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
