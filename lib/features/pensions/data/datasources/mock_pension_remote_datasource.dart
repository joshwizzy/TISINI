import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pensions/data/datasources/pension_remote_datasource.dart';
import 'package:tisini/features/pensions/data/models/pension_contribution_model.dart';
import 'package:tisini/features/pensions/data/models/pension_status_model.dart';

class MockPensionRemoteDatasource implements PensionRemoteDatasource {
  static const _readDelay = Duration(milliseconds: 300);
  static const _writeDelay = Duration(milliseconds: 800);

  static final _now = DateTime.now();

  static final _contributions = [
    PensionContributionModel(
      id: 'pc-001',
      amount: 5000000,
      currency: 'UGX',
      status: 'completed',
      rail: 'mobile_money',
      reference: 'NSSF Jan 2026',
      createdAt: DateTime(2026).millisecondsSinceEpoch,
      completedAt: DateTime(2026).millisecondsSinceEpoch,
    ),
    PensionContributionModel(
      id: 'pc-002',
      amount: 5000000,
      currency: 'UGX',
      status: 'completed',
      rail: 'mobile_money',
      reference: 'NSSF Feb 2026',
      createdAt: DateTime(2026, 2).millisecondsSinceEpoch,
      completedAt: DateTime(2026, 2).millisecondsSinceEpoch,
    ),
    PensionContributionModel(
      id: 'pc-003',
      amount: 5000000,
      currency: 'UGX',
      status: 'pending',
      rail: 'mobile_money',
      reference: 'NSSF Mar 2026',
      createdAt: DateTime(2026, 3).millisecondsSinceEpoch,
    ),
  ];

  @override
  Future<PensionStatusModel> getPensionStatus() async {
    await Future<void>.delayed(_readDelay);

    final dueDate = _now.add(const Duration(days: 5));

    return PensionStatusModel(
      linkStatus: 'linked',
      currency: 'UGX',
      totalContributions: 3,
      totalAmount: 15000000,
      nssfNumber: 'NSSF-UG-123456',
      nextDueDate: dueDate.millisecondsSinceEpoch,
      nextDueAmount: 5000000,
      activeReminders: [
        PensionReminderModel(
          id: 'rem-001',
          reminderDate: dueDate
              .subtract(const Duration(days: 2))
              .millisecondsSinceEpoch,
          isActive: true,
          amount: 5000000,
        ),
      ],
    );
  }

  @override
  Future<PensionContributionModel> submitContribution({
    required double amount,
    required String currency,
    required String rail,
    required String reference,
  }) async {
    await Future<void>.delayed(_writeDelay);
    final now = DateTime.now().millisecondsSinceEpoch;

    return PensionContributionModel(
      id: 'pc-${now.hashCode.abs()}',
      amount: amount,
      currency: currency,
      status: 'completed',
      rail: rail,
      reference: reference,
      createdAt: now,
      completedAt: now,
    );
  }

  @override
  Future<
    ({
      List<PensionContributionModel> contributions,
      String? nextCursor,
      bool hasMore,
    })
  >
  getContributions({String? cursor, int limit = 20}) async {
    await Future<void>.delayed(_readDelay);

    return (contributions: _contributions, nextCursor: null, hasMore: false);
  }

  @override
  Future<PensionLinkStatus> linkNssf({required String nssfNumber}) async {
    await Future<void>.delayed(_writeDelay);
    return PensionLinkStatus.linked;
  }

  @override
  Future<PensionReminderModel> setReminder({
    required DateTime reminderDate,
    double? amount,
  }) async {
    await Future<void>.delayed(_writeDelay);

    return PensionReminderModel(
      id: 'rem-${DateTime.now().millisecondsSinceEpoch.hashCode.abs()}',
      reminderDate: reminderDate.millisecondsSinceEpoch,
      isActive: true,
      amount: amount,
    );
  }
}
