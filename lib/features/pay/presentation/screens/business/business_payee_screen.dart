import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_radii.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/pay/domain/entities/business_pay_state.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';
import 'package:tisini/features/pay/presentation/widgets/amount_input.dart';
import 'package:tisini/features/pay/presentation/widgets/route_selector.dart';
import 'package:tisini/features/pay/providers/business_pay_controller_provider.dart';
import 'package:tisini/features/pay/providers/business_payees_provider.dart';
import 'package:tisini/shared/widgets/cost_line.dart';
import 'package:tisini/shared/widgets/payee_card.dart';

class BusinessPayeeScreen extends ConsumerStatefulWidget {
  const BusinessPayeeScreen({super.key});

  @override
  ConsumerState<BusinessPayeeScreen> createState() =>
      _BusinessPayeeScreenState();
}

class _BusinessPayeeScreenState extends ConsumerState<BusinessPayeeScreen> {
  Payee? _selectedPayee;
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  PaymentRoute? _selectedRoute;
  double _amount = 0;

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  double get _fee => _selectedRoute?.fee ?? 0;
  double get _total => _amount + _fee;
  bool get _canContinue =>
      _selectedPayee != null && _amount > 0 && _selectedRoute != null;

  @override
  Widget build(BuildContext context) {
    final bizState = ref.watch(businessPayControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: bizState.when(
          data: (state) {
            if (state is BusinessPayStateSelectingPayee) {
              return Text(state.category);
            }
            return const Text('Business Pay');
          },
          loading: () => const Text('Business Pay'),
          error: (_, __) => const Text('Business Pay'),
        ),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: bizState.when(
        data: (state) {
          if (state is! BusinessPayStateSelectingPayee) {
            return const Center(child: Text('Invalid state'));
          }

          final payeesAsync = ref.watch(businessPayeesProvider(state.category));

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search payees...',
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      color: AppColors.grey,
                    ),
                    prefixIcon: const Icon(
                      PhosphorIconsBold.magnifyingGlass,
                      color: AppColors.grey,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: AppColors.cardWhite,
                    border: OutlineInputBorder(
                      borderRadius: AppRadii.inputBorder,
                      borderSide: const BorderSide(color: AppColors.cardBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppRadii.inputBorder,
                      borderSide: const BorderSide(color: AppColors.cardBorder),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                // Payees list
                Expanded(
                  child: payeesAsync.when(
                    data: (payees) {
                      if (payees.isEmpty) {
                        return Center(
                          child: Text(
                            'No payees found',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                        );
                      }
                      return ListView(
                        children: [
                          ...payees.map(
                            (payee) => PayeeCard(
                              payee: payee,
                              onTap: () {
                                setState(() => _selectedPayee = payee);
                                _showAmountSheet(context, state.category);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (_, __) =>
                        const Center(child: Text('Failed to load payees')),
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

  void _showAmountSheet(BuildContext context, String category) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: AppSpacing.screenPadding,
          right: AppSpacing.screenPadding,
          top: AppSpacing.screenPadding,
        ),
        child: StatefulBuilder(
          builder: (ctx, setSheetState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AmountInput(
                controller: _amountController,
                currency: 'UGX',
                onChanged: (value) {
                  setSheetState(() {
                    _amount = double.tryParse(value) ?? 0;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _referenceController,
                decoration: InputDecoration(
                  hintText: 'Reference (optional)',
                  hintStyle: AppTypography.bodyMedium.copyWith(
                    color: AppColors.grey,
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              RouteSelector(
                selectedRoute: _selectedRoute,
                onRouteSelected: (route) {
                  setSheetState(() => _selectedRoute = route);
                },
              ),
              const SizedBox(height: AppSpacing.md),
              if (_amount > 0 && _selectedRoute != null)
                CostLine(
                  amount: _amount,
                  fee: _fee,
                  total: _total,
                  currency: 'UGX',
                ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _canContinue
                      ? () {
                          Navigator.of(ctx).pop();
                          ref
                              .read(businessPayControllerProvider.notifier)
                              .setConfirming(
                                payee: _selectedPayee!,
                                category: category,
                                amount: _amount,
                                currency: 'UGX',
                                route: _selectedRoute!,
                                fee: _fee,
                                total: _total,
                                reference:
                                    _referenceController.text.trim().isNotEmpty
                                    ? _referenceController.text.trim()
                                    : null,
                              );
                          context.goNamed(RouteNames.businessConfirm);
                        }
                      : null,
                  child: const Text('Continue'),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
