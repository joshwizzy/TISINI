import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/features/bulk_import/data/datasources/mock_bulk_import_remote_datasource.dart';
import 'package:tisini/features/bulk_import/data/repositories/bulk_import_repository_impl.dart';
import 'package:tisini/features/bulk_import/domain/repositories/bulk_import_repository.dart';

final bulkImportRepositoryProvider = Provider<BulkImportRepository>((ref) {
  return BulkImportRepositoryImpl(datasource: MockBulkImportRemoteDatasource());
});
