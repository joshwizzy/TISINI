import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/pay/domain/entities/topup_state.dart';
import 'package:tisini/features/pay/providers/receipt_provider.dart';
import 'package:tisini/features/pay/providers/topup_controller_provider.dart';
import 'package:tisini/shared/widgets/receipt_template.dart';

class TopupReceiptScreen extends ConsumerWidget {
  const TopupReceiptScreen({required this.transactionId, super.key});

  final String transactionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topupState = ref.watch(topupControllerProvider);

    return topupState.when(
      data: (state) {
        if (state is TopupStateReceipt) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: ReceiptTemplate(
                receipt: state.receipt,
                onDone: () {
                  ref.read(topupControllerProvider.notifier).reset();
                  context.goNamed(RouteNames.payHub);
                },
                // TODO(tisini): Implement share receipt
                onShare: () {},
              ),
            ),
          );
        }

        // Deep link fallback
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
              ref.read(topupControllerProvider.notifier).reset();
              context.goNamed(RouteNames.payHub);
            },
            // TODO(tisini): Implement share receipt
            onShare: () {},
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(child: Text('Failed to load receipt')),
        ),
      ),
    );
  }
}
