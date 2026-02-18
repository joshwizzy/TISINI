import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/home/domain/entities/attention_item.dart';

void main() {
  group('AttentionItem', () {
    test('creates with required fields', () {
      final item = AttentionItem(
        id: 'att-001',
        title: 'Complete KYC',
        description: 'Verify your identity to unlock full features',
        actionLabel: 'Start verification',
        actionRoute: '/kyc',
        priority: PiaCardPriority.high,
        createdAt: DateTime(2025, 6, 15),
      );

      expect(item.id, 'att-001');
      expect(item.title, 'Complete KYC');
      expect(item.description, contains('identity'));
      expect(item.actionLabel, 'Start verification');
      expect(item.actionRoute, '/kyc');
      expect(item.priority, PiaCardPriority.high);
    });

    test('supports value equality', () {
      final now = DateTime(2025, 6, 15);
      final a = AttentionItem(
        id: 'att-001',
        title: 'Complete KYC',
        description: 'Verify identity',
        actionLabel: 'Start',
        actionRoute: '/kyc',
        priority: PiaCardPriority.high,
        createdAt: now,
      );
      final b = AttentionItem(
        id: 'att-001',
        title: 'Complete KYC',
        description: 'Verify identity',
        actionLabel: 'Start',
        actionRoute: '/kyc',
        priority: PiaCardPriority.high,
        createdAt: now,
      );

      expect(a, equals(b));
    });
  });
}
