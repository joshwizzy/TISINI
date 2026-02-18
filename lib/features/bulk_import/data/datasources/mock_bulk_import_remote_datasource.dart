import 'package:tisini/core/enums.dart';
import 'package:tisini/features/bulk_import/data/datasources/bulk_import_remote_datasource.dart';
import 'package:tisini/features/bulk_import/data/models/import_job_model.dart';
import 'package:tisini/features/bulk_import/data/models/import_mapping_model.dart';
import 'package:tisini/features/bulk_import/data/models/import_result_model.dart';

class MockBulkImportRemoteDatasource implements BulkImportRemoteDatasource {
  static const _readDelay = Duration(milliseconds: 300);
  static const _writeDelay = Duration(milliseconds: 800);

  int _statusCallCount = 0;

  static const _bankColumns = [
    'Date',
    'Description',
    'Amount (UGX)',
    'Reference',
    'Balance',
  ];

  static const _bankSampleRows = [
    [
      '2026-01-15',
      'Stanbic ATM Withdrawal',
      '-500000',
      'STB-001234',
      '2500000',
    ],
    ['2026-01-14', 'DFCU Transfer In', '1200000', 'DFCU-987654', '3000000'],
    ['2026-01-13', 'MTN MoMo Top Up', '-100000', 'MTN-112233', '1800000'],
  ];

  static const _momoColumns = [
    'Date',
    'Transaction',
    'Amount',
    'Phone Number',
    'Ref ID',
  ];

  static const _momoSampleRows = [
    ['2026-01-15', 'Send Money', '-50000', '0771234567', 'MTN-AA1122'],
    ['2026-01-14', 'Receive Money', '200000', '0701987654', 'MTN-BB3344'],
    ['2026-01-13', 'Airtel Money In', '150000', '0751112233', 'ATL-CC5566'],
  ];

  @override
  Future<
    ({ImportJobModel job, List<String> columns, List<List<String>> sampleRows})
  >
  uploadCsv({required ImportSource source}) async {
    await Future<void>.delayed(_writeDelay);
    final now = DateTime.now().millisecondsSinceEpoch;
    final isBank = source == ImportSource.bank;

    return (
      job: ImportJobModel(
        id: 'imp-${now.hashCode.abs()}',
        source: isBank ? 'bank' : 'mobile_money',
        status: 'mapping',
        totalRows: 142,
        processedRows: 0,
        successRows: 0,
        errorRows: 0,
        createdAt: now,
      ),
      columns: isBank ? _bankColumns : _momoColumns,
      sampleRows: isBank ? _bankSampleRows : _momoSampleRows,
    );
  }

  @override
  Future<
    ({String jobId, int totalRows, int autoCategorised, int uncategorised})
  >
  submitMapping({
    required String jobId,
    required ImportMappingModel mapping,
  }) async {
    await Future<void>.delayed(_writeDelay);

    return (
      jobId: jobId,
      totalRows: 142,
      autoCategorised: 89,
      uncategorised: 53,
    );
  }

  @override
  Future<ImportJobModel> getJobStatus(String jobId) async {
    await Future<void>.delayed(_readDelay);
    _statusCallCount++;
    final now = DateTime.now().millisecondsSinceEpoch;

    if (_statusCallCount <= 1) {
      return ImportJobModel(
        id: jobId,
        source: 'bank',
        status: 'processing',
        totalRows: 142,
        processedRows: 72,
        successRows: 70,
        errorRows: 2,
        createdAt: now,
      );
    }

    return ImportJobModel(
      id: jobId,
      source: 'bank',
      status: 'completed',
      totalRows: 142,
      processedRows: 142,
      successRows: 138,
      errorRows: 4,
      createdAt: now,
      completedAt: now,
    );
  }

  @override
  Future<ImportResultModel> getJobResult(String jobId) async {
    await Future<void>.delayed(_readDelay);

    return ImportResultModel(
      jobId: jobId,
      totalImported: 138,
      categorised: 89,
      uncategorised: 49,
      errors: [
        'Row 23: invalid date format',
        'Row 57: missing amount',
        'Row 98: duplicate reference',
        'Row 131: unrecognised currency',
      ],
    );
  }
}
