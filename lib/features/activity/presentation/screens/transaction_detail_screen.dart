import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_radii.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/activity/domain/entities/transaction.dart';
import 'package:tisini/features/activity/presentation/widgets/category_selector_sheet.dart';
import 'package:tisini/features/activity/presentation/widgets/merchant_role_sheet.dart';
import 'package:tisini/features/activity/presentation/widgets/status_badge.dart';
import 'package:tisini/features/activity/providers/activity_provider.dart';

class TransactionDetailScreen extends ConsumerStatefulWidget {
  const TransactionDetailScreen({required this.id, super.key});

  final String id;

  @override
  ConsumerState<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState
    extends ConsumerState<TransactionDetailScreen> {
  final _noteController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _noteController.dispose();
    super.dispose();
  }

  void _onNoteChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref
          .read(activityRepositoryProvider)
          .updateNote(transactionId: widget.id, note: value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final txnAsync = ref.watch(transactionDetailProvider(widget.id));

    return Scaffold(
      appBar: AppBar(title: const Text('Transaction')),
      body: txnAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (txn) {
          if (_noteController.text.isEmpty && txn.note != null) {
            _noteController.text = txn.note!;
          }
          return _buildContent(txn);
        },
      ),
    );
  }

  Widget _buildContent(Transaction txn) {
    final isInbound = txn.direction == TransactionDirection.inbound;
    final directionColor = isInbound ? AppColors.success : AppColors.error;
    final prefix = isInbound ? '+' : '-';
    final formattedAmount = NumberFormat.currency(
      symbol: '',
      decimalDigits: 0,
    ).format(txn.amount);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: [
        Center(
          child: Text(
            '$prefix$formattedAmount ${txn.currency}',
            style: AppTypography.headlineLarge.copyWith(color: directionColor),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Center(child: StatusBadge(status: txn.status)),
        const SizedBox(height: AppSpacing.lg),
        _buildDetailsCard(txn),
        const SizedBox(height: AppSpacing.md),
        _buildCategoryRow(txn),
        const SizedBox(height: AppSpacing.md),
        _buildMerchantRow(txn),
        const SizedBox(height: AppSpacing.md),
        _buildNoteField(),
      ],
    );
  }

  Widget _buildDetailsCard(Transaction txn) {
    final timestamp = DateFormat('dd MMM yyyy, HH:mm').format(txn.createdAt);
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 0);
    final total = txn.fee != null ? txn.amount + txn.fee! : txn.amount;
    final formattedTotal = fmt.format(total);
    final formattedFee = txn.fee != null ? fmt.format(txn.fee) : null;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: AppRadii.cardBorder,
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        children: [
          _detailRow('To/From', txn.counterpartyName),
          _detailRow('Route', _railLabel(txn.rail)),
          if (formattedFee != null)
            _detailRow('Fee', '${txn.currency} $formattedFee'),
          _detailRow('Total', '${txn.currency} $formattedTotal'),
          _detailRow('Reference', txn.id),
          _detailRow('Time', timestamp),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMedium),
          Flexible(
            child: Text(
              value,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(Transaction txn) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(PhosphorIconsBold.tag, color: AppColors.darkBlue),
      title: Text(
        'Category: ${_categoryLabel(txn.category)}',
        style: AppTypography.bodyMedium,
      ),
      trailing: TextButton(
        onPressed: () => _showCategorySheet(txn),
        child: const Text('Edit'),
      ),
    );
  }

  Widget _buildMerchantRow(Transaction txn) {
    final roleLabel = txn.merchantRole != null
        ? _merchantRoleLabel(txn.merchantRole!)
        : 'Not set';
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(PhosphorIconsBold.pushPin, color: AppColors.darkBlue),
      title: Text('Merchant: $roleLabel', style: AppTypography.bodyMedium),
      trailing: TextButton(
        onPressed: () => _showMerchantSheet(txn),
        child: const Text('Pin'),
      ),
    );
  }

  Widget _buildNoteField() {
    return TextField(
      controller: _noteController,
      onChanged: _onNoteChanged,
      decoration: const InputDecoration(
        labelText: 'Note',
        hintText: 'Add a note...',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
    );
  }

  void _showCategorySheet(Transaction txn) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => CategorySelectorSheet(
        selected: txn.category,
        onSelected: (category) {
          ref
            ..read(updateCategoryProvider((id: txn.id, category: category)))
            ..invalidate(transactionDetailProvider(widget.id))
            ..invalidate(transactionListProvider);
        },
      ),
    );
  }

  void _showMerchantSheet(Transaction txn) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => MerchantRoleSheet(
        selected: txn.merchantRole,
        onSelected: (role) {
          ref
            ..read(pinMerchantProvider((id: txn.id, role: role)))
            ..invalidate(transactionDetailProvider(widget.id))
            ..invalidate(transactionListProvider);
        },
      ),
    );
  }

  String _railLabel(PaymentRail rail) {
    return switch (rail) {
      PaymentRail.bank => 'Bank',
      PaymentRail.mobileMoney => 'Mobile Money',
      PaymentRail.card => 'Card',
      PaymentRail.wallet => 'Wallet',
    };
  }

  String _categoryLabel(TransactionCategory category) {
    return switch (category) {
      TransactionCategory.sales => 'Sales',
      TransactionCategory.inventory => 'Inventory',
      TransactionCategory.bills => 'Bills',
      TransactionCategory.people => 'People',
      TransactionCategory.compliance => 'Compliance',
      TransactionCategory.agency => 'Agency',
      TransactionCategory.uncategorised => 'Uncategorised',
    };
  }

  String _merchantRoleLabel(MerchantRole role) {
    return switch (role) {
      MerchantRole.supplier => 'Supplier',
      MerchantRole.rent => 'Rent',
      MerchantRole.wages => 'Wages',
      MerchantRole.tax => 'Tax',
      MerchantRole.pension => 'Pension',
      MerchantRole.utilities => 'Utilities',
    };
  }
}
