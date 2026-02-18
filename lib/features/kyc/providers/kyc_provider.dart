import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/features/kyc/data/datasources/mock_kyc_remote_datasource.dart';
import 'package:tisini/features/kyc/data/repositories/kyc_repository_impl.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_submission.dart';
import 'package:tisini/features/kyc/domain/repositories/kyc_repository.dart';

final kycRepositoryProvider = Provider<KycRepository>((ref) {
  return KycRepositoryImpl(datasource: MockKycRemoteDatasource());
});

final kycSubmissionStatusProvider = FutureProvider.autoDispose<KycSubmission?>((
  ref,
) async {
  final repository = ref.watch(kycRepositoryProvider);
  return repository.getStatus();
});
