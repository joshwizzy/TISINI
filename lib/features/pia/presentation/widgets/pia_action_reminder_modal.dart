import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';

class PiaActionReminderModal extends StatefulWidget {
  const PiaActionReminderModal({required this.onConfirm, super.key});

  final void Function({required DateTime date, double? amount}) onConfirm;

  @override
  State<PiaActionReminderModal> createState() => _PiaActionReminderModalState();
}

class _PiaActionReminderModalState extends State<PiaActionReminderModal> {
  late DateTime _selectedDate;
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().add(const Duration(days: 1));
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submit() {
    final amountText = _amountController.text.trim();
    final amount = amountText.isEmpty ? null : double.tryParse(amountText);

    widget.onConfirm(date: _selectedDate, amount: amount);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.screenPadding,
        right: AppSpacing.screenPadding,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Set Reminder', style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Text(
                dateFormat.format(_selectedDate),
                style: AppTypography.bodyLarge,
              ),
              const Spacer(),
              TextButton(
                onPressed: _pickDate,
                child: Text(
                  'Change',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.cyan,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Amount (optional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton(onPressed: _submit, child: const Text('Set reminder')),
        ],
      ),
    );
  }
}
