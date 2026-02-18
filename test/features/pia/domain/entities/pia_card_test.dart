import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pia/domain/entities/pia_action.dart';
import 'package:tisini/features/pia/domain/entities/pia_card.dart';

void main() {
  group('PiaCard', () {
    test('creates with required fields', () {
      final card = PiaCard(
        id: 'pia-001',
        title: 'Tax deadline approaching',
        what: 'URA filing deadline is in 5 days',
        why: 'Avoid penalties and maintain compliance score',
        details: 'Your quarterly VAT return is due on June 20',
        actions: const [
          PiaAction(
            id: 'action-001',
            type: PiaActionType.setReminder,
            label: 'Set reminder',
          ),
        ],
        priority: PiaCardPriority.high,
        status: PiaCardStatus.active,
        isPinned: false,
        createdAt: DateTime(2025, 6, 15),
      );

      expect(card.id, 'pia-001');
      expect(card.title, 'Tax deadline approaching');
      expect(card.what, contains('deadline'));
      expect(card.why, contains('compliance'));
      expect(card.actions, hasLength(1));
      expect(card.priority, PiaCardPriority.high);
      expect(card.status, PiaCardStatus.active);
      expect(card.isPinned, false);
    });

    test('supports value equality', () {
      final now = DateTime(2025, 6, 15);
      final a = PiaCard(
        id: 'pia-001',
        title: 'Title',
        what: 'What',
        why: 'Why',
        details: 'Details',
        actions: const [],
        priority: PiaCardPriority.medium,
        status: PiaCardStatus.active,
        isPinned: true,
        createdAt: now,
      );
      final b = PiaCard(
        id: 'pia-001',
        title: 'Title',
        what: 'What',
        why: 'Why',
        details: 'Details',
        actions: const [],
        priority: PiaCardPriority.medium,
        status: PiaCardStatus.active,
        isPinned: true,
        createdAt: now,
      );

      expect(a, equals(b));
    });

    test('supports copyWith', () {
      final card = PiaCard(
        id: 'pia-001',
        title: 'Title',
        what: 'What',
        why: 'Why',
        details: 'Details',
        actions: const [],
        priority: PiaCardPriority.low,
        status: PiaCardStatus.active,
        isPinned: false,
        createdAt: DateTime(2025, 6, 15),
      );

      final pinned = card.copyWith(isPinned: true);
      expect(pinned.isPinned, true);
      expect(pinned.id, 'pia-001');
    });
  });
}
