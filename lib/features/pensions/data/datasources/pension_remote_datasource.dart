import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pensions/data/models/pension_contribution_model.dart';
import 'package:tisini/features/pensions/data/models/pension_status_model.dart';

abstract class PensionRemoteDatasource {
  Future<PensionStatusModel> getPensionStatus();

  Future<PensionContributionModel> submitContribution({
    required double amount,
    required String currency,
    required String rail,
    required String reference,
  });

  Future<
    ({
      List<PensionContributionModel> contributions,
      String? nextCursor,
      bool hasMore,
    })
  >
  getContributions({String? cursor, int limit = 20});

  Future<PensionLinkStatus> linkNssf({required String nssfNumber});

  Future<PensionReminderModel> setReminder({
    required DateTime reminderDate,
    double? amount,
  });
}
