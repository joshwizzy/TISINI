import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/activity/domain/entities/transaction.dart';

class TransactionRow extends StatelessWidget {
  const TransactionRow({required this.transaction, super.key, this.onTap});

  final Transaction transaction;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isInbound = transaction.direction == TransactionDirection.inbound;
    final directionColor = isInbound ? AppColors.success : AppColors.error;
    final directionIcon = isInbound
        ? PhosphorIconsBold.arrowDown
        : PhosphorIconsBold.arrowUp;
    final amountPrefix = isInbound ? '+' : '-';
    final formattedAmount = NumberFormat.currency(
      symbol: '',
      decimalDigits: 0,
    ).format(transaction.amount);

    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: directionColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(directionIcon, color: directionColor, size: 20),
      ),
      title: Text(
        transaction.counterpartyName,
        style: AppTypography.titleMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${_formatTime(transaction.createdAt)}'
        ' · ${transaction.category.name}',
        style: AppTypography.bodySmall,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$amountPrefix$formattedAmount',
            style: AppTypography.titleMedium.copyWith(color: directionColor),
          ),
          Text(transaction.currency, style: AppTypography.labelSmall),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    }
    return DateFormat('dd MMM').format(dateTime);
  }
}
