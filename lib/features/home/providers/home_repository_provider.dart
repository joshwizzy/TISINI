import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/features/home/data/datasources/mock_home_remote_datasource.dart';
import 'package:tisini/features/home/data/repositories/home_repository_impl.dart';
import 'package:tisini/features/home/domain/repositories/home_repository.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(datasource: MockHomeRemoteDatasource());
});
