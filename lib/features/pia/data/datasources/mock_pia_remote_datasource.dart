import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pia/data/datasources/pia_remote_datasource.dart';
import 'package:tisini/features/pia/data/models/pia_action_model.dart';
import 'package:tisini/features/pia/data/models/pia_card_model.dart';

class MockPiaRemoteDatasource implements PiaRemoteDatasource {
  static const _readDelay = Duration(milliseconds: 300);
  static const _writeDelay = Duration(milliseconds: 800);

  static final _now = DateTime.now();

  final List<PiaCardModel> _cards = [
    PiaCardModel(
      id: 'pia-001',
      title: 'Pension due soon',
      what: 'Your NSSF contribution is due in 5 days',
      why:
          'Paying on time avoids late penalties and '
          'keeps your compliance score high',
      details:
          'Amount: UGX 5,000,000. '
          'Due date: ${_now.add(const Duration(days: 5))}',
      actions: const [
        PiaActionModel(
          id: 'a-001',
          type: 'schedule_payment',
          label: 'Schedule payment',
          params: {'payeeName': 'NSSF'},
        ),
      ],
      priority: 'high',
      status: 'active',
      isPinned: false,
      createdAt: _now.subtract(const Duration(hours: 2)).millisecondsSinceEpoch,
    ),
    PiaCardModel(
      id: 'pia-002',
      title: 'Tax filing deadline',
      what: 'URA tax filing closes in 10 days',
      why:
          'Filing late results in penalties '
          'and may affect your business standing',
      details:
          'Deadline: '
          '${_now.add(const Duration(days: 10))}',
      actions: const [
        PiaActionModel(
          id: 'a-002',
          type: 'set_reminder',
          label: 'Set reminder',
        ),
      ],
      priority: 'high',
      status: 'active',
      isPinned: false,
      createdAt: _now.subtract(const Duration(hours: 5)).millisecondsSinceEpoch,
    ),
    PiaCardModel(
      id: 'pia-003',
      title: 'New supplier detected',
      what:
          'You paid "Kampala Hardware" for '
          'the first time',
      why:
          'Categorising suppliers helps Pia '
          'track your spending patterns',
      details:
          'Payment of UGX 350,000 on '
          '${_now.subtract(const Duration(days: 1))}',
      actions: const [
        PiaActionModel(
          id: 'a-003',
          type: 'ask_user_confirmation',
          label: 'Confirm supplier',
          params: {
            'question':
                'Is Kampala Hardware '
                'a regular supplier?',
          },
        ),
      ],
      priority: 'medium',
      status: 'active',
      isPinned: false,
      createdAt: _now.subtract(const Duration(days: 1)).millisecondsSinceEpoch,
    ),
    PiaCardModel(
      id: 'pia-004',
      title: 'Payment pattern change',
      what:
          'Your rent payment was 20% higher '
          'than usual',
      why:
          'Tracking changes helps you budget '
          'and spot anomalies early',
      details:
          'Paid UGX 1,200,000 vs usual '
          'UGX 1,000,000',
      actions: const [
        PiaActionModel(
          id: 'a-004',
          type: 'ask_user_confirmation',
          label: 'Acknowledge',
          params: {
            'question':
                'Was this rent increase '
                'expected?',
          },
        ),
      ],
      priority: 'medium',
      status: 'active',
      isPinned: false,
      createdAt: _now.subtract(const Duration(days: 2)).millisecondsSinceEpoch,
    ),
    PiaCardModel(
      id: 'pia-005',
      title: 'Export monthly report',
      what:
          'Your January 2026 report is ready '
          'to export',
      why:
          'Regular exports keep your records '
          'backed up and accessible',
      details:
          '47 transactions totalling '
          'UGX 12,500,000',
      actions: const [
        PiaActionModel(
          id: 'a-005',
          type: 'prepare_export',
          label: 'Export now',
        ),
      ],
      priority: 'low',
      status: 'active',
      isPinned: false,
      createdAt: _now.subtract(const Duration(days: 3)).millisecondsSinceEpoch,
    ),
    PiaCardModel(
      id: 'pia-006',
      title: 'Rent payment reminder',
      what: 'Rent for February is due in 3 days',
      why:
          'Timely rent payments maintain your '
          'payment consistency score',
      details:
          'Amount: UGX 1,000,000. '
          'Payee: Landlord Properties Ltd',
      actions: const [
        PiaActionModel(id: 'a-006', type: 'set_reminder', label: 'Remind me'),
        PiaActionModel(
          id: 'a-007',
          type: 'schedule_payment',
          label: 'Schedule',
          params: {'payeeName': 'Landlord Properties Ltd'},
        ),
      ],
      priority: 'low',
      status: 'active',
      isPinned: false,
      createdAt: _now.subtract(const Duration(days: 4)).millisecondsSinceEpoch,
    ),
    PiaCardModel(
      id: 'pia-007',
      title: 'NSSF contribution schedule',
      what: 'Your quarterly NSSF schedule is set up',
      why:
          'Automated schedules ensure you '
          'never miss a deadline',
      details:
          'Next 3 contributions scheduled: '
          'Mar, Jun, Sep 2026',
      actions: const [
        PiaActionModel(
          id: 'a-008',
          type: 'schedule_payment',
          label: 'View schedule',
          params: {'payeeName': 'NSSF'},
        ),
      ],
      priority: 'medium',
      status: 'active',
      isPinned: true,
      createdAt: _now.subtract(const Duration(days: 7)).millisecondsSinceEpoch,
    ),
  ];

