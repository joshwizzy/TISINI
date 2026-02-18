import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_radii.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/pay/domain/entities/request_state.dart';
import 'package:tisini/features/pay/providers/request_controller_provider.dart';

class RequestStatusScreen extends ConsumerStatefulWidget {
  const RequestStatusScreen({required this.requestId, super.key});

  final String requestId;

  @override
  ConsumerState<RequestStatusScreen> createState() =>
      _RequestStatusScreenState();
}

class _RequestStatusScreenState extends ConsumerState<RequestStatusScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(requestControllerProvider.notifier).viewStatus(widget.requestId);
    });
  }

  String _format(double value) {
    return NumberFormat.currency(symbol: '', decimalDigits: 0).format(value);
  }

  @override
  Widget build(BuildContext context) {
    final requestState = ref.watch(requestControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Request Status'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: requestState.when(
        data: (state) {
          if (state is RequestStateProcessing) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is! RequestStateTracking) {
            return const Center(child: Text('Invalid state'));
          }

          final request = state.request;
          final isPending = request.status == PaymentStatus.pending;
          final statusColor = isPending ? AppColors.warning : AppColors.success;
          final statusText = isPending ? 'Pending' : 'Paid';
          final statusIcon = isPending
              ? PhosphorIconsBold.clockCounterClockwise
              : PhosphorIconsBold.checkCircle;

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              children: [
                const Spacer(),
                Icon(statusIcon, size: 64, color: statusColor),
                const SizedBox(height: AppSpacing.md),
                Text(statusText, style: AppTypography.headlineMedium),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${request.currency} ${_format(request.amount)}',
                  style: AppTypography.amountLarge,
                ),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.cardPadding),
                  decoration: BoxDecoration(
                    color: AppColors.cardWhite,
                    borderRadius: AppRadii.cardBorder,
                    boxShadow: AppShadows.cardShadow,
                  ),
                  child: Column(
                    children: [
                      _DetailRow(label: 'Request ID', value: request.id),
                      _DetailRow(
                        label: 'Created',
                        value: DateFormat(
                          'dd MMM yyyy, HH:mm',
                        ).format(request.createdAt),
                      ),
                      if (request.note != null)
                        _DetailRow(label: 'Note', value: request.note!),
                      if (request.paidAt != null)
                        _DetailRow(
                          label: 'Paid at',
                          value: DateFormat(
                            'dd MMM yyyy, HH:mm',
                          ).format(request.paidAt!),
                        ),
                    ],
                  ),
                ),
                const Spacer(),
                if (isPending)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        ref.read(requestControllerProvider.notifier).reset();
                        context.goNamed(
                          RouteNames.requestShare,
                          pathParameters: {'id': request.id},
                        );
                      },
                      child: const Text('Share again'),
                    ),
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

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall),
          Flexible(
            child: Text(
              value,
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
