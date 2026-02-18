import 'package:tisini/core/enums.dart';
import 'package:tisini/features/bulk_import/data/datasources/bulk_import_remote_datasource.dart';
import 'package:tisini/features/bulk_import/data/models/import_mapping_model.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_job.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_mapping.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_result.dart';
import 'package:tisini/features/bulk_import/domain/repositories/bulk_import_repository.dart';

class BulkImportRepositoryImpl implements BulkImportRepository {
  BulkImportRepositoryImpl({required BulkImportRemoteDatasource datasource})
    : _datasource = datasource;

  final BulkImportRemoteDatasource _datasource;

  @override
  Future<({ImportJob job, List<String> columns, List<List<String>> sampleRows})>
  uploadCsv({required ImportSource source}) async {
    final result = await _datasource.uploadCsv(source: source);
    return (
      job: result.job.toEntity(),
      columns: result.columns,
      sampleRows: result.sampleRows,
    );
  }

  @override
  Future<
    ({String jobId, int totalRows, int autoCategorised, int uncategorised})
  >
  submitMapping({required String jobId, required ImportMapping mapping}) async {
    return _datasource.submitMapping(
      jobId: jobId,
      mapping: ImportMappingModel.fromEntity(mapping),
    );
  }

  @override
  Future<ImportJob> getJobStatus(String jobId) async {
    final model = await _datasource.getJobStatus(jobId);
    return model.toEntity();
  }

  @override
  Future<ImportResult> getJobResult(String jobId) async {
    final model = await _datasource.getJobResult(jobId);
    return model.toEntity();
  }
}
