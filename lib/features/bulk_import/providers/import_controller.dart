import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/core/errors/exceptions.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_mapping.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_state.dart';
import 'package:tisini/features/bulk_import/providers/bulk_import_provider.dart';

class ImportController extends AutoDisposeAsyncNotifier<ImportState> {
  String? _currentJobId;
  Timer? _pollTimer;

  @override
  Future<ImportState> build() async {
    ref.onDispose(() {
      _pollTimer?.cancel();
    });
    return const ImportState.choosingSource();
  }

  Future<void> selectSource(ImportSource source) async {
    state = AsyncData(ImportState.uploading(source: source));

    try {
      final repo = ref.read(bulkImportRepositoryProvider);
      final result = await repo.uploadCsv(source: source);
      _currentJobId = result.job.id;

      state = AsyncData(
        ImportState.mapping(
          columns: result.columns,
          sampleRows: result.sampleRows,
        ),
      );
    } on AppException catch (e) {
      state = AsyncData(ImportState.failed(message: e.message));
    } on Exception {
      state = const AsyncData(
        ImportState.failed(message: 'Failed to upload file'),
      );
    }
  }

  Future<void> submitMapping(ImportMapping mapping) async {
    final jobId = _currentJobId;
    if (jobId == null) return;

    try {
      final repo = ref.read(bulkImportRepositoryProvider);
      final result = await repo.submitMapping(jobId: jobId, mapping: mapping);

      state = AsyncData(
        ImportState.reviewing(
          mapping: mapping,
          totalRows: result.totalRows,
          autoCategorised: result.autoCategorised,
          uncategorised: result.uncategorised,
        ),
      );
    } on AppException catch (e) {
      state = AsyncData(ImportState.failed(message: e.message));
    } on Exception {
      state = const AsyncData(
        ImportState.failed(message: 'Failed to submit mapping'),
      );
    }
  }

  Future<void> startProcessing() async {
    final jobId = _currentJobId;
    if (jobId == null) return;

    state = AsyncData(ImportState.processing(jobId: jobId));
    _pollJobStatus(jobId);
  }

  void _pollJobStatus(String jobId) {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      try {
        final repo = ref.read(bulkImportRepositoryProvider);
        final job = await repo.getJobStatus(jobId);

        if (job.status == ImportJobStatus.completed) {
          _pollTimer?.cancel();
          final result = await repo.getJobResult(jobId);
          state = AsyncData(ImportState.completed(result: result));
        } else if (job.status == ImportJobStatus.failed) {
          _pollTimer?.cancel();
          state = const AsyncData(
            ImportState.failed(message: 'Import job failed'),
          );
        } else {
          state = AsyncData(ImportState.processing(jobId: jobId));
        }
      } on Exception {
        _pollTimer?.cancel();
        state = const AsyncData(
          ImportState.failed(message: 'Failed to check job status'),
        );
      }
    });
  }

  void reset() {
    _pollTimer?.cancel();
    _currentJobId = null;
    state = const AsyncData(ImportState.choosingSource());
  }
}

final importControllerProvider =
    AutoDisposeAsyncNotifierProvider<ImportController, ImportState>(
      ImportController.new,
    );