  @override
  Future<({List<PiaCardModel> cards, String? nextCursor, bool hasMore})>
  getCards({String? cursor, int limit = 20}) async {
    await Future<void>.delayed(_readDelay);

    final active = _cards.where((c) => c.status != 'dismissed').toList();

    final startIndex = cursor != null
        ? active.indexWhere((c) => c.id == cursor) + 1
        : 0;

    final end = (startIndex + limit).clamp(0, active.length);
    final page = active.sublist(startIndex, end);
    final hasMore = end < active.length;
    final nextCursor = hasMore ? page.last.id : null;

    return (cards: page, nextCursor: nextCursor, hasMore: hasMore);
  }

  @override
  Future<PiaCardModel> getCard(String id) async {
    await Future<void>.delayed(_readDelay);

    return _cards.firstWhere(
      (c) => c.id == id,
      orElse: () => throw Exception('Card not found: $id'),
    );
  }

  @override
  Future<String> executeAction({
    required String cardId,
    required String actionId,
    Map<String, dynamic> params = const {},
  }) async {
    await Future<void>.delayed(_writeDelay);

    final card = _cards.firstWhere(
      (c) => c.id == cardId,
      orElse: () => throw Exception('Card not found: $cardId'),
    );

    final action = card.actions.firstWhere(
      (a) => a.id == actionId,
      orElse: () => throw Exception('Action not found: $actionId'),
    );

    return 'Action "${action.label}" completed '
        'for "${card.title}"';
  }

  @override
  Future<PiaCardModel> updateCard(
    String id, {
    PiaCardStatus? status,
    bool? isPinned,
  }) async {
    await Future<void>.delayed(_writeDelay);

    final index = _cards.indexWhere((c) => c.id == id);
    if (index == -1) {
      throw Exception('Card not found: $id');
    }

    final current = _cards[index];
    final updated = PiaCardModel(
      id: current.id,
      title: current.title,
      what: current.what,
      why: current.why,
      details: current.details,
      actions: current.actions,
      priority: current.priority,
      status: status?.name ?? current.status,
      isPinned: isPinned ?? current.isPinned,
      createdAt: current.createdAt,
    );

    _cards[index] = updated;
    return updated;
  }
}
