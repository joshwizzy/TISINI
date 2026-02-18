import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/features/pensions/data/datasources/mock_pension_remote_datasource.dart';
import 'package:tisini/features/pensions/data/repositories/pension_repository_impl.dart';
import 'package:tisini/features/pensions/domain/entities/pension_contribution.dart';
import 'package:tisini/features/pensions/domain/entities/pension_reminder.dart';
import 'package:tisini/features/pensions/domain/entities/pension_status.dart';
import 'package:tisini/features/pensions/domain/repositories/pension_repository.dart';

final pensionRepositoryProvider = Provider<PensionRepository>((ref) {
  return PensionRepositoryImpl(datasource: MockPensionRemoteDatasource());
});

final pensionStatusProvider = FutureProvider.autoDispose<PensionStatus>((
  ref,
) async {
  final repository = ref.watch(pensionRepositoryProvider);
  return repository.getPensionStatus();
});

final pensionHistoryProvider =
    FutureProvider.autoDispose<List<PensionContribution>>((ref) async {
      final repository = ref.watch(pensionRepositoryProvider);
      final result = await repository.getContributions();
      return result.contributions;
    });

final pensionRemindersProvider =
    FutureProvider.autoDispose<List<PensionReminder>>((ref) async {
      final repository = ref.watch(pensionRepositoryProvider);
      final status = await repository.getPensionStatus();
      return status.activeReminders;
    });
