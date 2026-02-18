import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/features/pay/data/datasources/mock_pay_remote_datasource.dart';
import 'package:tisini/features/pay/data/repositories/pay_repository_impl.dart';
import 'package:tisini/features/pay/domain/repositories/pay_repository.dart';

final payRepositoryProvider = Provider<PayRepository>((ref) {
  return PayRepositoryImpl(datasource: MockPayRemoteDatasource());
});
