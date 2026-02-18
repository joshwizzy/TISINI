import 'package:tisini/core/enums.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_job.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_mapping.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_result.dart';

abstract class BulkImportRepository {
  Future<({ImportJob job, List<String> columns, List<List<String>> sampleRows})>
  uploadCsv({required ImportSource source});

  Future<
    ({String jobId, int totalRows, int autoCategorised, int uncategorised})
  >
  submitMapping({required String jobId, required ImportMapping mapping});

  Future<ImportJob> getJobStatus(String jobId);

  Future<ImportResult> getJobResult(String jobId);
}
