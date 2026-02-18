import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/features/activity/domain/entities/export_state.dart';
import 'package:tisini/features/activity/providers/activity_provider.dart';

class ExportController extends AutoDisposeAsyncNotifier<ExportState> {
  @override
  Future<ExportState> build() async {
    return const ExportState.choosingPeriod();
  }

  Future<void> setPeriod({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    state = const AsyncData(ExportState.exporting());

    try {
      final repo = ref.read(activityRepositoryProvider);
      final rows = await repo.getEstimatedExportRows(
        startDate: startDate,
        endDate: endDate,
      );

      state = AsyncData(
        ExportState.confirming(
          startDate: startDate,
          endDate: endDate,
          estimatedRows: rows,
        ),
      );
    } on Exception catch (e) {
      state = AsyncData(ExportState.failed(message: e.toString()));
    }
  }

  Future<void> confirmExport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    state = const AsyncData(ExportState.exporting());

    try {
      final repo = ref.read(activityRepositoryProvider);
      final job = await repo.createExport(
        startDate: startDate,
        endDate: endDate,
      );

      state = AsyncData(ExportState.success(job: job));
    } on Exception catch (e) {
      state = AsyncData(ExportState.failed(message: e.toString()));
    }
  }

  void reset() {
    state = const AsyncData(ExportState.choosingPeriod());
  }
}

final exportControllerProvider =
    AutoDisposeAsyncNotifierProvider<ExportController, ExportState>(
      ExportController.new,
    );
