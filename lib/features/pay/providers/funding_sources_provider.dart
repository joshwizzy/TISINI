import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/features/pay/domain/entities/funding_source.dart';
import 'package:tisini/features/pay/providers/pay_repository_provider.dart';

final fundingSourcesProvider = FutureProvider.autoDispose<List<FundingSource>>((
  ref,
) async {
  final repository = ref.watch(payRepositoryProvider);
  return repository.getTopupSources();
});
