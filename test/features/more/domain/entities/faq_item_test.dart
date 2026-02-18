import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/more/domain/entities/faq_item.dart';

void main() {
  group('FaqItem', () {
    test('creates with required fields', () {
      const faq = FaqItem(
        question: 'How do I send money?',
        answer: 'Tap Send on the Pay screen.',
      );

      expect(faq.question, 'How do I send money?');
      expect(faq.answer, 'Tap Send on the Pay screen.');
    });

    test('supports value equality', () {
      const a = FaqItem(
        question: 'How do I send money?',
        answer: 'Tap Send on the Pay screen.',
      );
      const b = FaqItem(
        question: 'How do I send money?',
        answer: 'Tap Send on the Pay screen.',
      );

      expect(a, equals(b));
    });
  });
}
