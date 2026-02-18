import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/features/auth/data/datasources/mock_auth_remote_datasource.dart';
import 'package:tisini/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:tisini/features/auth/domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(datasource: MockAuthRemoteDatasource());
});
