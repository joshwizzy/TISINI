import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pensions/domain/entities/pension_contribution.dart';
import 'package:tisini/features/pensions/domain/entities/pension_reminder.dart';
import 'package:tisini/features/pensions/domain/entities/pension_status.dart';

abstract class PensionRepository {
  Future<PensionStatus> getPensionStatus();

  Future<PensionContribution> submitContribution({
    required double amount,
    required String currency,
    required String rail,
    required String reference,
  });

  Future<
    ({
      List<PensionContribution> contributions,
      String? nextCursor,
      bool hasMore,
    })
  >
  getContributions({String? cursor, int limit = 20});

  Future<PensionLinkStatus> linkNssf({required String nssfNumber});

  Future<PensionReminder> setReminder({
    required DateTime reminderDate,
    double? amount,
  });
}
