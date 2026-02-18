import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/pay/providers/receipt_provider.dart';
import 'package:tisini/features/pensions/domain/entities/pension_contribute_state.dart';
import 'package:tisini/features/pensions/providers/pension_contribute_controller.dart';
import 'package:tisini/shared/widgets/receipt_template.dart';

class PensionReceiptScreen extends ConsumerWidget {
  const PensionReceiptScreen({required this.transactionId, super.key});

  final String transactionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerState = ref.watch(pensionContributeControllerProvider);

    return controllerState.when(
      data: (state) {
        if (state is PensionContributeReceipt) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: ReceiptTemplate(
                receipt: state.receipt,
                onDone: () {
                  ref
                      .read(pensionContributeControllerProvider.notifier)
                      .reset();
                  context.goNamed(RouteNames.pensionHub);
                },
                onShare: () {},
              ),
            ),
          );
        }

        return _DeepLinkReceipt(transactionId: transactionId);
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) =>
          const Scaffold(body: Center(child: Text('Failed to load receipt'))),
    );
  }
}

class _DeepLinkReceipt extends ConsumerWidget {
  const _DeepLinkReceipt({required this.transactionId});

  final String transactionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiptAsync = ref.watch(receiptProvider(transactionId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: receiptAsync.when(
          data: (receipt) => ReceiptTemplate(
            receipt: receipt,
            onDone: () {
              ref.read(pensionContributeControllerProvider.notifier).reset();
              context.goNamed(RouteNames.pensionHub);
            },
            onShare: () {},
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(child: Text('Failed to load receipt')),
        ),
      ),
    );
  }
}
