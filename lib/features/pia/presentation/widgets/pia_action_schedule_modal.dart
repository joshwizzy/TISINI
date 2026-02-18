import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';

enum PiaScheduleMode { schedule, confirm }

class PiaActionScheduleModal extends StatefulWidget {
  const PiaActionScheduleModal({
    required this.mode,
    required this.onConfirm,
    super.key,
    this.params = const {},
  });

  final PiaScheduleMode mode;
  final Map<String, dynamic> params;
  final void Function(Map<String, dynamic> result) onConfirm;

  @override
  State<PiaActionScheduleModal> createState() => _PiaActionScheduleModalState();
}

class _PiaActionScheduleModalState extends State<PiaActionScheduleModal> {
  late DateTime _selectedDate;
  final _amountController = TextEditingController();
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().add(const Duration(days: 1));
  }

  @override
  void dispose() {
    _amountController.dispose();
    _textController.dispose();
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

  void _submitSchedule() {
    final amountText = _amountController.text.trim();
    final result = <String, dynamic>{'date': _selectedDate.toIso8601String()};
    if (amountText.isNotEmpty) {
      result['amount'] = double.tryParse(amountText);
    }
    widget.onConfirm(result);
    Navigator.of(context).pop();
  }

  void _submitConfirm(bool confirmed) {
    final result = <String, dynamic>{'confirmed': confirmed};
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      result['note'] = text;
    }
    widget.onConfirm(result);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.screenPadding,
        right: AppSpacing.screenPadding,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: widget.mode == PiaScheduleMode.schedule
          ? _buildScheduleContent()
          : _buildConfirmContent(),
    );
  }

  Widget _buildScheduleContent() {
    final dateFormat = DateFormat('dd MMM yyyy');
    final payeeName = widget.params['payeeName'] as String? ?? 'Payment';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Schedule $payeeName', style: AppTypography.titleLarge),
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
        ElevatedButton(
          onPressed: _submitSchedule,
          child: const Text('Schedule'),
        ),
      ],
    );
  }

  Widget _buildConfirmContent() {
    final question =
        widget.params['question'] as String? ?? 'Please confirm this action';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Confirm', style: AppTypography.titleLarge),
        const SizedBox(height: AppSpacing.lg),
        Text(question, style: AppTypography.bodyLarge),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _textController,
          decoration: const InputDecoration(
            labelText: 'Add a note (optional)',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _submitConfirm(false),
                child: const Text('No'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _submitConfirm(true),
                child: const Text('Yes'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
