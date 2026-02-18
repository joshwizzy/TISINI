import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pensions/data/datasources/pension_remote_datasource.dart';
import 'package:tisini/features/pensions/domain/entities/pension_contribution.dart';
import 'package:tisini/features/pensions/domain/entities/pension_reminder.dart';
import 'package:tisini/features/pensions/domain/entities/pension_status.dart';
import 'package:tisini/features/pensions/domain/repositories/pension_repository.dart';

class PensionRepositoryImpl implements PensionRepository {
  PensionRepositoryImpl({required PensionRemoteDatasource datasource})
    : _datasource = datasource;

  final PensionRemoteDatasource _datasource;

  @override
  Future<PensionStatus> getPensionStatus() async {
    final model = await _datasource.getPensionStatus();
    return model.toEntity();
  }

  @override
  Future<PensionContribution> submitContribution({
    required double amount,
    required String currency,
    required String rail,
    required String reference,
  }) async {
    final model = await _datasource.submitContribution(
      amount: amount,
      currency: currency,
      rail: rail,
      reference: reference,
    );
    return model.toEntity();
  }

  @override
  Future<
    ({
      List<PensionContribution> contributions,
      String? nextCursor,
      bool hasMore,
    })
  >
  getContributions({String? cursor, int limit = 20}) async {
    final result = await _datasource.getContributions(
      cursor: cursor,
      limit: limit,
    );
    return (
      contributions: result.contributions.map((m) => m.toEntity()).toList(),
      nextCursor: result.nextCursor,
      hasMore: result.hasMore,
    );
  }

  @override
  Future<PensionLinkStatus> linkNssf({required String nssfNumber}) async {
    return _datasource.linkNssf(nssfNumber: nssfNumber);
  }

  @override
  Future<PensionReminder> setReminder({
    required DateTime reminderDate,
    double? amount,
  }) async {
    final model = await _datasource.setReminder(
      reminderDate: reminderDate,
      amount: amount,
    );
    return model.toEntity();
  }
}
