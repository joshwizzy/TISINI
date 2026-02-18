import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_radii.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payment_receipt.dart';

class ReceiptTemplate extends StatelessWidget {
  const ReceiptTemplate({
    required this.receipt,
    super.key,
    this.onDone,
    this.onShare,
  });

  final PaymentReceipt receipt;
  final VoidCallback? onDone;
  final VoidCallback? onShare;

  String _format(double value) {
    return NumberFormat.currency(symbol: '', decimalDigits: 0).format(value);
  }

  @override
  Widget build(BuildContext context) {
    final isSuccess = receipt.status == PaymentStatus.completed;
    final statusColor = isSuccess ? AppColors.success : AppColors.error;
    final statusIcon = isSuccess
        ? PhosphorIconsBold.checkCircle
        : PhosphorIconsBold.xCircle;
    final statusText = isSuccess ? 'Payment Successful' : 'Payment Failed';

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
            '${receipt.currency} ${_format(receipt.total)}',
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
                _DetailRow(label: 'To', value: receipt.payeeName),
                _DetailRow(label: 'Identifier', value: receipt.payeeIdentifier),
                _DetailRow(
                  label: 'Amount',
                  value: '${receipt.currency} ${_format(receipt.amount)}',
                ),
                _DetailRow(
                  label: 'Fee',
                  value: receipt.fee == 0
                      ? 'Free'
                      : '${receipt.currency} ${_format(receipt.fee)}',
                ),
                _DetailRow(
                  label: 'Total',
                  value: '${receipt.currency} ${_format(receipt.total)}',
                ),
                if (receipt.reference != null)
                  _DetailRow(label: 'Reference', value: receipt.reference!),
                _DetailRow(label: 'Receipt #', value: receipt.receiptNumber),
                _DetailRow(
                  label: 'Date',
                  value: DateFormat(
                    'dd MMM yyyy, HH:mm',
                  ).format(receipt.timestamp),
                ),
              ],
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onShare,
                  icon: const Icon(PhosphorIconsBold.shareFat),
                  label: const Text('Share'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: FilledButton(
                  onPressed: onDone,
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ],
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
