import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/pay/domain/entities/request_state.dart';
import 'package:tisini/features/pay/presentation/widgets/amount_input.dart';
import 'package:tisini/features/pay/providers/request_controller_provider.dart';

class RequestCreateScreen extends ConsumerStatefulWidget {
  const RequestCreateScreen({super.key});

  @override
  ConsumerState<RequestCreateScreen> createState() =>
      _RequestCreateScreenState();
}

class _RequestCreateScreenState extends ConsumerState<RequestCreateScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  double _amount = 0;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final requestState = ref.watch(requestControllerProvider);

    ref.listen<AsyncValue<RequestState>>(requestControllerProvider, (_, next) {
      final state = next.valueOrNull;
      if (state is RequestStateSharing) {
        context.goNamed(
          RouteNames.requestShare,
          pathParameters: {'id': state.request.id},
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Request Payment'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: requestState.when(
        data: (state) {
          if (state is RequestStateProcessing) {
            return const Center(child: CircularProgressIndicator());
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
                TextField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    hintText: 'Add a note (optional)',
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      color: AppColors.grey,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _amount > 0
                        ? () {
                            final note = _noteController.text.trim();
                            ref
                                .read(requestControllerProvider.notifier)
                                .createRequest(
                                  amount: _amount,
                                  currency: 'UGX',
                                  note: note.isNotEmpty ? note : null,
                                );
                          }
                        : null,
                    child: const Text('Create request'),
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
