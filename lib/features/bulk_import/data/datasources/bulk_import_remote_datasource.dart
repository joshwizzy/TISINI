import 'package:tisini/core/enums.dart';
import 'package:tisini/features/bulk_import/data/models/import_job_model.dart';
import 'package:tisini/features/bulk_import/data/models/import_mapping_model.dart';
import 'package:tisini/features/bulk_import/data/models/import_result_model.dart';

abstract class BulkImportRemoteDatasource {
  Future<
    ({ImportJobModel job, List<String> columns, List<List<String>> sampleRows})
  >
  uploadCsv({required ImportSource source});

  Future<
    ({String jobId, int totalRows, int autoCategorised, int uncategorised})
  >
  submitMapping({required String jobId, required ImportMappingModel mapping});

  Future<ImportJobModel> getJobStatus(String jobId);

  Future<ImportResultModel> getJobResult(String jobId);
}
