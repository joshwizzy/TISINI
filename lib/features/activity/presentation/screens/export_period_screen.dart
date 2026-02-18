import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/activity/domain/entities/export_state.dart';
import 'package:tisini/features/activity/providers/export_controller.dart';

enum _PeriodOption { thisMonth, lastMonth, custom }

class ExportPeriodScreen extends ConsumerStatefulWidget {
  const ExportPeriodScreen({super.key});

  @override
  ConsumerState<ExportPeriodScreen> createState() => _ExportPeriodScreenState();
}

class _ExportPeriodScreenState extends ConsumerState<ExportPeriodScreen> {
  _PeriodOption _selected = _PeriodOption.thisMonth;
  DateTimeRange? _customRange;

  @override
  void initState() {
    super.initState();
    ref.listenManual(exportControllerProvider, (_, next) {
      final state = next.valueOrNull;
      if (state is ExportConfirming && mounted) {
        context.pushNamed(RouteNames.exportConfirm);
      }
    });
  }

  DateTime _startDate() {
    final now = DateTime.now();
    return switch (_selected) {
      _PeriodOption.thisMonth => DateTime(now.year, now.month),
      _PeriodOption.lastMonth => DateTime(now.year, now.month - 1),
      _PeriodOption.custom => _customRange?.start ?? now,
    };
  }

  DateTime _endDate() {
    final now = DateTime.now();
    return switch (_selected) {
      _PeriodOption.thisMonth => now,
      _PeriodOption.lastMonth => DateTime(
        now.year,
        now.month,
      ).subtract(const Duration(seconds: 1)),
      _PeriodOption.custom => _customRange?.end ?? now,
    };
  }

  Future<void> _continue() async {
    await ref
        .read(exportControllerProvider.notifier)
        .setPeriod(startDate: _startDate(), endDate: _endDate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Export Period')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select the period to export',
              style: AppTypography.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            RadioGroup<_PeriodOption>(
              groupValue: _selected,
              onChanged: (v) {
                if (v != null) setState(() => _selected = v);
              },
              child: const Column(
                children: [
                  RadioListTile<_PeriodOption>(
                    title: Text('This month'),
                    value: _PeriodOption.thisMonth,
                  ),
                  RadioListTile<_PeriodOption>(
                    title: Text('Last month'),
                    value: _PeriodOption.lastMonth,
                  ),
                  RadioListTile<_PeriodOption>(
                    title: Text('Custom range'),
                    value: _PeriodOption.custom,
                  ),
                ],
              ),
            ),
            if (_selected == _PeriodOption.custom) ...[
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2024),
                    lastDate: DateTime.now(),
                    initialDateRange: _customRange,
                  );
                  if (picked != null) {
                    setState(() => _customRange = picked);
                  }
                },
                icon: const Icon(Icons.calendar_today, size: 18),
                label: Text(
                  _customRange != null
                      ? '${_formatDate(_customRange!.start)}'
                            ' - '
                            '${_formatDate(_customRange!.end)}'
                      : 'Select dates',
                ),
              ),
            ],
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _canContinue ? _continue : null,
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get _canContinue =>
      _selected != _PeriodOption.custom || _customRange != null;

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
