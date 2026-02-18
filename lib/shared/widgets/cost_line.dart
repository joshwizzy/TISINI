import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';

class CostLine extends StatelessWidget {
  const CostLine({
    required this.amount,
    required this.fee,
    required this.total,
    required this.currency,
    super.key,
  });

  final double amount;
  final double fee;
  final double total;
  final String currency;

  String _format(double value) {
    return NumberFormat.currency(symbol: '', decimalDigits: 0).format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Row(label: 'Amount', value: '$currency ${_format(amount)}'),
        const SizedBox(height: AppSpacing.xs),
        _Row(
          label: 'Fee',
          value: fee == 0 ? 'Free' : '$currency ${_format(fee)}',
          valueColor: fee == 0 ? AppColors.success : null,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Divider(height: 1),
        ),
        _Row(
          label: 'Total',
          value: '$currency ${_format(total)}',
          isBold: true,
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final style = isBold ? AppTypography.titleMedium : AppTypography.bodyMedium;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style.copyWith(color: valueColor)),
      ],
    );
  }
}
