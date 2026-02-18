import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_mapping.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_state.dart';
import 'package:tisini/features/bulk_import/presentation/widgets/column_mapping_row.dart';
import 'package:tisini/features/bulk_import/providers/import_controller.dart';

class ImportUploadScreen extends ConsumerStatefulWidget {
  const ImportUploadScreen({super.key});

  @override
  ConsumerState<ImportUploadScreen> createState() => _ImportUploadScreenState();
}

class _ImportUploadScreenState extends ConsumerState<ImportUploadScreen> {
  String? _dateColumn;
  String? _amountColumn;
  String? _merchantColumn;
  String? _referenceColumn;

  bool get _isValid =>
      _dateColumn != null &&
      _amountColumn != null &&
      _merchantColumn != null &&
      _referenceColumn != null;

  @override
  Widget build(BuildContext context) {
    ref.listen(importControllerProvider, (prev, next) {
      final val = next.valueOrNull;
      if (val is ImportReviewing) {
        context.goNamed(RouteNames.importReview);
      } else if (val is ImportFailed) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(val.message)));
      }
    });

    final stateAsync = ref.watch(importControllerProvider);
    final mapping = stateAsync.valueOrNull;

    if (mapping is! ImportMapping_) {
      return Scaffold(
        appBar: AppBar(title: const Text('Map Columns')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final columns = mapping.columns;
    final samples = mapping.sampleRows;
    final firstSample = samples.isNotEmpty ? samples.first : <String>[];

    String? sampleFor(String? column) {
      if (column == null) return null;
      final idx = columns.indexOf(column);
      if (idx < 0 || idx >= firstSample.length) return null;
      return firstSample[idx];
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Map Columns'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          const Text('Map your columns', style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Match each field to a column '
            'in your statement.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: AppSpacing.md),
          ColumnMappingRow(
            label: 'Date',
            columns: columns,
            selectedColumn: _dateColumn,
            sampleValue: sampleFor(_dateColumn),
            onChanged: (v) => setState(() => _dateColumn = v),
          ),
          ColumnMappingRow(
            label: 'Amount',
            columns: columns,
            selectedColumn: _amountColumn,
            sampleValue: sampleFor(_amountColumn),
            onChanged: (v) => setState(() => _amountColumn = v),
          ),
          ColumnMappingRow(
            label: 'Merchant / Description',
            columns: columns,
            selectedColumn: _merchantColumn,
            sampleValue: sampleFor(_merchantColumn),
            onChanged: (v) => setState(() => _merchantColumn = v),
          ),
          ColumnMappingRow(
            label: 'Reference',
            columns: columns,
            selectedColumn: _referenceColumn,
            sampleValue: sampleFor(_referenceColumn),
            onChanged: (v) => setState(() => _referenceColumn = v),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Sample data preview
          if (samples.isNotEmpty) ...[
            const Text('Sample data', style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: columns
                    .map(
                      (c) => DataColumn(
                        label: Text(c, style: AppTypography.labelSmall),
                      ),
                    )
                    .toList(),
                rows: samples
                    .take(3)
                    .map(
                      (row) => DataRow(
                        cells: row
                            .map(
                              (cell) => DataCell(
                                Text(cell, style: AppTypography.bodySmall),
                              ),
                            )
                            .toList(),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: FilledButton(
            onPressed: _isValid
                ? () {
                    ref
                        .read(importControllerProvider.notifier)
                        .submitMapping(
                          ImportMapping(
                            dateColumn: _dateColumn!,
                            amountColumn: _amountColumn!,
                            merchantColumn: _merchantColumn!,
                            referenceColumn: _referenceColumn!,
                          ),
                        );
                  }
                : null,
            child: const Text('Continue'),
          ),
        ),
      ),
    );
  }
}
