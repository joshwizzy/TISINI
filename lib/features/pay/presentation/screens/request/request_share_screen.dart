import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/pay/domain/entities/request_state.dart';
import 'package:tisini/features/pay/providers/request_controller_provider.dart';
import 'package:tisini/shared/widgets/qr_display.dart';

class RequestShareScreen extends ConsumerWidget {
  const RequestShareScreen({required this.requestId, super.key});

  final String requestId;

  String _format(double value) {
    return NumberFormat.currency(symbol: '', decimalDigits: 0).format(value);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestState = ref.watch(requestControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Share Request'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: requestState.when(
        data: (state) {
          if (state is! RequestStateSharing) {
            return const Center(child: Text('Invalid state'));
          }

          final request = state.request;

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              children: [
                const Spacer(),
                Text(
                  '${request.currency} ${_format(request.amount)}',
                  style: AppTypography.amountLarge,
                ),
                if (request.note != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    request.note!,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                QrDisplay(data: request.shareLink),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: request.shareLink),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Link copied')),
                          );
                        },
                        icon: const Icon(Icons.copy),
                        label: const Text('Copy link'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      // TODO(tisini): Implement share via share_plus
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.share),
                        label: const Text('Share'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      ref.read(requestControllerProvider.notifier).reset();
                      context.goNamed(RouteNames.payHub);
                    },
                    child: const Text('Done'),
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
